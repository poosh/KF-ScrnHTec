class NitroTrail extends FreezeParticlesBase;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=240,R=190,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=240,R=190,A=255))
         FadeOutStartTime=0.378000
         FadeInEndTime=0.014000
         MaxParticles=40
         SpinsPerSecondRange=(X=(Max=0.025000))
         StartSpinRange=(X=(Min=-0.200000,Max=0.200000))
         StartSizeRange=(X=(Min=3.000000,Max=32.000000),Y=(Min=3.000000,Max=32.000000),Z=(Min=3.000000,Max=32.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=1.000000,Max=1.400000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnHTec.NitroTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         Acceleration=(Z=-400.000000)
         DampingFactorRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.250000))
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.330000
         FadeOutStartTime=1.080000
         FadeInEndTime=0.120000
         MaxParticles=40
         SpinsPerSecondRange=(X=(Min=0.400000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.400000),Y=(Min=0.500000,Max=1.400000),Z=(Min=0.500000,Max=1.400000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=300.000000))
         VelocityLossRange=(Y=(Max=5.000000),Z=(Max=5.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnHTec.NitroTrail.SpriteEmitter1'

     Physics=PHYS_Trailer
     LifeSpan=2.900000
}
