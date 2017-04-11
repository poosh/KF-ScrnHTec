class NitroTrailB extends FreezeParticlesBase;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=-30.000000)
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.100000)
         ColorScale(0)=(Color=(B=255,G=240,R=190,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=240,R=190,A=255))
         Opacity=0.330000
         FadeOutStartTime=1.353000
         FadeInEndTime=0.891000
         StartLocationOffset=(Z=-10.000000)
         SpinsPerSecondRange=(X=(Max=0.010000))
         StartSpinRange=(X=(Min=-0.200000,Max=0.300000))
         SizeScale(0)=(RelativeTime=0.750000,RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.800000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=5.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=3.300000,Max=3.300000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-10.000000,Max=-10.000000))
         StartVelocityRadialRange=(Min=-40.000000,Max=40.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnHTec.NitroTrailB.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.100000)
         ColorScale(0)=(Color=(B=255,G=240,R=190,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=240,R=190,A=255))
         Opacity=0.330000
         FadeOutStartTime=0.940000
         FadeInEndTime=0.300000
         MaxParticles=13
         StartLocationOffset=(Z=-20.000000)
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
         SpinsPerSecondRange=(X=(Max=0.010000))
         StartSpinRange=(X=(Min=-0.200000,Max=0.300000))
         SizeScale(0)=(RelativeTime=0.500000,RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.350000)
         StartSizeRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=45.000000,Max=45.000000),Z=(Min=45.000000,Max=45.000000))
         InitialParticlesPerSecond=6.500000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-60.000000,Max=-60.000000))
         StartVelocityRadialRange=(Min=-40.000000,Max=40.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnHTec.NitroTrailB.SpriteEmitter1'

     Physics=PHYS_Trailer
     LifeSpan=2.900000
}
