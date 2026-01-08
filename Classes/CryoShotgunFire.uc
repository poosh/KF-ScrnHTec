class CryoShotgunFire extends SPShotgunFire;

defaultproperties
{
    FireSoundRef="KF_SP_ZEDThrowerSnd.KFO_Shotgun_Primary_Fire_M"
    StereoFireSoundRef="KF_SP_ZEDThrowerSnd.KFO_Shotgun_Primary_Fire_S"
    NoAmmoSoundRef="KF_AA12Snd.AA12_DryFire"

    FlashEmitterClass=class'IceDartMuzzleFlash'
    ProjectileClass=class'CryoShotgunDart'
    AmmoClass=Class'CryoShotgunAmmo'
    ProjPerFire=7
    AmmoPerFire=1

    FireRate=0.50
    FireAnimRate=0.70

    KickMomentum=(X=-20.0,Z=2.0)
    maxVerticalRecoilAngle=400
    maxHorizontalRecoilAngle=200
    Spread=1500
}
