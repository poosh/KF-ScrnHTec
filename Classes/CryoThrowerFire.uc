class CryoThrowerFire extends NitroFire;


function float MaxRange()
{
    return 2500;
}



defaultproperties
{
    Spread=2500.000000
    SpreadStyle=SS_Random
    EffectiveRange=2500.000000
    maxVerticalRecoilAngle=500
    maxHorizontalRecoilAngle=250
    ProjSpawnOffset=(X=15,Y=5.000000,Z=-40.000000)
    FireAnim="'"
    FireLoopAnim="Fire"
    FireEndAnim="Fire_End"
    FireRate=0.070000
    BotRefireRate=0.070000
    AmmoClass=class'CryoThrowerAmmo'
    ProjectileClass=class'CryoThrowerProjectile'
    FlashEmitterClass=class'NitroMuzzleFlash'
}
