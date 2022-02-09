class CryoNade extends Nade;

#exec OBJ LOAD FILE=KF_GrenadeSnd.uax
#exec OBJ LOAD FILE=Inf_WeaponsTwo.uax
#exec OBJ LOAD FILE=KF_LAWSnd.uax

var()   int             TotalFreezes;     // haw many times do freezing
var()   float           FreezeRate;   // How often to do Freezeing
var transient float     NextFreezeTime;   // The next time that this nade will Freeze friendlies or hurt enemies

var()   sound           ExplosionSound; // The sound of the rocket exploding

var     bool            bNeedToPlayEffects; // Whether or not effects have been played yet

replication
{
    reliable if (Role==ROLE_Authority)
        bNeedToPlayEffects;
}

simulated function PostNetReceive()
{
    super.PostNetReceive();
    if( !bHasExploded && bNeedToPlayEffects )
    {
        bNeedToPlayEffects = false;
        Explode(Location, vect(0,0,1));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bHasExploded = True;
    BlowUp(HitLocation);

    PlaySound(ExplosionSound,,TransientSoundVolume);

    if( Role == ROLE_Authority )
    {
        bNeedToPlayEffects = true;
        AmbientSound=Sound'Inf_WeaponsTwo.smoke_loop';
    }

    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(Class'CryoNadeCloud',,, HitLocation, rotator(vect(0,0,1)));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
        if ( Level.DetailMode >= DM_High )
            Spawn(class'NitroGroundEffect',self,,Location);    
    }
}

function Timer()
{
    if( !bHidden )
    {
        if( !bHasExploded )
        {
            Explode(Location, vect(0,0,1));
        }
    }
    else if( bDisintegrated )
    {
        AmbientSound=none;
        Destroy();
    }
}

simulated function BlowUp(vector HitLocation)
{
    DoFreeze(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    if ( Role == ROLE_Authority )
        MakeNoise(1.0);
}

function DoFreeze(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local KFMonster KFM;

    if ( bHurtEntry )
        return;
        
    bHurtEntry = true;
    NextFreezeTime = Level.TimeSeconds + FreezeRate;
    // if( Fear != none )
        // Fear.StartleBots();

    foreach CollidingActors (class 'KFMonster', KFM, DamageRadius, HitLocation) {
        if ( KFM.Health <= 0 )
            continue;
        if ( Instigator == None || Instigator.Controller == None )
            KFM.SetDelayedDamageInstigatorController( InstigatorController );
        KFM.TakeDamage(DamageAmount,Instigator,KFM.Location,vect(0,0,0),DamageType);
    }

    bHurtEntry = false;
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if( damageType == class'SirenScreamDamage')
        Disintegrate(HitLocation, vect(0,0,1));
}

// Overridden to tweak the handling of the impact sound
simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
    local PlayerController PC;

    if ( (Pawn(Wall) != None) || (GameObjective(Wall) != None) )
    {
        Explode(Location, HitNormal);
        return;
    }

    if (!bTimerSet)
    {
        SetTimer(ExplodeTimer, false);
        bTimerSet = true;
    }

    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    DesiredRotation.Roll = 0;
    RotationRate.Roll = 0;
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        PrePivot.Z = -1.5;
            SetPhysics(PHYS_None);
        Timer();
        SetTimer(0.0,False);
        DesiredRotation = Rotation;
        DesiredRotation.Roll = 0;
        DesiredRotation.Pitch = 0;
        SetRotation(DesiredRotation);

        // if( Fear == none )
        // {
            // //(jc) Changed to use MedicNade-specific grenade that's overridden to not make the ringmaster fear it
            // Fear = Spawn(class'AvoidMarker_MedicNade');
            // Fear.SetCollisionSize(DamageRadius,DamageRadius);
            // Fear.StartleBots();
        // }

        if ( Trail != None )
            Trail.mRegen = false; // stop the emitter from regenerating
    }
    else
    {
        if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 50) )
            PlaySound(ImpactSound, SLOT_Misc );
        else
        {
            bFixedRotationDir = false;
            bRotateToDesired = true;
            DesiredRotation.Pitch = 0;
            RotationRate.Pitch = 50000;
        }
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
            PC = Level.GetLocalPlayerController();
            if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
                Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

function Tick( float DeltaTime )
{
    if( TotalFreezes > 0 && NextFreezeTime > 0 &&  NextFreezeTime < Level.TimeSeconds ) {
        TotalFreezes--;
        DoFreeze(Damage,DamageRadius, MyDamageType, MomentumTransfer, Location);
        if( TotalFreezes == 0 )
            AmbientSound=none;
    }
}

defaultproperties
{
     TotalFreezes=10
     FreezeRate=0.50
     ExplodeTimer=2
     LifeSpan=8
     ExplosionSound=SoundGroup'KF_GrenadeSnd.NadeBase.MedicNade_Explode'
     Damage=10 // Damage per second = Damage / FreezeRate
     DamageRadius=175.000000
     MyDamageType=class'DamTypeCryoNade'
     ExplosionDecal=class'NitroDecal'
     StaticMesh=StaticMesh'KF_pickups5_Trip.nades.MedicNade_Pickup'
     DrawScale=1.000000
     SoundVolume=150
     SoundRadius=100.000000
     TransientSoundVolume=2.000000
     TransientSoundRadius=200.000000
}