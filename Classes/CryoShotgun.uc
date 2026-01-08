class CryoShotgun extends SPAutoShotgun;

#exec OBJ LOAD FILE=HTec_A.ukx

var float LastDialCharge;

simulated function WeaponTick(float dt)
{
    super(AA12AutoShotgun).WeaponTick(dt);

    if (Level.NetMode!=NM_DedicatedServer) {
        if (FireMode[0].NextFireTime >= Level.TimeSeconds) {
            // log("Remaining = "$(FireMode[0].NextFireTime - Level.TimeSeconds)$" FireMode[0].FireRate = "$FireMode[0].FireRate$" Scale = "$((FireMode[0].NextFireTime - Level.TimeSeconds)/FireMode[0].FireRate));
            SetDialCharge(1.0 - ((FireMode[0].NextFireTime - Level.TimeSeconds) / FireMode[0].FireRate));
        }
        else if (FireMode[1].NextFireTime >= Level.TimeSeconds) {
            // log("Remaining = "$(FireMode[1].NextFireTime - Level.TimeSeconds)$" FireMode[1].FireRate = "$FireMode[1].FireRate$" Scale = "$((FireMode[1].NextFireTime - Level.TimeSeconds)/FireMode[1].FireRate));
            SetDialCharge(1.0 - ((FireMode[1].NextFireTime - Level.TimeSeconds) / FireMode[1].FireRate));
        }
        else if (LastDialCharge != 1.0) {
            SetDialCharge(1.0);
        }
    }
}

simulated function SetDialCharge(float Pct)
{
    local rotator DialRot;

    LastDialCharge = FClamp(Pct, 0, 1.0);
    DialRot.roll = 26500 - (53000 * LastDialCharge);
    SetBoneRotation('Dail2',DialRot,1.0);
}

defaultproperties
{
    PickupClass=Class'CryoShotgunPickup'
    AttachmentClass=Class'CryoShotgun3rd'
    FireModeClass(0)=Class'CryoShotgunFire'
    FireModeClass(1)=Class'CryoShotgunZedFire'
    TraderInfoTexture=Texture'HTEC_A.CryoShotgun.Trader_CryoShotgun'
    SkinRefs(1)="HTEC_A.CryoShotgun.CryoShotgun_cmb"
    Description="A shotgun that shoots freezing cryo shells as primary fire and has ZED Erradication device for the secondary attack mode."
    ItemName="Cryo ZED Shotgun"
    Weight=7
    AppID=0
    Priority=100
    GroupOffset=15
    bHoldToReload=false
    bHasSecondaryAmmo=true
    bReduceMagAmmoOnSecondaryFire=false
    MagCapacity=10
}
