class IceDartImpact extends FreezeParticlesDirectional;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=200,G=150,R=64,A=60))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=150,R=64,A=60))
         Opacity=0.200000
         FadeOutStartTime=0.028000
         FadeInEndTime=0.006000
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000),Y=(Min=50.000000),Z=(Min=50.000000))
         InitialParticlesPerSecond=10000.000000
         Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter0

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
         StartSizeRange=(X=(Min=75.000000,Max=100.000000),Y=(Min=75.000000,Max=100.000000),Z=(Min=75.000000,Max=100.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(1)=SpriteEmitter1

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=-1000.000000)
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         DampingFactorRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.250000))
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.750000
         FadeOutStartTime=0.500000
         MaxParticles=7 // 16
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=0.500000,Max=2.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=1.400000,Max=1.400000)
         StartVelocityRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Min=-400.000000,Max=600.000000))
     End Object
     Emitters(2)=SpriteEmitter2

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
         MaxParticles=6
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(1)=(RelativeSize=0.400000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=50.000000,Max=75.000000),Y=(Min=50.000000,Max=75.000000),Z=(Min=50.000000,Max=75.000000))
         InitialParticlesPerSecond=10000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-7.500000,Max=7.500000),Y=(Min=-7.500000,Max=7.500000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(3)=SpriteEmitter3

     LifeSpan=5.000000
}
