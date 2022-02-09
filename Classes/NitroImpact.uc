class NitroImpact extends FreezeParticlesDirectional;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-5.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScaleRepeats=1.000000
         FadeOutStartTime=1.500000
         MaxParticles=3
         SpinsPerSecondRange=(Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Max=0.400000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(1)=(RelativeSize=0.300000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=65.000000,Max=120.000000),Y=(Min=65.000000,Max=120.000000),Z=(Min=65.000000,Max=120.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter1

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-15.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScaleRepeats=1.000000
         Opacity=0.500000
         FadeOutStartTime=1.500000
         MaxParticles=8
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(1)=(RelativeSize=0.400000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=45.000000,Max=65.000000),Y=(Min=45.000000,Max=65.000000),Z=(Min=45.000000,Max=65.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-7.500000,Max=7.500000),Y=(Min=-7.500000,Max=7.500000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(1)=SpriteEmitter3

     LifeSpan=5.000000
}
