class SirenDart extends IceDart;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    
    SetDrawScale(DrawScale * (0.5 +  3.0 * frand()));
}


simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local vector X;
    local Vector TempHitLocation, HitNormal;
    local array<int>    HitPoints;
    // local KFPawn HitPawn;

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
    
            // do not call to ProcessLocationalDamage() because it significantly lowers amout of damage we're dealing 
            Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
            
            // HitPawn = KFPawn(Other);
            // if ( HitPawn != none && !HitPawn.bDeleteMe)
                // HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,HitPoints);
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
    MyDamageType=Class'ScrnHTec.DamTypeSirenDart'
    Damage=8
    Speed=1000
    MaxSpeed=3000
}