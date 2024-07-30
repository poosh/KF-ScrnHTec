class CryoHarpoonFire extends SealSquealFire;

var float FuseTime;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
    local CryoHarpoonProj proj;

    p = super.SpawnProjectile(Start, Dir);
    proj = CryoHarpoonProj(p);
    if (proj != none) {
        proj.ExplodeTimer = FuseTime;
    }
    return p;
}

defaultproperties
{
    ProjectileClass=Class'CryoHarpoonProj'
    AmmoClass=Class'CryoHarpoonAmmo'
    FuseTime=2.5
}