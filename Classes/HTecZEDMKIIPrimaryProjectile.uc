class HTecZEDMKIIPrimaryProjectile extends HTecZEDGunProjectile;

defaultproperties
{
    MyDamageType=class'DamTypeHTecZEDGunMKII'
    ImpactDamageType=class'DamTypeHTecZEDGunMKII'
    ImpactDamage=80

    ExplosionClass=Class'KFMod.ZEDMKIIPrimaryProjectileImpact'
    TracerClass=Class'KFMod.ZEDMKIIPrimaryProjectileTrail'
    StaticMeshRef="ZED_FX_SM.Energy.ZED_FX_Energy_Card"
    ExplosionSoundRef="KF_FY_ZEDV2SND.WEP_ZEDV2_Projectile_Explode"
    AmbientSoundRef="KF_FY_ZEDV2SND.WEP_ZEDV2_Projectile_Loop"
    AmbientVolumeScale=2.5
    Speed=1500
    MaxSpeed=1700
    ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Medium'
    LightType=LT_Steady
    LightHue=128
    LightSaturation=64
    LightBrightness=255
    LightRadius=4
    LightCone=16
    bDynamicLight=True
    DrawScale=0.5
    AmbientGlow=254
    bUnlit=True
}