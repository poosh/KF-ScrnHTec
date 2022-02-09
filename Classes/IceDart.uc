class IceDart extends ScrnCustomShotgunBullet
abstract;

var     Emitter    TrailEffect;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer
    MinDamage = 1;

    if ( Level.NetMode != NM_DedicatedServer ) {
        if ( !PhysicsVolume.bWaterVolume ) {
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
    local int OriginalDamage;

    OriginalDamage = Damage;
    super.ProcessTouch(Other, HitLocation);
    if ( Damage < OriginalDamage ) {
        // hit something
        if ( ImpactEffect != None && Level.NetMode != NM_DedicatedServer
                && !Level.bDropDetail && Level.DetailMode > DM_Low )
            Spawn(ImpactEffect,,, HitLocation, rotator(-Vector(Rotation)));
        Destroy();
    }
}


defaultproperties
{
     ImpactSounds(0)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(1)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(2)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(3)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(4)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactSounds(5)=SoundGroup'ProjectileSounds.Bullets.Impact_Metal'
     ImpactEffect=class'IceDartHitEffect'
     Damage=45.000000
     MyDamageType=class'DamTypeFreezerBase'
     ExplosionDecal=Class'KFMod.NailGunDecal'
     StaticMesh=StaticMesh'HTec_A.IceDart-PROJ'
     LifeSpan=5.000000
     DrawScale=0.500000
     Speed=5000
     MaxSpeed=7000
     MaxPenetrations=1
}
