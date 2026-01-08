class CryoShotgunZedFire extends HTecZEDMKIIAltFire;

function bool AllowFire()
{
    if(KFWeapon(Weapon).bIsReloading)
        return false;
    if(KFPawn(Instigator).SecondaryItem!=none)
        return false;
    if(KFPawn(Instigator).bThrowingNade)
        return false;

    return super(WeaponFire).AllowFire();
}


defaultproperties
{
    ProjectileClass=class'CryoShotgunZedProjectile'
    AmmoClass=Class'CryoShotgunZedAmmo'
    AmmoPerFire=1
    FireAnim="Fire"
    FireAimedAnim="Fire_Iron"
    FireRate=0.50
    FireAnimRate=0.70
}
