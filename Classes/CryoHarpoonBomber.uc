class CryoHarpoonBomber extends SealSquealHarpoonBomber;

var name ReloadShortAnim;
var float ReloadShortRate;
var transient bool bShortReload;

var byte FuseIndex;
var array<float> FuseTimes;
var class<LocalMessage> ToggleMessageClass;

replication
{
    reliable if(Role < ROLE_Authority)
        ServerChangeFireModeEx;
}

simulated function AltFire(float F)
{
    DoToggle();
}

exec function SwitchModes()
{
    DoToggle();
}

simulated function DoToggle()
{
    local PlayerController PC;

    if (IsFiring())
        return;

    if (++FuseIndex >= FuseTimes.Length) {
        FuseIndex = 0;
    }

    if (Instigator != none)
        PC = PlayerController(Instigator.Controller);
    if (PC != none) {
        PC.ReceiveLocalizedMessage(ToggleMessageClass, FuseIndex);
    }

    PlayOwnedSound(ToggleSound,SLOT_None,2.0,,,,false);
    ServerChangeFireModeEx(FuseIndex);
}

function ServerChangeFireModeEx(byte NewFuseIndex)
{
    FuseIndex = NewFuseIndex;
    CryoHarpoonFire(FireMode[0]).FuseTime = FuseTimes[FuseIndex];
}

exec function ReloadMeNow()
{
    local float ReloadMulti;
    local KFPlayerReplicationInfo KFPRI;
    local KFPlayerController KFPC;

    if (!AllowReload())
        return;

    ReloadMulti = 1.0;
    KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    KFPC = KFPlayerController(Instigator.Controller);
    if (KFPRI != none && KFPRI.ClientVeteranSkill != none ) {
        ReloadMulti = KFPRI.ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPRI, self);
    }

    if (bHasAimingMode && bAimingRifle) {
        FireMode[1].bIsFiring = False;
        ZoomOut(false);
        if( Role < ROLE_Authority)
            ServerZoomOut(false);
    }

    bIsReloading = true;
    ReloadTimer = Level.TimeSeconds;
    bShortReload = MagAmmoRemaining > 0;
    if (bShortReload) {
        ReloadRate = Default.ReloadShortRate / ReloadMulti;
    }
    else {
        ReloadRate = Default.ReloadRate / ReloadMulti;
    }

    if (bHoldToReload) {
        NumLoadedThisReload = 0;
    }

    ClientReload();
    Instigator.SetAnimAction(WeaponReloadAnim);
    if (Level.Game.NumPlayers > 1 && KFPC != none && KFGameType(Level.Game).bWaveInProgress
            && Level.TimeSeconds - KFPC.LastReloadMessageTime > KFPC.ReloadMessageDelay) {
        KFPC.Speech('AUTO', 2, "");
        KFPC.LastReloadMessageTime = Level.TimeSeconds;
    }
}

simulated function ClientReload()
{
    local float ReloadMulti;
    local KFPlayerReplicationInfo KFPRI;

    ReloadMulti = 1.0;
    KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    if (KFPRI != none && KFPRI.ClientVeteranSkill != none ) {
        ReloadMulti = KFPRI.ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPRI, self);
    }

    if (bHasAimingMode && bAimingRifle) {
        FireMode[1].bIsFiring = False;
        ZoomOut(false);
        if( Role < ROLE_Authority)
            ServerZoomOut(false);
    }

    bIsReloading = true;
    if (MagAmmoRemaining <= 0) {
        PlayAnim(ReloadAnim, ReloadAnimRate * ReloadMulti, 0.1);
    }
    else {
        PlayAnim(ReloadShortAnim, ReloadAnimRate * ReloadMulti, 0.1);
    }
}

defaultproperties
{
    MagCapacity=3
    ReloadRate=3.2
    ReloadAnimRate=1.25
    ReloadShortAnim="Reload"
    ReloadShortRate=2.36
    Weight=6.0
    FireModeClass(0)=Class'CryoHarpoonFire'
    ItemName="Cryo Harpoon Bomber"
    Description="Shoots harpoons filled with liquid nitrogen and T.N.T. Freeze&Shatter combo in one round! Has adjustable fuse time. Additional head damage."
    PickupClass=Class'CryoHarpoonPickup'
    AttachmentClass=Class'CryoHarpoonAttachment'
    InventoryGroup=3
    GroupOffset=22
    Priority=171
    FuseTimes(0)=2.5
    FuseTimes(1)=5.0
    ToggleMessageClass=class'CryoHarpoonMessage'
    ToggleSound=sound'KF_9MMSnd.NineMM_AltFire1'
}