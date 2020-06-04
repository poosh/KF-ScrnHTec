class FreezerFire extends KFShotgunFire;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Load = ProjPerFire; // don't use AmmoPerFire here
}

simulated function bool AllowFire()
{
    if(KFWeapon(Weapon).bIsReloading)
        return false;
    if(KFPawn(Instigator).SecondaryItem!=none)
        return false;
    if(KFPawn(Instigator).bThrowingNade)
        return false;

    if(KFWeapon(Weapon).MagAmmoRemaining < AmmoPerFire)
    {
        if( Level.TimeSeconds - LastClickTime>FireRate )
        {
            LastClickTime = Level.TimeSeconds;
        }

        if( AIController(Instigator.Controller)!=None )
            KFWeapon(Weapon).ReloadMeNow();
        return false;
    }

    return super(WeaponFire).AllowFire();
}

event ModeDoFire()
{
    super.ModeDoFire();
    Load = ProjPerFire; // don't use AmmoPerFire here
}

defaultproperties
{
     FireSoundRef="HTec_A.Fire1mono"
     StereoFireSoundRef="HTec_A.Fire1"
     NoAmmoSoundRef="KF_NailShotgun.Fire.KF_NailShotgun_Dryfire"

     RecoilRate=0.130000
     maxVerticalRecoilAngle=200
     maxHorizontalRecoilAngle=75
     FireAimedAnim="Fire_Iron"
     ProjPerFire=1
     ProjSpawnOffset=(X=18.000000,Y=5.0,Z=-8.000000)
     TransientSoundVolume=1.000000
     FireLoopAnim="Fire"
     FireAnimRate=1.200000
     TweenTime=0.001500
     FireRate=0.150000
     AmmoClass=Class'ScrnHTec.FreezerDartAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     ProjectileClass=Class'ScrnHTec.FreezerDart'
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ScrnHTec.IceDartMuzzleFlash'
     aimerror=42.000000
     Spread=0.008000
}
