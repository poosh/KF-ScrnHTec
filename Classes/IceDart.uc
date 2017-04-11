class IceDart extends ShotgunBullet
abstract;

var     Emitter    TrailEffect;

simulated function PostBeginPlay()
{
	Super(Projectile).PostBeginPlay();

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'IceDartTracer',self);
            Trail.Lifespan = Lifespan;
            if ( Level.DetailMode >= DM_SuperHigh ) {
                TrailEffect = Spawn(class'IceDartTrail',self);
                TrailEffect.Lifespan = Lifespan;
            }
        }
    }
}

simulated function Destroyed()
{
	if (TrailEffect !=None) {
        TrailEffect.Kill();
        TrailEffect.SetPhysics(PHYS_NONE);
    }
    Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local vector X;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPawn HitPawn;

	if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces  )
		return;

    X = Vector(Rotation);

 	if( ROBulletWhipAttachment(Other) != none )
	{
        if(!Other.Base.bDeleteMe)
        {
	        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

			if( Other == none || HitPoints.Length == 0 )
				return;

			HitPawn = KFPawn(Other);

            if (Role == ROLE_Authority)
            {
    	    	if ( HitPawn != none )
    	    	{
     				// Hit detection debugging
    				/*log("Bullet hit "$HitPawn.PlayerReplicationInfo.PlayerName);
    				HitPawn.HitStart = HitLocation;
    				HitPawn.HitEnd = HitLocation + (65535 * X);*/

                    if( !HitPawn.bDeleteMe )
                    	HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,HitPoints);


                    // Hit detection debugging
    				//if( Level.NetMode == NM_Standalone)
    				//	HitPawn.DrawBoneLocation();
    	    	}
    		}
		}
	}
    else
    {
        if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
        {
            Pawn(Other).TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        }
        else
        {
            Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        }
    }
    
	if ( ImpactEffect != None && (Level.NetMode != NM_DedicatedServer) && !Level.bDropDetail && Level.DetailMode > DM_Low )
        Spawn(ImpactEffect,,, Location, rotator(-HitNormal));

    // no penetration
    Destroy();
}

defaultproperties
{
     ImpactSounds(0)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(1)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(2)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(3)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(4)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(5)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     PenDamageReduction=0.000000
     ImpactEffect=Class'ScrnHTec.IceDartHitEffect'
     Damage=45.000000
     MyDamageType=Class'ScrnHTec.DamTypeFreezerBase'
     ExplosionDecal=Class'KFMod.NailGunDecal'
     StaticMesh=StaticMesh'HTec_A.IceDart-PROJ'
     LifeSpan=5.000000
     DrawScale=0.500000
     Speed=5000
     MaxSpeed=7000
}
