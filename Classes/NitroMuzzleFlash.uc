class NitroMuzzleFlash extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    local int i;
    
    for ( i=0; i<Emitters.length; ++i ) {
        Emitters[i].SpawnParticle(1);
    }
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(X=150.000000,Z=-1000.000000)
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         DampingFactorRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.250000))
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.500000
         MaxParticles=45
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=0.700000,Max=1.700000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=1.400000,Max=1.400000)
         StartVelocityRange=(X=(Min=150.000000,Max=650.000000),Y=(Min=-155.000000,Max=155.000000),Z=(Min=-155.000000,Max=155.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=3.000000,Max=300.000000)
         RotatingSheets=1
         LowFrequencyNoiseRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=60.000000,Max=60.000000),Z=(Min=60.000000,Max=60.000000))
         LowFrequencyPoints=8
         HighFrequencyNoiseRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         HighFrequencyPoints=3
         UseLowFrequencyScale=True
         UseBranching=True
         BranchProbability=(Min=1.000000,Max=1.000000)
         BranchEmitter=1
         BranchSpawnAmountRange=(Min=1.000000,Max=2.000000)
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.370000
         FadeOutStartTime=1.120000
         MaxParticles=5
         RotationNormal=(X=40.000000,Y=40.000000,Z=40.000000)
         StartSizeRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         Texture=Texture'HTec_A.fx.Streak'
         InitialTimeRange=(Max=0.250000)
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-40.000000,Max=40.000000))
     End Object
     Emitters(1)=BeamEmitter'ScrnHTec.NitroMuzzleFlash.BeamEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         ProjectionNormal=(Y=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    	 Opacity=0.100000
         FadeOutStartTime=0.540000
         FadeInEndTime=0.015000
         MaxParticles=16
         StartLocationRange=(X=(Min=20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.300000))
         StartSpinRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.300000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.600000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=45.000000,Max=80.000000),Y=(Min=45.000000,Max=80.000000),Z=(Min=45.000000,Max=80.000000))
         Texture=Texture'HTec_A.fx.Liquid'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=200.000000,Max=600.000000),Z=(Min=-50.000000,Max=-15.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         ProjectionNormal=(Y=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.500000
         FadeOutStartTime=0.442500
         FadeInEndTime=0.007500
         MaxParticles=12
         StartLocationRange=(X=(Min=20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.300000))
         StartSpinRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.400000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.700000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.300000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000),Y=(Min=40.000000,Max=50.000000),Z=(Min=40.000000,Max=50.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=150.000000,Max=650.000000),Z=(Min=-50.000000,Max=-15.000000))
     End Object
     Emitters(3)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         ProjectionNormal=(Y=1.000000,Z=0.000000)
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
         Opacity=0.850000
         FadeOutStartTime=0.175000
         MaxParticles=8
         StartLocationRange=(X=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.400000)
         SizeScale(1)=(RelativeTime=0.560000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=35.000000,Max=60.000000),Y=(Min=35.000000,Max=60.000000),Z=(Min=35.000000,Max=60.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=0.350000,Max=0.350000)
     End Object
     Emitters(4)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         ProjectionNormal=(Y=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.250000
         FadeOutStartTime=0.442500
         FadeInEndTime=0.007500
         MaxParticles=12
         StartLocationRange=(X=(Min=20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.300000))
         StartSpinRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.400000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.900000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.300000)
         StartSizeRange=(X=(Min=35.000000,Max=55.000000),Y=(Min=35.000000,Max=55.000000),Z=(Min=35.000000,Max=55.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=350.000000,Max=600.000000),Z=(Min=-50.000000,Max=-15.000000))
     End Object
     Emitters(5)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter4'

     Begin Object Class=SparkEmitter Name=SparkEmitter0
         LineSegmentsRange=(Min=0.000000,Max=0.000000)
         TimeBetweenSegmentsRange=(Min=0.150000,Max=0.150000)
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=150,G=150,R=150,A=32))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=150,G=150,R=150,A=32))
         Opacity=0.110000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.250000
         MaxParticles=8
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=800.000000,Max=1500.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=-250.000000,Max=250.000000))
     End Object
     Emitters(6)=SparkEmitter'ScrnHTec.NitroMuzzleFlash.SparkEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=200,G=150,R=64,A=60))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=150,R=64,A=60))
         Opacity=0.200000
         FadeOutStartTime=0.100000
         MaxParticles=1
         StartSizeRange=(X=(Min=45.000000,Max=60.000000),Y=(Min=45.000000,Max=60.000000),Z=(Min=45.000000,Max=60.000000))
         Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(7)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         ProjectionNormal=(Y=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.300000
         FadeOutStartTime=2.760000
         FadeInEndTime=0.640000
         MaxParticles=60
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.150000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=2.200000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.200000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=1.000000,Max=20.000000),Y=(Min=1.000000,Max=20.000000),Z=(Min=1.000000,Max=20.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         StartVelocityRange=(X=(Min=15.000000,Max=130.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
     End Object
     Emitters(8)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         ProjectionNormal=(Y=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.300000
         FadeOutStartTime=0.300000
         FadeInEndTime=0.022500
         MaxParticles=20
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000)
         SpinsPerSecondRange=(X=(Max=0.300000))
         StartSpinRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.300000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.600000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.600000)
         StartSizeRange=(X=(Min=35.000000,Max=80.000000),Y=(Min=35.000000,Max=80.000000),Z=(Min=35.000000,Max=80.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=150.000000,Max=550.000000))
     End Object
     Emitters(9)=SpriteEmitter'ScrnHTec.NitroMuzzleFlash.SpriteEmitter7'

}
