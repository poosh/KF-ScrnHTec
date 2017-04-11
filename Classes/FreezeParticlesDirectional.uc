class FreezeParticlesDirectional extends FreezeParticlesBase;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	Emitters[0].SpawnParticle(1);
}

defaultproperties
{
     Style=STY_Additive
     bHardAttach=True
     bDirectional=True
}
