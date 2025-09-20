// FreezeRules controls Zed freezing on server side.
// FreezeReplicationInfo is used to replciate freezing effects to clients.

class FreezeRules extends GameRules;

var ScrnGameRules ScrnGameRules;

var FreezeReplicationInfo FreezeRI;
var float FreezeTimerRate; // how often check for freezing
var float FreezeTreshold; // % of HealthMax to be done to fully freeze zed
var float FrozenDamageResistance; // frozen zed gets less damage
var float FrozenDamageMult;       // but it is possible to break the ice and instant kill zed
var float FrozenDamageMultHS;     // damage that can do headshots does more damage to ice
var float FrozenDamageMultSG;     // shotgun-specific damage mult
var int   FrozenDoT;              // damage per second a frozen zed receives from cold
// How much damage ice darts should do per shattered zed health.
// SonicShatterDamagePerHealth isn't scaled by the difficulty since the zed health already is
var float SonicShatterDamagePerHealth;
var int   SonicShatterMaxDamage;  // max damage that shattering one zed can cause on Normal difficulty

var class<Emitter> ShatteredIce;
var class<Projectile> ShatterProjClass;
var transient PlayerController LastShatteredBy; //last player who shattered zed
var transient float LastShaterTime;
var transient int InstantShatterCounter;
var transient float NextChainsawTime;
var transient float NextSirenScreamTime;

var bool bDosh;

struct SFrozen {
    var KFMonster M;
    var KFPlayerController LastFrozenBy;
    var class<DamTypeFreezerBase> LastFrozenDamType;
    var float LastFrozenTime;
    var bool bFrozen, bWasFrozen;
    var float CurrentFreeze;
    var float FreezeTreshold; // when CurrentFreeze reaches this value, zed becomes completely frozen
    // FoT: Freeze over Time
    var float FoT;
    var float FoT_Remaining;
    var float WarmTime; // time after which zed should get warmed up
    var float NextDamageTime;

    var int Damage; // damage done during freeze
    var vector FocalPoint;
};
var transient array<SFrozen> Frozen;


final static function FreezeRules FindOrSpawnMe(GameInfo Game)
{
    local GameRules GR;
    local FreezeRules FR;

    FR = FreezeRules(Game.GameRulesModifiers);
    if ( FR == none ) {

        for ( GR = Game.GameRulesModifiers; GR != none && FR == none; GR = GR.NextGameRules )
            FR = FreezeRules(Game.GameRulesModifiers);

        // Freeze rules not found. Spawn it now
        if ( FR == none ) {
            FR = Game.Spawn(Class'FreezeRules', Game);
            if( Game.GameRulesModifiers==None )
                Game.GameRulesModifiers = FR;
            else
                Game.GameRulesModifiers.AddGameRules(FR);
        }
    }

    return FR;
}


function PostBeginPlay()
{
    FreezeRI = spawn(class'FreezeReplicationInfo', self);
}

function AddGameRules(GameRules GR)
{
    if ( GR.class != self.class ) //prevent adding same rules more than once
        Super.AddGameRules(GR);
}

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy,
    vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
    local class<KFWeaponDamageType> KFDamType;
    local class<DamTypeFreezerBase> FreezeDT;
    local KFPlayerController PC;
    local KFPlayerReplicationInfo KFPRI;
    local class<KFVeterancyTypes> Perk;
    local KFMonster ZedVictim;
    local int idx;

    KFDamType = class<KFWeaponDamageType>(damageType);
    ZedVictim = KFMonster(injured);
    if ( instigatedBy != none )
        PC = KFPlayerController(instigatedBy.Controller);
    if ( PC != none )
        KFPRI = KFPlayerReplicationInfo(PC.PlayerReplicationInfo);
    if ( KFPRI != none )
        Perk = KFPRI.ClientVeteranSkill;
    else
        Perk = class'KFVeterancyTypes';

    if ( KFDamType != none && ZedVictim != none && ZedVictim.Controller != none  && ZedVictim.Health > 0 ) {
        FreezeDT = class<DamTypeFreezerBase>(damageType);
        if ( FreezeDT != none ) {
            if ( ZedVictim.bBurnified ) {
                ZedVictim.BurnDown /= 2;
                if ( ZedVictim.BurnDown == 0 ) {
                    ZedVictim.bBurnified = false;
                    ZedVictim.Timer(); // stop burning behavior
                }
            }

            if ( !ZedVictim.bBurnified && FreezeDT.default.FreezeRatio > 0.0 ) {
                idx = FrozenIndex(ZedVictim, true);
                Frozen[idx].CurrentFreeze += Damage * FreezeDT.default.FreezeRatio;
                if ( Frozen[idx].bFrozen ) {
                    Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 0.5);
                    // allow shattering for ice darts
                    if ( FreezeDT.default.bCheckForHeadShots ) {
                        Damage *= FrozenDamageResistance * FreezeDT.default.HeadShotDamageMult
                            * FreezeDT.default.ShatteringDamageMult;
                        Frozen[idx].Damage += Damage * FrozenDamageMultHS;
                        if ( ZedVictim.Health <= Damage + Frozen[idx].Damage ) {
                            Damage += Frozen[idx].Damage;
                            ShatterZed(ZedVictim, idx, instigatedBy.Controller, DamageType);
                        }
                    }
                    else
                        Damage = 0;
                }
                else {
                    Frozen[idx].LastFrozenBy = PC;
                    Frozen[idx].LastFrozenDamType = FreezeDT;
                    // Freeze over Time
                    if ( FreezeDT.default.FoT_Duration > 0 && (Frozen[idx].FoT_Remaining < 0.5
                            || Frozen[idx].FoT < Damage * FreezeDT.default.FoT_Ratio) )
                    {
                        Frozen[idx].FoT_Remaining = FreezeDT.default.FoT_Duration;
                        Frozen[idx].FoT = Damage * FreezeDT.default.FoT_Ratio;
                    }
                    if ( Frozen[idx].CurrentFreeze >= Frozen[idx].FreezeTreshold ) {
                        // enough damage to freeze zed
                        FreezeZed(ZedVictim, idx);
                        Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 2.0);
                    }
                    else
                        Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 1.0);
                }
            }
            //debug
            // Level.GetLocalPlayerController().ClientMessage(Frozen[idx].CurrentFreeze $" / "$ Frozen[idx].FreezeTreshold);
        }
        else {
            idx = FrozenIndex(ZedVictim, false);
            if ( idx != -1 ) {
                if ( KFDamType == class'SirenScreamDamage' && Frozen[idx].bFrozen ) {
                    SonicShatterZed(ZedVictim, instigatedBy, KFDamType);
                }
                else if ( KFDamType.default.bDealBurningDamage ) {
                    // fire instantly unfreezes zed
                    if ( Frozen[idx].bFrozen )
                        UnfreezeZed(ZedVictim, idx);
                    Frozen.remove(idx, 1);
                }
                else if ( Frozen[idx].bFrozen ) {
                    if ( KFDamType.default.bCheckForHeadShots && class<DamTypeCrossbuzzsaw>(KFDamType) == none ) {
                        Damage *= KFDamType.default.HeadShotDamageMult;
                        if ( KFDamType.default.bIsPowerWeapon || KFDamType.default.bIsMeleeDamage ) {
                            Frozen[idx].Damage += Damage * FrozenDamageMultSG;
                            if ( ClassIsChildOf(KFDamType, class'DamTypeChainsaw')
                                    && Level.TimeSeconds > NextChainsawTime )
                            {
                                ProgressAchievement(PC, 'Freeze_Chainsaw', 1);
                                ProgressAchievement(Frozen[idx].LastFrozenBy, 'Freeze_Chainsaw', 1);
                                NextChainsawTime = Level.TimeSeconds + 1;
                            }
                        }
                        else
                            Frozen[idx].Damage += Damage * FrozenDamageMultHS;
                    }
                    else
                        Frozen[idx].Damage += Damage * FrozenDamageMult;
                    Damage *= FrozenDamageResistance;
                    if ( ZedVictim.Health <= Damage + Frozen[idx].Damage ) {
                        Damage += Frozen[idx].Damage;
                        ShatterZed(ZedVictim, idx, instigatedBy.Controller, DamageType);
                    }
                }
            }
        }
    }

    if ( NextGameRules != None )
        return NextGameRules.NetDamage( OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType);

    return Damage;
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local KFMonster M;
    local PlayerController Zapper;

    if ( (NextGameRules != None) && NextGameRules.PreventDeath(Killed,Killer, damageType,HitLocation) )
        return true;

    M = KFMonster(Killed);
    if ( M != none && M.ZappedBy != none )
        Zapper = PlayerController(M.ZappedBy.Controller);
    // killing zapped zed gives perk progression to zapper
    if ( Zapper != none && SRStatsBase(Zapper.SteamStatsAndAchievements) != none
            && SRStatsBase(Zapper.SteamStatsAndAchievements).Rep != none )
        SRStatsBase(Zapper.SteamStatsAndAchievements).Rep.ProgressCustomValue(Class'HTecProg', max(1, M.default.ZapThreshold * 4.01));

    return false;
}

function bool IsFrozen(KFMonster M)
{
    return M.bFrozenBody;
}

function int FrozenIndex(KFMonster M, bool bCreate)
{
    local int i;

    if (M == none)
        return -1;

    for ( i=0; i < Frozen.length; ++i )
        if ( Frozen[i].M == M )
            return i;

    if ( bCreate ) {
        Frozen.insert(i, 1);
        Frozen[i].M = M;
        Frozen[i].FreezeTreshold = M.HealthMax * FreezeTreshold;
        Frozen[i].WarmTime = Level.TimeSeconds + 2.0;
        if ( TimerRate == 0 ) {
            SetTimer(FreezeTimerRate, true);
            NextSirenScreamTime = Level.TimeSeconds + 2.0;
        }
        return i;
    }

    return -1;
}

function int GetFrozenCount()
{
    local int i, c;

    for ( i=0; i < Frozen.length; ++i )
        if ( Frozen[i].bFrozen && Frozen[i].M != none && Frozen[i].M.Health > 0 )
            ++c;

    return c;
}

function Timer()
{
    local int i;
    local bool bRemove;
    local byte FrozenCount;
    local KFMonster M;

    for ( i = Frozen.length - 1; i >= 0; --i ) {
        M = Frozen[i].M;
        bRemove = M == none || M.Health <= 0;

        if (!bRemove && Frozen[i].bFrozen && Level.TimeSeconds > Frozen[i].NextDamageTime && Frozen[i].LastFrozenBy != none) {
            Frozen[i].NextDamageTime = Level.TimeSeconds + 0.99;
            M.TakeDamage(FrozenDoT, Frozen[i].LastFrozenBy.Pawn, M.Location, vect(0, 0, 0),
                    class'DamTypeFreezerDoT');
            bRemove = M == none || M.Health <= 0;
            if (!bRemove) {
                // fix stalker clock glitch
                M.SetOverlayMaterial(FreezeRI.FrozenMaterial, 999, true);
            }
        }

        if (!bRemove) {
            if ( Frozen[i].FoT_Remaining > 0 ) {
                Frozen[i].CurrentFreeze += Frozen[i].FoT * FreezeTimerRate;
                Frozen[i].FoT_Remaining -= FreezeTimerRate;
                Frozen[i].WarmTime = fmax(Frozen[i].WarmTime, Level.TimeSeconds + 1.0);
                if ( !Frozen[i].bFrozen && Frozen[i].CurrentFreeze >= Frozen[i].FreezeTreshold ) {
                    FreezeZed(M, i);
                }
            }
            else {
                if ( Frozen[i].CurrentFreeze > 0 && Level.TimeSeconds >= Frozen[i].WarmTime ) {
                    Frozen[i].CurrentFreeze -= fmax(Frozen[i].CurrentFreeze * 0.2, 20.0) * FreezeTimerRate;
                    if ( Frozen[i].bFrozen && Frozen[i].CurrentFreeze < Frozen[i].FreezeTreshold ) {
                        UnfreezeZed(M, i);
                        Frozen[i].Damage = 0;
                        Frozen[i].CurrentFreeze *= 0.80;
                    }
                    if ( Frozen[i].CurrentFreeze <= 0 )
                        bRemove = true;
                }
            }

            if (Frozen[i].bFrozen) {
                FrozenCount++;
                if (M.IsAnimating(0) || M.IsAnimating(1)) {
                    FreezeZed(M, i);
                }
                else if ( M.Controller != none ) {
                    // prevent rotating
                    M.Controller.FocalPoint = Frozen[i].FocalPoint;
                    M.Controller.Enemy = none;
                    M.Controller.Focus = none;
                }
            }
        }

        if ( bRemove )
            Frozen.Remove(i, 1);
    }

    if ( FrozenCount != FreezeRI.FrozenCount ) {
        FreezeRI.FrozenCount = FrozenCount;
        FreezeRI.NetUpdateTime = Level.TimeSeconds - 1;
    }

    if ( Frozen.length == 0 ) {
        SetTimer(0, false);
    }
    else if ( FrozenCount > 0 && Level.TimeSeconds > NextSirenScreamTime ) {
        NextSirenScreamTime = Level.TimeSeconds + 1.0;
        TrySirenScream();
    }
}

function TrySirenScream() {
    local int i, j;
    local ZedBaseSiren Siren;
    local array<ZedBaseSiren> Sirens;
    local array<int> NumFrozenReachable;
    local int BestNum, BestIdx, TotalNum;

    for (i = 0; i < ScrnGameRules.MonsterInfos.Length; ++i ) {
        Siren = ZedBaseSiren(ScrnGameRules.MonsterInfos[i].Monster);
        if ( Siren != none && Siren.Controller != none && Siren.Health > 0 && !Siren.bDecapitated && !Siren.bZapped
                && !Siren.bShotAnim && !Siren.bFrozenBody ) {
            Sirens[Sirens.Length] = Siren;
        }
    }
    if ( Sirens.Length == 0 ) {
        return;
    }

    NumFrozenReachable.length = Sirens.Length;
    for ( i = 0; i < Frozen.length; ++i ) {
        if ( !Frozen[i].bFrozen || Level.TimeSeconds < Frozen[i].LastFrozenTime + 2.0 )
            continue;

        for ( j = 0; j < Sirens.Length; ++j ) {
            Siren = Sirens[j];
            if ( VSizeSquared(Siren.Location - Frozen[i].M.Location) < Siren.ScreamRadiusSq
                    && Siren.Controller.LineOfSightTo(Frozen[i].M) )
            {
                ++TotalNum;
                if ( ++NumFrozenReachable[j] > BestNum ) {
                    BestNum = NumFrozenReachable[j];
                    BestIdx = j;
                }
            }
        }
    }

    if ( BestNum > 0 && TotalNum * frand() > 0.8 ) {
        Siren = Sirens[BestIdx];
        Siren.bShotAnim = true;
        Siren.SetAnimAction('Siren_Scream');
        NextSirenScreamTime = Level.TimeSeconds + 2.0 + 3.0*frand();
    }
}

// call it only if zed isn't frozen yet
function FreezeZed(KFMonster M, int FrozenIndex)
{
    if ( !Frozen[FrozenIndex].bFrozen ) {
        Frozen[FrozenIndex].bFrozen = true;
        Frozen[FrozenIndex].LastFrozenTime = Level.TimeSeconds;
        if ( !Frozen[FrozenIndex].bWasFrozen ) {
            Frozen[FrozenIndex].bWasFrozen = true;
            if ( ZombieCrawler(M) != none && M.Physics == PHYS_Falling )
                ProgressAchievement(Frozen[FrozenIndex].LastFrozenBy, 'Freeze_CR', 1);
            else if ( ZombieFleshpound(M) != none )
                ProgressAchievement(Frozen[FrozenIndex].LastFrozenBy, 'Freeze_FP', 1);
            else if ( ZombieBoss(M) != none )
                ProgressAchievement(Frozen[FrozenIndex].LastFrozenBy, 'Freeze_Pat', 1);
            ProgressAchievement(Frozen[FrozenIndex].LastFrozenBy, 'Freeze_IceAge', 1);
        }
    }
    if ( Frozen.length >= 20 && GetFrozenCount() >= 20 )
        ScrnGameRules.ProgressAchievementForAllPlayers('Freeze_Festival', 1, true);

    M.SetOverlayMaterial(FreezeRI.FrozenMaterial, 999, true);
    Frozen[FrozenIndex].FocalPoint = M.Location + 512*vector(M.Rotation);
    M.bFrozenBody = true;
    M.Velocity = M.PhysicsVolume.Gravity;
    M.AnimAction = '';
    M.bShotAnim = true;
    M.bWaitForAnim = true;
    M.Disable('AnimEnd');
    class'FreezeReplicationInfo'.static.RemoveAnimations(M);
    M.Acceleration = vect(0, 0, 0);
    M.SetTimer(0, false);
    M.StopAnimating();

    if ( M.HeadRadius > 0 )
        M.HeadRadius = -M.HeadRadius; // disable headshots

    if ( M.Controller != none ) {
        M.Controller.FocalPoint = Frozen[FrozenIndex].FocalPoint;
        M.Controller.Enemy = none;
        M.Controller.Focus = none;
        if ( !M.Controller.IsInState('WaitForAnim') )
            M.Controller.GoToState('WaitForAnim');
        KFMonsterController(M.Controller).bUseFreezeHack = True;
    }
}

function UnfreezeZed(KFMonster M, int FrozenIndex)
{
    Frozen[FrozenIndex].bFrozen = false;

    if ( M == none || M.Controller == none || M.Health <= 0 )
        return;

    M.SetOverlayMaterial(none, 0.1, true);

    if ( M.HeadRadius < 0 )
        M.HeadRadius = -M.HeadRadius; //enable headshots
    M.bFrozenBody = false;
    M.bShotAnim = false;
    M.bWaitForAnim = false;
    M.Enable('AnimEnd');
    class'FreezeReplicationInfo'.static.RestoreAnimations(M);
    M.AnimEnd(1);
    M.AnimEnd(0);
    //KFMonsterController(M.Controller).WhatToDoNext(99);
    M.Controller.GotoState('ZombieHunt');
    M.GroundSpeed = M.GetOriginalGroundSpeed();
    // this should "wake up" raged scrakes
    M.TakeDamage(1, M, M.Location, vect(0,0,0), class'DamTypeFreezerDoT');
}

function bool ShatterZed(KFMonster ZedVictim, int FrozenIdx, Controller Killer, class<DamageType> DamageType)
{
    local vector loc;
    local rotator r;
    local FrozenDosh Dosh, PrevDosh, HeadDosh;
    local int i;
    local int MaxDosh;
    local KFPlayerReplicationInfo KFPRI;
    local SRStatsBase FreezerStats;

    if ( FrozenIdx < 0 )
        FrozenIdx = FrozenIndex(ZedVictim, false);
    if ( FrozenIdx < 0 )
        return false; // zed is not frozen

    if ( Killer != none )
        KFPRI = KFPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    FreezerStats = SRStatsBase(Frozen[FrozenIdx].LastFrozenBy.SteamStatsAndAchievements);
    loc = ZedVictim.Location;

    if ( KFPRI != none ) {
        if ( bDosh && !ZedVictim.bDecapitated ) {
            if ( KFPRI.ClientVeteranSkill != none )
                MaxDosh = KFPRI.ClientVeteranSkill.static.GetCostScaling(KFPRI, class'FrozenDosh')
                    * 0.2 * ZedVictim.ScoringValue;
            else
                MaxDosh = ZedVictim.ScoringValue / 5;
        }

        if ( LastShatteredBy == Killer && LastShaterTime == Level.TimeSeconds ) {
            if ( ++InstantShatterCounter == 10 ) {
                ProgressAchievement(PlayerController(Killer), 'Freeze_Storm', 1);
                InstantShatterCounter = 0;
            }
        }
        else {
            LastShatteredBy = PlayerController(Killer);
            LastShaterTime = Level.TimeSeconds;
            InstantShatterCounter = 1;
        }
    }
    else {
        LastShatteredBy = none;
    }

    if ( FreezerStats != none && !ZedVictim.bDecapitated ) {
        FreezerStats.Rep.ProgressCustomValue(Class'HTecProg', max(1, ZedVictim.HealthMax / 500));

        if ( LastShatteredBy != none && LastShatteredBy != Frozen[FrozenIdx].LastFrozenBy ) {
            class'ScrnAchCtrl'.static.ProgressAchievementByID(FreezerStats.Rep, 'Freeze_ShatterZeds', 1);
            ProgressAchievement(LastShatteredBy, 'Freeze_ShatterZeds', 1);
        }
    }
    if ( ZombieBoss(ZedVictim) != none )
        ScrnGameRules.ProgressAchievementForAllPlayers('Freeze_ShatterPat', 1, true);

    Spawn(ShatteredIce,,,loc);
    ZedVictim.bFrozenBody = false;
    ZedVictim.bHidden = true;
    ZedVictim.Died(Killer, DamageType, loc );

    // DO$H DO$H DO$H DO$H DO$H
    if ( MaxDosh > 0 ) {
        r = ZedVictim.GetViewRotation();
        for ( i=0; i<5; ++i ) {
            Dosh = Spawn(class'FrozenDosh',,, loc);
            if ( Dosh != none ) {
                // link all doshes together
                if ( HeadDosh == none )
                    HeadDosh = Dosh;
                Dosh.HeadDosh = HeadDosh;
                if ( PrevDosh != none )
                    PrevDosh.NextDosh = Dosh;

                Dosh.CashAmount = 1 + rand(MaxDosh);
                Dosh.RespawnTime = 0;
                Dosh.bDroppedCash = True;
                if ( Killer == Frozen[FrozenIdx].LastFrozenBy )
                    Dosh.DroppedBy = Killer;
                Dosh.Velocity = Vector(r) * 100;
                Dosh.Velocity.Z += 500;
                Dosh.InitDroppedPickupFor(None);
                PrevDosh = Dosh;
            }
            r.Yaw += 13107;
        }
    }
    return true;
}

// turns frozen monster into deadly ice shards
function SonicShatterZed(KFMonster ZedVictim, Pawn instigatedBy, class<KFWeaponDamageType> DamageType)
{
    local vector HitLocation, ProjLoc;
    local float ColH, ColR, DiffMult;
    local int Damage, c;
    local Projectile proj;

    if ( instigatedBy == none || instigatedBy == ZedVictim )
        return;

    // save zed's data, because it will be dead after shattering
    HitLocation = ZedVictim.Location; // calculate shard offset from the center of zed, not where it got hit
    ColH = ZedVictim.CollisionHeight;
    ColR = ZedVictim.CollisionRadius;
    DiffMult = ZedVictim.DifficultyDamageModifer();
    Damage = min(ZedVictim.Health * SonicShatterDamagePerHealth, SonicShatterMaxDamage * DiffMult);

    if ( !ShatterZed(ZedVictim, -1, instigatedBy.Controller, DamageType) )
        return; // unable to shatter zed

    if ( ZedVictim != none ) {
        if ( ZedVictim.MyExtCollision != none )
            ZedVictim.ToggleAuxCollision(false);
        ZedVictim.SetCollision(false);
    }

    ProjLoc = HitLocation; // first projectile always spawn in the center to fly a straight line
    while (Damage >= ShatterProjClass.default.Damage && ++c <= 20) {
        proj = instigatedBy.Spawn(ShatterProjClass, instigatedBy, , ProjLoc, rotator(ProjLoc - instigatedBy.Location));
        if ( proj != none ) {
            proj.Instigator = instigatedBy;
            proj.Damage *= DiffMult * (1.0 + frand());
            Damage -= proj.Damage;
            if (Damage < proj.default.Damage) {
                proj.Damage += Damage;
                Damage = 0;
            }
            // Level.GetLocalPlayerController().ClientMessage(ShatterProjClass $ " #" $ c $ " Damage=" $ proj.Damage, 'log');
        }
        // pick a random location inside the collision cylinder for the next projectile
        ProjLoc = HitLocation;
        ProjLoc.X += ColR * (0.90 - 1.8 * frand());
        ProjLoc.Y += ColR * (0.90 - 1.8 * frand());
        ProjLoc.Z += ColH * (0.50 - 1.0 * frand());
    }
}

function bool ProgressAchievement(PlayerController PC, name ID, int Prog)
{
    return class'ScrnAchCtrl'.static.Ach2Player(PC, ID, Prog);
}


defaultproperties
{
    FreezeTimerRate=0.2
    FreezeTreshold=0.333333
    FrozenDamageResistance=0.500000
    FrozenDamageMult=1.500000
    FrozenDamageMultHS=4.500000
    FrozenDamageMultSG=2.500000
    FrozenDoT=24
    SonicShatterDamagePerHealth=0.08
    SonicShatterMaxDamage=80
    ShatterProjClass=class'SirenDart'
    ShatteredIce=class'IceChunkEmitter'
    bDosh=True
}
