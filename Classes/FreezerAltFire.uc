class FreezerAltFire extends NitroFire;


function float MaxRange()
{
    return 1500;
}

defaultproperties
{
    Spread=1500.000000
    SpreadStyle=SS_Random
    EffectiveRange=1500.000000
    maxVerticalRecoilAngle=300
    maxHorizontalRecoilAngle=150
    ProjSpawnOffset=(X=12.000000,Y=5.000000,Z=-22.000000)
    FireAnim="'"
    FireLoopAnim="FireAlt"
    FireEndAnim="FireAltEnd"
    FireRate=0.070000
    BotRefireRate=0.070000
    AmmoClass=Class'ScrnHTec.FreezerAmmo'
    ProjectileClass=Class'ScrnHTec.FreezerNitroProjectile'
    FlashEmitterClass=Class'ScrnHTec.NitroMuzzleFlash'
}
