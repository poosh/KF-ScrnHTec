class IceDartTrail extends FreezeParticlesDirectional;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         UniformSize=True
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
         VelocityLossRange=(X=(Max=5.000000),Y=(Max=5.000000),Z=(Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnHTec.IceDartTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         ColorScale(0)=(Color=(B=140,G=140,R=140,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=120,R=120,A=150))
         Opacity=0.750000
         FadeOutStartTime=0.900000
         FadeInEndTime=0.200000
         MaxParticles=50
         StartLocationShape=PTLS_Polar
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=2.000000))
         StartSpinRange=(X=(Min=-0.350000,Max=0.400000))
         StartSizeRange=(X=(Min=2.000000,Max=4.000000),Y=(Min=2.000000,Max=4.000000),Z=(Min=2.000000,Max=4.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'HTec_A.fx.Ice_Trail'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
         VelocityLossRange=(Y=(Max=10.000000),Z=(Max=10.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnHTec.IceDartTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         ColorScale(0)=(Color=(B=140,G=140,R=140,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=120,R=120,A=180))
         Opacity=0.750000
         FadeOutStartTime=0.900000
         FadeInEndTime=0.200000
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SpinsPerSecondRange=(X=(Min=1.000000,Max=3.000000))
         StartSpinRange=(X=(Min=-0.350000,Max=0.400000))
         StartSizeRange=(X=(Min=1.000000,Max=3.000000),Y=(Min=1.000000,Max=3.000000),Z=(Min=1.000000,Max=3.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'HTec_A.fx.Ice_Trail'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
         VelocityLossRange=(Y=(Max=10.000000),Z=(Max=10.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnHTec.IceDartTrail.SpriteEmitter3'

     Physics=PHYS_Trailer
     LifeSpan=5.0
}
