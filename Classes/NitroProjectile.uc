class NitroProjectile extends ShotgunBullet
abstract;

var class<Emitter> Trail1Class, Trail2Class;
var Emitter Trail1, Trail2;


simulated function PostBeginPlay()
{
    SetTimer(0.2, true);

    Velocity = Speed * Vector(Rotation);

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail1 = Spawn(Trail1Class,self);
            Trail2 = Spawn(Trail2Class,self);
        }
    }

    Velocity.z += TossZ;
}

simulated function PostNetBeginPlay()
{
    local PlayerController PC;

    Super.PostNetBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
    {
        return;
    }

    if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
    {
        bDynamicLight = false;
        LightType = LT_None;
    }
    else
    {
        PC = Level.GetLocalPlayerController();
        if ( (Instigator != None) && (PC == Instigator.Controller) )
        {
            return;
        }

        if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
        {
            bDynamicLight = false;
            LightType = LT_None;
        }
    }
}

simulated function Landed( vector HitNormal )
{
    Explode(Location,HitNormal);
    if ( Level.DetailMode >= DM_High )
        Spawn(class'NitroGroundEffect',self,,Location);    
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

    PlaySound(ImpactSound, SLOT_Misc);

    if ( KFHumanPawn(Instigator) != none && !Level.bDropDetail ) {
        if ( EffectIsRelevant(Location,false) ) {
            Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
            if ( Level.DetailMode > DM_Low ) {
                Spawn(class'NitroSplash',self,,HitLocation,rotator(HitNormal));
                if ( Level.DetailMode >= DM_SuperHigh )
                    Spawn(class'NitroImpact',self,,HitLocation,rotator(-HitNormal));
            }
        }
    }

    SetCollisionSize(0.0, 0.0);
    Destroy();
}

// overrided to don't damage projectiles
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) 
                && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('Projectile') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) 
        && !LastTouched.IsA('FluidSurfaceInfo') && !Victims.IsA('Projectile') )
    {
        Victims = LastTouched;
        LastTouched = None;
        dir = Victims.Location - HitLocation;
        dist = FMax(1,VSize(dir));
        dir = dir/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
            (damageScale * Momentum * dir),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
    }

    bHurtEntry = false;
}

simulated function Destroyed()
{
    if ( Trail != none ) {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }
    
    if ( Trail1 != none ) {
        Trail1.Kill();
        Trail1.SetPhysics(PHYS_None);
    }    

    if ( Trail2 != none ) {
        Trail2.Kill();
        Trail2.SetPhysics(PHYS_None);
    }
    
    Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( Other == none || Other == Instigator || Other.Base == Instigator  )
        return;

    if ( Other != Instigator && !Other.IsA('PhysicsVolume') && !Other.IsA('Projectile') 
           && !Other.IsA('ROBulletWhipAttachment')  ) 
    {
        // Don't allow hits on people on the same team
        // if( KFHumanPawn(Other) != none && Instigator != none
                // && KFHumanPawn(Other).GetTeamNum() == Instigator.GetTeamNum() )
            // return;
        if ( KFPawn(Other) != none && KFPawn(Other).BurnDown > 1 )
            KFPawn(Other).BurnDown /= 2;
            
        Explode(self.Location,self.Location);
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
    if ( Role == ROLE_Authority )
    {
        if ( !Wall.bStatic && !Wall.bWorldGeometry )
        {
            if ( Instigator == None || Instigator.Controller == None )
            {
                Wall.SetDelayedDamageInstigatorController( InstigatorController );
            }

            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);

            if ( DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0 )
            {
                Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }

        MakeNoise(1.0);
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    HurtWall = None;
}

// simulated function Timer()
// {
    // if ( Trail2 != none )
        // Trail2.SetDrawScale(Trail2.DrawScale * 1.5);
// }

defaultproperties
{
     Trail1Class=Class'ScrnHTec.NitroTrail'
     Trail2Class=Class'ScrnHTec.NitroTrailB'
     MaxPenetrations=1
     PenDamageReduction=0.000000
     HeadShotDamageMult=1.000000
     Speed=750.000000
     MaxSpeed=750.000000
     TossZ=200.000000
     Damage=5
     DamageRadius=120.000000
     MomentumTransfer=0.000000
     MyDamageType=Class'ScrnHTec.DamTypeFreezerNitro'
     ImpactSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_AcidSplash'
     ExplosionDecal=Class'ScrnHTec.NitroDecal'
     DrawType=DT_None
     StaticMesh=None
     Physics=PHYS_Falling
     LifeSpan=5.000000
     DrawScale=5.000000
     Style=STY_None
     bBlockHitPointTraces=False
}
