class FreezerGun extends KFWeapon;

#exec OBJ LOAD FILE=HTec_A.ukx

var ScriptedTexture     AmmoCounterScrTex;
var string              AmmoCounterScrTexRef;
var string              MyMessage;
var Font                MyFont, SmallMyFont;
var String              FontRef, FontSmallRef;
var color               MyFontColor;

var         int         AltMagAmmoRemaining;
var()       int         AltMagCapacity;

var int                 RenderedValue;
var localized   string  ReloadMessage;
var localized   string  EmptyMessage;

var array<Material>     GlowSkins; // 0 - glow off, length-1 - all lights on
var array<string>       GlowSkinRefs; // 0 - glow off, length-1 - all lights on

replication
{
    reliable if(Role == ROLE_Authority)
        AltMagAmmoRemaining;

    reliable if( bNetDirty && bNetOwner && Role==ROLE_Authority )
        AltMagCapacity;
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
    local FreezerGun W;
    local int i;

    super.PreloadAssets(Inv, bSkipRefCount);

    default.AmmoCounterScrTex = ScriptedTexture(DynamicLoadObject(default.AmmoCounterScrTexRef, class'ScriptedTexture', true));
    default.MyFont = Font(DynamicLoadObject(default.FontRef, class'Font', true));
    default.SmallMyFont = Font(DynamicLoadObject(default.FontSmallRef, class'Font', true));
    for ( i = 0; i < default.GlowSkinRefs.Length; i++ )
        default.GlowSkins[i] = Material(DynamicLoadObject(default.GlowSkinRefs[i], class'Material'));

    W = FreezerGun(Inv);
    if ( W != none ) {
        W.AmmoCounterScrTex = default.AmmoCounterScrTex;
        W.SmallMyFont = default.SmallMyFont;
        W.MyFont = default.MyFont;
        for ( i = 0; i < default.GlowSkins.Length; i++ )
            W.GlowSkins[i] = default.GlowSkins[i];
    }
}

static function bool UnloadAssets()
{
    local int i;

    if ( super.UnloadAssets() ) {
        default.AmmoCounterScrTex = none;
        default.SmallMyFont = none;
        default.MyFont = none;
        for ( i = 0; i < default.GlowSkins.Length; i++ )
            default.GlowSkins[i] = none;

        return true;
    }

    return false;
}

simulated final function SetTextColor( byte R, byte G, byte B )
{
    MyFontColor.R = R;
    MyFontColor.G = G;
    MyFontColor.B = B;
    MyFontColor.A = 255;
}


 simulated function RenderOverlays( Canvas Canvas )
{
    local float CurValue;

    CurValue = (AmmoAmount(0) + AmmoAmount(1))*1000 + MagAmmoRemaining + AltMagAmmoRemaining;
    if( MagAmmoRemaining <= 0 && AltMagAmmoRemaining <= 0 )
    {
        if( RenderedValue!=-5 )
        {
            RenderedValue = -5;
            MyFont = SmallMyFont;
            SetTextColor(218,18,18);
            MyMessage = EmptyMessage;
            ++AmmoCounterScrTex.Revision;
            GlowOff();
        }
    }
    else if( bIsReloading )
    {
        if( RenderedValue!=-4 )
        {
            RenderedValue = -4;
            MyFont = SmallMyFont;
            SetTextColor(30,38,43);
            MyMessage = ReloadMessage;
            ++AmmoCounterScrTex.Revision;
        }
    }
    else if( RenderedValue != CurValue )
    {
        RenderedValue = CurValue;
        MyFont = SmallMyFont;

        //if ((MagAmmoRemaining ) <= (MagCapacity/2))
        //    SetTextColor(32,60,77);
        if ( MagAmmoRemaining < 10 || AltMagAmmoRemaining < 30 )
            SetTextColor(224,44,56);
        else
            SetTextColor(30,38,43);
        MyMessage = MagAmmoRemaining $ " / " $ AltMagAmmoRemaining;
        ++AmmoCounterScrTex.Revision;
        // glowstage
        if ( AltMagAmmoRemaining == 0 )
            GlowOff();
        else
            GlowStage(AltMagAmmoRemaining/15 + 1);
    }

    AmmoCounterScrTex.Client = Self;
    Super.RenderOverlays(Canvas);
    AmmoCounterScrTex.Client = None;
}

simulated function RenderTexture( ScriptedTexture Tex )
{
    local int w, h;

    // Ammo     - ( w / 2 )    - ( h / 1.2 )
    Tex.TextSize( MyMessage, MyFont, w, h );
    Tex.DrawText( ( Tex.USize / 2.4) - ( w / 2 ), (Tex.VSize / 2 ) - ( h / 2 ),MyMessage, MyFont, MyFontColor );
}


simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
    local Inventory Inv;
    local bool bOutOfAmmo;
    local KFWeapon KFWeap;

    if ( Load > 0 )
        Load = FireMode[Mode].AmmoPerFire;
    if ( Super(Weapon).ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )
    {
        if ( Load > 0 && (Mode == 0 || bReduceMagAmmoOnSecondaryFire) ) {
            MagAmmoRemaining -= Load; // Changed from "MagAmmoRemaining--"  -- PooSH
            if ( MagAmmoRemaining < 0 )
                MagAmmoRemaining = 0;
        }
        else if ( Load > 0 && Mode == 1 ) {
            AltMagAmmoRemaining -= Load;
            if ( AltMagAmmoRemaining < 0 )
                AltMagAmmoRemaining = 0;
        }
        if ( AltMagAmmoRemaining == 0 )
            GlowOff();

        NetUpdateTime = Level.TimeSeconds - 1;

        if ( FireMode[Mode].AmmoPerFire > 0 && InventoryGroup > 0 && !bMeleeWeapon && bConsumesPhysicalAmmo
            && (Ammo[0] == none || FireMode[0] == none || FireMode[0].AmmoPerFire <= 0 || Ammo[0].AmmoAmount < FireMode[0].AmmoPerFire)
            && (Ammo[1] == none || FireMode[1] == none || FireMode[1].AmmoPerFire <= 0 || Ammo[1].AmmoAmount < FireMode[1].AmmoPerFire) )
        {
            bOutOfAmmo = true;

            for ( Inv = Instigator.Inventory; Inv != none; Inv = Inv.Inventory )
            {
                KFWeap = KFWeapon(Inv);

                if ( Inv.InventoryGroup > 0 && KFWeap != none && !KFWeap.bMeleeWeapon && KFWeap.bConsumesPhysicalAmmo &&
                     ((KFWeap.Ammo[0] != none && KFWeap.FireMode[0] != none && KFWeap.FireMode[0].AmmoPerFire > 0 &&KFWeap.Ammo[0].AmmoAmount >= KFWeap.FireMode[0].AmmoPerFire) ||
                     (KFWeap.Ammo[1] != none && KFWeap.FireMode[1] != none && KFWeap.FireMode[1].AmmoPerFire > 0 && KFWeap.Ammo[1].AmmoAmount >= KFWeap.FireMode[1].AmmoPerFire)) )
                {
                    bOutOfAmmo = false;
                    break;
                }
            }

            if ( bOutOfAmmo )
            {
                PlayerController(Instigator.Controller).Speech('AUTO', 3, "");
            }
        }

        return true;
    }
    return false;
}

simulated function bool StartFire(int Mode)
{
    if( Mode == 0 )
        return super.StartFire(Mode);

    if( !super.StartFire(Mode) )  // returns false when mag is empty
       return false;

    if( AmmoAmount(Mode) <= 0 )
        return false;

    AnimStopLooping();

    if( !FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(Mode) > 0) )
    {
        FireMode[Mode].StartFiring();
        return true;
    }
    else
    {
        return false;
    }

    return true;
}

simulated function AnimEnd(int channel)
{
    if(!FireMode[1].IsInState('FireLoop'))
    {
          Super.AnimEnd(channel);
    }
}

// Allow this weapon to auto reload on alt fire
simulated function Fire(float F)
{
    if( MagAmmoRemaining < FireMode[0].AmmoPerFire && !bIsReloading &&
         FireMode[0].NextFireTime <= Level.TimeSeconds )
    {
        // We're dry, ask the server to autoreload
        ServerRequestAutoReload();

        PlayOwnedSound(FireMode[0].NoAmmoSound,SLOT_None,2.0,,,,false);
    }

    super.Fire(F);
}

simulated function AltFire(float F)
{
    if( AltMagAmmoRemaining < FireMode[1].AmmoPerFire && !bIsReloading &&
         FireMode[1].NextFireTime <= Level.TimeSeconds )
    {
        // We're dry, ask the server to autoreload
        ServerRequestAutoReload();

        PlayOwnedSound(FireMode[1].NoAmmoSound,SLOT_None,2.0,,,,false);
    }

    super.AltFire(F);
}

simulated function bool AllowReload()
{
    if ( bIsReloading )
        return false;

    UpdateMagCapacity(Instigator.PlayerReplicationInfo);
    if ( (MagAmmoRemaining >= MagCapacity || AmmoAmount(0) <= MagAmmoRemaining)
            && (AltMagAmmoRemaining >= AltMagCapacity || AmmoAmount(1) <= AltMagAmmoRemaining) )
        return false;

    if ( KFInvasionBot(Instigator.Controller) != none || KFFriendlyAI(Instigator.Controller) != none )
        return true;

    return !FireMode[0].IsFiring() && !FireMode[1].IsFiring()
            && ClientState != WS_BringUp
            && Level.TimeSeconds > FireMode[0].NextFireTime + 0.1
            && Level.TimeSeconds > FireMode[1].NextFireTime + 0.1;
}

simulated function UpdateMagCapacity(PlayerReplicationInfo PRI)
{
    local float bonus;

    bonus = 1.0;
    if ( KFPlayerReplicationInfo(PRI) != none && KFPlayerReplicationInfo(PRI).ClientVeteranSkill != none )
    {
        bonus = KFPlayerReplicationInfo(PRI).ClientVeteranSkill.Static.GetMagCapacityMod(KFPlayerReplicationInfo(PRI), self);
    }
    MagCapacity = default.MagCapacity * bonus;
    AltMagCapacity = default.AltMagCapacity * bonus;
}

simulated function WeaponTick(float dt)
{
    if ( Role == ROLE_Authority && bIsReloading && (Level.TimeSeconds - ReloadTimer) >= ReloadRate ) {
        AddReloadedAmmo();
        ActuallyFinishReloading();
    }
    super.WeaponTick(dt);
}

function AddReloadedAmmo()
{
    UpdateMagCapacity(Instigator.PlayerReplicationInfo);
    MagAmmoRemaining = min(MagCapacity, AmmoAmount(0));
    AltMagAmmoRemaining = min(AltMagCapacity, AmmoAmount(1));

    if( !bHoldToReload )
    {
        ClientForceAmmoUpdate(0, AmmoAmount(0));
        ClientForceAmmoUpdate(1, AmmoAmount(1));
    }

    if ( PlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
    {
        KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnWeaponReloaded();
    }
}

simulated function ClientFinishReloading()
{
    bIsReloading = false;

    // Reload animation longs 4.5s while weapon becomes ready in 3.6s
    // Continue animation for last 0.9s if player is not shooting
    // -- PooSH
    //PlayIdle();
    SetTimer(0.9, false);

    if(Instigator.PendingWeapon != none && Instigator.PendingWeapon != self)
        Instigator.Controller.ClientSwitchToBestWeapon();
}

function GiveTo( pawn Other, optional Pickup Pickup )
{
    UpdateMagCapacity(Other.PlayerReplicationInfo);

    if ( KFWeaponPickup(Pickup)!=None && Pickup.bDropped ) {
        MagAmmoRemaining = Clamp(KFWeaponPickup(Pickup).MagAmmoRemaining, 0, MagCapacity);
        AltMagAmmoRemaining = Clamp(FreezerPickup(Pickup).AltMagAmmoRemaining, 0, AltMagCapacity);
    }
    else {
        MagAmmoRemaining = MagCapacity;
        AltMagAmmoRemaining = AltMagCapacity;
    }

    Super(Weapon).GiveTo(Other,Pickup);
}

simulated function GlowOn()
{
    GlowStage(255);
}

simulated function GlowOff()
{
    GlowStage(0);
}

simulated function GlowStage(byte Stage)
{
    Skins[0] = GlowSkins[min(Stage,GlowSkins.length-1)];
}

simulated function Timer()
{
    if ( ClientState == WS_ReadyToFire )
        PlayIdle();
    else
        super.Timer();
}


defaultproperties
{
    MeshRef="HTec_A.FreezerGun"
    HudImageRef="HTec_A.HUD.FreezerGun_Unselected"
    SelectedHudImageRef="HTec_A.HUD.FreezerGun"
    SelectSoundRef="KF_NailShotgun.Handling.KF_NailShotgun_Pickup"
    SkinRefs(0)="HTec_A.FreezerGun.FreezerGun_shdr"
    SkinRefs(1)="HTec_A.Counter.Counter_Shdr"
    SkinRefs(2)="HTec_A.FreezerGun.FreezerGun_Sight_shdr"
    AmmoCounterScrTexRef="HTec_A.Counter.Counter_Scripted"
    FontRef="IJCFonts.DigitalBig"
    FontSmallRef="IJCFonts.DigitalMed"
    GlowSkinRefs(0)="HTec_A.FreezerGun.FreezerGun_shdr_off"
    GlowSkinRefs(1)="HTec_A.FreezerGun.FreezerGun_shdr_1"
    GlowSkinRefs(2)="HTec_A.FreezerGun.FreezerGun_shdr_2"
    GlowSkinRefs(3)="HTec_A.FreezerGun.FreezerGun_shdr_3"
    GlowSkinRefs(4)="HTec_A.FreezerGun.FreezerGun_shdr"

    MyFontColor=(B=177,G=148,R=76,A=255)
    ReloadMessage="REL"
    EmptyMessage="---"

    MagCapacity=30
    bHasSecondaryAmmo=True
    bReduceMagAmmoOnSecondaryFire=False
    AltMagCapacity=90

    ReloadRate=3.600000
    ReloadAnim="Reload"
    ReloadAnimRate=1.000000
    WeaponReloadAnim="Reload_M7A3"
    Weight=7.000000
    bHasAimingMode=True
    IdleAimAnim="Idle_Iron"
    StandardDisplayFOV=65.000000
    bModeZeroCanDryFire=True
    SleeveNum=3
    TraderInfoTexture=Texture'HTec_A.HUD.Trader_FreezerGun'
    bIsTier3Weapon=True
    PlayerIronSightFOV=70.000000
    ZoomedDisplayFOV=40.000000
    FireModeClass(0)=class'FreezerFire'
    FireModeClass(1)=class'FreezerAltFire'
    PutDownAnim="PutDown"

    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    bShowChargingBar=True
    Description="Cryo Mass Driver v014 or simply a 'Freezer Gun' is developed to ... blah blah blah ... freeze zeds"
    EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
    DisplayFOV=65.000000
    Priority=150
    InventoryGroup=4
    GroupOffset=15
    PickupClass=class'FreezerPickup'
    PlayerViewOffset=(X=25.000000,Y=23.000000,Z=-5.000000)
    BobDamping=4.500000
    AttachmentClass=class'FreezerAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="Cryo Mass Driver 14 SE"
    TransientSoundVolume=1.250000
}
