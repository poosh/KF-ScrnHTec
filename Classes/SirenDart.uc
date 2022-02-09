class SirenDart extends IceDart;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetDrawScale(DrawScale * (0.5 +  3.0*frand()));
}

defaultproperties
{
    MyDamageType=class'DamTypeSirenDart'
    Damage=8
    Speed=1000
    MaxSpeed=3000
    LifeSpan=8

    RemoteRole=ROLE_SimulatedProxy
    bNetInitialRotation=true
    // bUpdateSimulatedPosition=true
    bSkipActorPropertyReplication=true
}
