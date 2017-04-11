// Siren that is capable of shattering frozen zeds
// @author PooSH, 2015
class ZombieSirenCryo extends ZombieSiren
    abstract;
    
var transient float LastScreamTime; // prevent scream canceling
var transient float NextFrozenCheckTime; // next time we'll need to check for frozen zeds
var FreezeRules FreezeRules; // this is set in FreezeRules.PostBeginPlay()

var class<Projectile> ShatterProjClass;

function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamType, optional int HitIndex)
{
    if (InstigatedBy == none || class<KFWeaponDamageType>(DamType) == none)
        Super(Monster).TakeDamage(Damage, instigatedBy, hitLocation, momentum, DamType); // skip NONE-reference error  -- PooSH
    else 
        Super(KFMonster).TakeDamage(Damage, instigatedBy, hitLocation, momentum, DamType);
}


// should Siren scream to shatter zeds between her and A
function bool ShouldDoShatterScream(Actor A)
{
    local int i, FrozenCount, CanShatterCount;
    local float ScreamRadiusSqr;
    
    if ( FreezeRules == none || Level.TimeSeconds < NextFrozenCheckTime )
        return false; // already checked 
     
    NextFrozenCheckTime = Level.TimeSeconds + 2.0;     
    if ( FreezeRules.Frozen.Length == 0 )
        return false;
        
    NextFrozenCheckTime = Level.TimeSeconds + 5;
    ScreamRadiusSqr = ScreamRadius * ScreamRadius;
    for ( i = 0; i < FreezeRules.Frozen.Length; ++i ) {
        if ( FreezeRules.Frozen[i].M != none && FreezeRules.Frozen[i].bFrozen ) {
            ++FrozenCount;
            if ( VSizeSquared(FreezeRules.Frozen[i].M.Location - Location) < ScreamRadiusSqr) {
                ++CanShatterCount;
            }
        }
    }
    
    if ( CanShatterCount > 0 && CanShatterCount > 5.0 * frand() ) {
        NextFrozenCheckTime = Level.TimeSeconds + 5; // give cool down before next shattering 
        return true;
    }
    
    if ( CanShatterCount > 0 )
        NextFrozenCheckTime = Level.TimeSeconds + 0.5;
    else if ( FrozenCount > 0 )
        NextFrozenCheckTime = Level.TimeSeconds + 1;
        
    return false;
}

function RangedAttack(Actor A)
{
	local int LastFireTime;
	local float Dist;

	if ( bShotAnim )
		return;

    Dist = VSize(A.Location - Location);

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Claw');
		bShotAnim = true;
		LastFireTime = Level.TimeSeconds;
	}
	else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius 
            && (bDecapitated || bZapped || Level.TimeSeconds - LastScreamTime < 7) )
	{
		bShotAnim = true;
		LastFireTime = Level.TimeSeconds;
		SetAnimAction('Claw');
		//PlaySound(sound'Claw2s', SLOT_Interact); KFTODO: Replace this
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	else if( Dist <= ScreamRadius && !bDecapitated && !bZapped 
            || (Level.TimeSeconds > NextFrozenCheckTime && ShouldDoShatterScream(A)) )
	{
        LastScreamTime = Level.TimeSeconds;
		bShotAnim=true;
		SetAnimAction('Siren_Scream');
		// Only stop moving if we are close
		if( Dist < ScreamRadius * 0.25 )
		{
    		Controller.bPreparingMove = true;
    		Acceleration = vect(0,0,0);
        }
        else
        {
            Acceleration = AccelRate * Normal(A.Location - Location);
        }
	}
}    

// overridden to shatter zeds
// fixed instigator in calling TakeDamage()
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
    local KFMonster M;
	local float damageScale, dist;
	local vector dir;
	local float UsedDamageAmount;
    

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		// Or Karma actors in this case. Self inflicted Death due to flying chairs is uncool for a zombie of your stature.
		if( (Victims != self) && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('ExtendedZCollision') )
		{
            Momentum = ScreamForce; // bugfix, when pull wasn't applied always  -- PooSH
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;

            M = KFMonster(Victims);
            if ( M != none ) {
                UsedDamageAmount = 1; // just a little bit to pass it in NetDamage()
                damageScale = 1;
                
                if ( FreezeRules != none && FreezeRules.IsFrozen(M) ) {
                    ShatterFrozenZed(M, HitLocation, dist);
                    continue;
                }
            }
            else { 
                damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
                if (!Victims.IsA('KFHumanPawn')) // If it aint human, don't pull the vortex crap on it.
                    Momentum = 0;
                    
                if (Victims.IsA('KFGlassMover')) 
                    UsedDamageAmount = 100000; // Siren always shatters glass
                else
                    UsedDamageAmount = DamageAmount;
            }

			Victims.TakeDamage(damageScale * UsedDamageAmount, self, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,(damageScale * Momentum * dir),DamageType);

            if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(UsedDamageAmount, DamageRadius, Controller, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}  

// turns frozen monster into deadly ice shards
function ShatterFrozenZed(KFMonster M, Vector HitLocation, float Distance)
{
    local vector ProjLoc;
    local float ColH, ColR;
    local float DmgMult;
    local int Count;
    local Projectile proj;
    local float DistancePct; 
    
    // save zed's data, because he'll be dead after shattering
    HitLocation = M.Location; // calculate shard offset from the center of zed, not where it got hit
    ColH = M.CollisionHeight;
    ColR = M.CollisionRadius;
    Count = M.Health / 50;    
    
    if ( !FreezeRules.ShatterZed(M, -1, Controller, ScreamDamageType) )
        return; // unable to shatter zed

    DistancePct = Distance/ScreamRadius;
        
    if ( M != none )
        M.SetCollision(false);    

    DmgMult = DifficultyDamageModifer();
    if ( Count > 20 ) {
        DmgMult += float(Count-20) / 20.0; 
        Count = 20;
    }
    
    ProjLoc = HitLocation; // first projectile always spawn in the center to fly a straight line
    while ( Count > 0 ) {
        --Count;
        
        proj = Spawn(ShatterProjClass, self, '', ProjLoc, rotator(ProjLoc - Location));
        if ( proj != none ) {
            proj.Instigator = self;
            proj.Damage *= DmgMult;
            // if ( DistancePct > 0.5 ) {
                // proj.Damage *= 1.5 - DistancePct;
            // }
        }
        // pickup random location inside collision cylinder for the next projectile
        ProjLoc = HitLocation;
        ProjLoc.X += ColR * (0.70 - 1.4 * frand());
        ProjLoc.Y += ColR * (0.70 - 1.4 * frand());
        ProjLoc.Z += ColH * (0.50 - 1.0 * frand());
    }
}

 
defaultproperties
{ 
    ScreamForce=-150000 // stronger pull
    ShatterProjClass=class'ScrnHTec.SirenDart'
    MenuName="Cryo Siren"
}