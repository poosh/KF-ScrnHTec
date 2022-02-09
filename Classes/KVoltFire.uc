//=============================================================================
 //L85 Fire
//=============================================================================
class KVoltFire extends KFShotgunFire;

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

defaultproperties
{
     StereoFireSoundRef="HTec_A.KVolt.kvolt_fire_s"
     FireSoundRef="HTec_A.KVolt.kvolt_fire_m"
     NoAmmoSoundRef="KF_NailShotgun.Fire.KF_NailShotgun_Dryfire"
     TransientSoundVolume=1.0

     FireAimedAnim="Fire_Iron"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=125
     maxHorizontalRecoilAngle=50
     //ShellEjectBoneName="Shell_eject"
     bPawnRapidFireAnim=True
     TweenTime=0.015000
     FireForce="AssaultRifleFire"
     FireRate=0.075000
     ProjPerFire=1
     ProjectileClass=class'KVoltDart'
     AmmoClass=class'KVoltAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=75.000000,Y=75.000000,Z=250.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.500000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     BotRefireRate=0.990000
     FlashEmitterClass=class'IceDartMuzzleFlash'
     aimerror=42.000000
     Spread=0.01
     SpreadStyle=SS_Random
}
