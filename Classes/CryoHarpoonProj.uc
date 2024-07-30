class CryoHarpoonProj extends SealSquealProjectile;

var float ImpactDamageReduction;

var float HeadshotDamageMult;

var class<DamTypeFreezerBase> FreezeDamageType;
var float FreezeDamage;
var float FreezeVictimDamage;
var float FreezeHeadshotMult;
var float FreezeRadius;
var float FreezeRate;   // How often to do Freezeing
var class<Emitter> FreezeCloudClass;
var Emitter FreezeCloud;

var float AttachedLightRadius;
var transient Pawn AttachedVictim;
var transient name AttachedBone;
var transient float ExplodeAt;
var transient bool bHadVictim;

simulated function Destroyed()
{
    if (FreezeCloud != none) {
        FreezeCloud.Kill();
    }

    if (Trail != none) {
        Trail.mRegen = False;
    }

    if (SmokeTrail != none) {
        SmokeTrail.Kill();
        SmokeTrail.SetPhysics(PHYS_None);
    }

    if (!bHasExploded && !bHidden) {
        Explode(Location, vect(0,0,1));
    }
    if (bHidden && !bDisintegrated && !bHasExploded) {
        Disintegrate(Location, vect(0,0,1));
    }
    super(Projectile).Destroyed();
}

simulated function PostNetReceive()
{
    super.PostNetReceive();
    if (bStuck) {
        GotoState('OnVictim');
    }
}

simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
    bDisintegrated = true;
    bHidden = true;

    if (Role == ROLE_Authority) {
        GotoState('KillMe');
    }

    PlaySound(DisintegrateSound,,2.0);
    if (EffectIsRelevant(Location, false)) {
        Spawn(Class'KFMod.SirenNadeDeflect',,, HitLocation, rotator(vect(0,0,1)));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController LocalPlayer;

    if (bHasExploded)
        return;
    bHasExploded = True;

    PlaySound(ExplosionSound,,2.0);
    if (EffectIsRelevant(Location,false)) {
        Spawn(ExplosionEmitterClass,,,HitLocation + HitNormal*20,rotator(HitNormal));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }

    GotoState('');
    BlowUp(HitLocation);
    Destroy();

    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < DamageRadius) )
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( (PlayerController(C) != None) && (C != LocalPlayer)
            && (VSize(Location - PlayerController(C).ViewTarget.Location) < DamageRadius) )
            C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victim;
    local float damageScale, dist;
    local vector dirs;
    local int NumKilled;
    local KFMonster KFMonsterVictim;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;

    // full damage to the attached victim
    if (AttachedVictim != none) {
        Victim = AttachedVictim;
        dirs = Victim.Location - HitLocation;

        if ( Instigator == None || Instigator.Controller == None )
            Victim.SetDelayedDamageInstigatorController(InstigatorController);

        KFMonsterVictim = KFMonster(Victim);

        if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 ) {
            KFMonsterVictim = none;
        }

        if (bAttachedToHead) {
            damageScale = HeadshotDamageMult;
        }
        else {
            damageScale = 1.0;
        }

        Victim.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            HitLocation,
            vect(0, 0, 0),
            DamageType
        );
        if (Vehicle(Victim) != None && Vehicle(Victim).Health > 0)
            Vehicle(Victim).DriverRadiusDamage(damageScale * DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        if (Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0) {
            NumKilled++;
        }
    }

    foreach CollidingActors (class 'Actor', Victim, DamageRadius, HitLocation) {
        KFMonsterVictim = none;
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if (Victim == self || Victim == AttachedVictim || Victim.Role != ROLE_Authority || Victim.IsA('FluidSurfaceInfo')
                || Victim.IsA('ExtendedZCollision'))
            continue;

        dirs = Victim.Location - HitLocation;
        dist = FMax(1, VSize(dirs));
        dirs = dirs/dist;
        damageScale = 1 - FMax(0, (dist - Victim.CollisionRadius) / DamageRadius);
        if (Instigator == none || Instigator.Controller == none )
            Victim.SetDelayedDamageInstigatorController(InstigatorController);

        if (Pawn(Victim) != none) {
            KFMonsterVictim = KFMonster(Victim);
            if (KFMonsterVictim != none && KFMonsterVictim.Health <= 0) {
                KFMonsterVictim = none;
            }

            if (KFMonsterVictim != none) {
                damageScale *= KFMonsterVictim.GetExposureTo(HitLocation);
            }
            else if (KFPawn(Victim) != none) {
                damageScale *= KFPawn(Victim).GetExposureTo(HitLocation);
            }

            if (Victim == Instigator) {
                // smaller self damage
                damageScale *= 0.5;
            }
        }

        Victim.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victim.Location - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * dirs,
            (damageScale * Momentum * dirs),
            DamageType
        );

        if (Vehicle(Victim) != None && Vehicle(Victim).Health > 0)
            Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        if (Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0) {
            NumKilled++;
        }
    }

    if( Role == ROLE_Authority )
    {
        if( NumKilled >= 10 )
            KFGameType(Level.Game).DramaticEvent(0.20);
        else if( NumKilled >= 4 )
            KFGameType(Level.Game).DramaticEvent(0.05);
        else if( NumKilled >= 2 )
            KFGameType(Level.Game).DramaticEvent(0.03);
    }

    bHurtEntry = false;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    // Don't let it hit this player, or blow up on another player
    if (Other == none || Other == Instigator || Other.Base == Instigator || bStuck)
        return;

    // Don't collide with bullet whip attachments
    if (KFBulletWhipAttachment(Other) != none)
        return;

    // Don't allow hits on people on the same team
    if (KFHumanPawn(Other) != none && Instigator != none
            && KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex)
        return;

    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if (Instigator != none) {
        OrigLoc = Instigator.Location;
    }

    Stick(Other, HitLocation);
}

simulated function Stick(actor HitActor, vector HitLocation)
{
    local float Dist;
    local vector HitDirection;

    HitDirection = Normal(Velocity);
    if (Velocity == vect(0,0,0)) {
        HitDirection = Vector(Rotation);
    }

    if(HitActor.IsA('ExtendedZCollision')) {
        AttachedVictim = Pawn(HitActor.Base);
    }
    else {
        AttachedVictim = Pawn(HitActor);
    }
    bOrientToVelocity = false;
    SetRotation(Rotator(HitDirection));

    if (AttachedVictim != none) {
        bAttachedToHead = AttachedVictim.IsHeadShot(HitLocation, HitDirection, 1.0);
        AttachedVictim.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * HitDirection, ImpactDamageType);
        if (AttachedVictim == none || AttachedVictim.Health <= 0 || (bAttachedToHead && KFMonster(AttachedVictim) != none && KFMonster(AttachedVictim).bDecapitated)) {
            ImpactDamage *= ImpactDamageReduction;
            // penetrate and continue flying
            bOrientToVelocity = true;
            return;
        }

        if (bAttachedToHead) {
            AttachedBone = AttachedVictim.HeadBone;
        }
        else {
            AttachedBone = AttachedVictim.GetClosestBone(HitLocation, HitDirection, Dist);
            if (AttachedBone == '') {
                AttachedBone = AttachedVictim.RootBone;
            }
        }
        Velocity = vect(0,0,0);
        SetPhysics(PHYS_None);
        SetLocation(AttachedVictim.GetBoneCoords(AttachedBone).Origin);
        AttachedVictim.AttachToBone(self, AttachedBone);
        // TODO: Improve the math here so its angle more closely matches the angle it stuck in at
        // SetRelativeRotation(Rotator(HitDirection >> AttachedVictim.GetBoneRotation(AttachedBone, 0)));
        SetRelativeLocation(vect(0, 0, 0));
        PlaySound(ImpactPawnSound, SLOT_Misc);
        bHadVictim = true;
    }
    else {
        Velocity = vect(0,0,0);
        SetPhysics(PHYS_None);
        SetBase(HitActor);
        PlaySound(ImpactSound, SLOT_Misc);
    }
    GotoState('OnVictim');
}

function DoFreeze()
{
    local KFMonster KFM;
    local float d;

    if (bHasExploded || bHidden)
        return;

    if (AttachedVictim != none && AttachedVictim.Health > 0) {
        if (Instigator == none || Instigator.Controller == none)
            KFM.SetDelayedDamageInstigatorController(InstigatorController);
        d = FreezeVictimDamage;
        if (bAttachedToHead) {
            d *= FreezeHeadshotMult;
        }
        AttachedVictim.TakeDamage(d, Instigator, AttachedVictim.Location, vect(0,0,0), FreezeDamageType);
    }

    foreach CollidingActors(class'KFMonster', KFM, FreezeRadius, Location) {
        if (KFM.Health <= 0 || KFM == AttachedVictim)
            continue;
        if (Instigator == none || Instigator.Controller == none)
            KFM.SetDelayedDamageInstigatorController(InstigatorController);
        KFM.TakeDamage(FreezeDamage, Instigator, KFM.Location, vect(0,0,0), FreezeDamageType);
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local class<KFWeaponDamageType> KFDamType;

    if (bHasExploded || bHidden)
        return;

    KFDamType = class<KFWeaponDamageType>(damageType);
    if (KFDamType == none)
        return;

    if (KFDamType == class'SirenScreamDamage') {
        // disable disintegration by dead Siren scream
        if (InstigatedBy != none && InstigatedBy.Health > 0) {
            Disintegrate(HitLocation, vect(0,0,1));
        }
    }
    else if (Damage > 50 && KFDamType.default.bIsExplosive) {
        Explode(HitLocation, vect(0,0,1));
    }
}

simulated state OnVictim
{
    ignores Touch, ClientSideTouch, ProcessTouch, Stick;

    simulated function BeginState()
    {
        bStuck = true;
        LightRadius = AttachedLightRadius;
        if (Trail != none) {
            Trail.mRegen = False;
        }

        if (EffectIsRelevant(Location, false)) {
            FreezeCloud = Spawn(FreezeCloudClass, self,, Location, Rotation);
            FreezeCloud.SetBase(self);
        }

        if (Role == ROLE_Authority) {
            ExplodeAt = Level.TimeSeconds + ExplodeTimer - 0.05;
            SetTimer(FreezeRate, true);
        }
    }

    function EndState()
    {
        SetTimer(0, false);
    }

    simulated function PostNetReceive()
    {
        super.PostNetReceive();
    }

    function Timer()
    {
        DoFreeze();
        if (Level.TimeSeconds > ExplodeAt) {
            Explode(Location, vect(0,0,1));
        }
    }

    simulated function Tick(float dt)
    {
        if (bHadVictim && (AttachedVictim == none || AttachedVictim.Health <= 0) && !bHasExploded && !bHidden) {
            SetPhysics(PHYS_Falling);
        }
        super.Tick(dt);
    }
}

state KillMe
{
    ignores Touch, ClientSideTouch, ProcessTouch, Stick, Timer;

Begin:
    bHidden = true;
    NetUpdateTime = Level.TimeSeconds - 1;
    sleep(0.1);
    Destroy();
}


defaultproperties
{
    ImpactDamageType=class'DamTypeCryoHarpoonImpact'
    ImpactDamage=100
    ImpactDamageReduction=0.5
    MomentumTransfer=75000

    FreezeCloudClass=class'CryoHarpoonCloud'
    FreezeDamageType=class'DamTypeCryoHarpoonFreeze'
    FreezeRate=0.50
    FreezeDamage=6
    FreezeVictimDamage=6
    FreezeHeadshotMult=2.0
    FreezeRadius=100

    Damage=300
    DamageRadius=350
    HeadshotDamageMult=2.22
    ExplodeTimer=2.5
    LifeSpan=10

    AttachedLightRadius=2.0
    bSkipActorPropertyReplication=false
}
