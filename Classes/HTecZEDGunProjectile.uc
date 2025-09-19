class HTecZEDGunProjectile extends ScrnRocketProjectile;

defaultproperties
{
    Damage=0
    DamageRadius=1
    bAlwaysDealImpactDamage=true
    ExplosionSoundVolume=1.650000
    ArmDistSquared=0.000000

    MyDamageType=class'DamTypeHTecZEDGun'
    ImpactDamage=100

    ExplosionClass=Class'KFMod.ZEDProjectileImpact'
    TracerClass=Class'KFMod.ZEDProjectileTrail'
    StaticMeshRef="ZED_FX_SM.Energy.ZED_FX_Energy_Card"
    ExplosionSoundRef="KF_ZEDGunSnd.KF_WEP_ZED_Projectile_Explode"
    AmbientSoundRef="KF_ZEDGunSnd.KF_WEP_ZED_Projectile_Loop"
    AmbientVolumeScale=2.5
    Speed=1500
    MaxSpeed=1700
    ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Medium'
    LightType=LT_Steady
    LightHue=128
    LightSaturation=64
    LightBrightness=255
    LightRadius=8
    LightCone=16
    bDynamicLight=True
    DrawScale=1.000000
    AmbientGlow=254
    bUnlit=True
}