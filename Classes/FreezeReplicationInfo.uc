// FreezeRules controls Zed freezing on server side.
// FreezeReplicationInfo is used to replciate freezing effects to clients.

class FreezeReplicationInfo extends ReplicationInfo;

var KFLevelRules KFLevelRules;

var byte FrozenCount;
var array<KFMonster> Frozen;

var const material FrozenMaterial;


replication {
    reliable if ( bNetDirty && Role == ROLE_Authority )
        FrozenCount;
}

static function RemoveAnimations(KFMonster M)
{
    local int i;
    
    for ( i=0; i<ArrayCount(M.MeleeAnims); ++i )
        M.MeleeAnims[i] = '';
    for ( i=0; i<ArrayCount(M.HitAnims); ++i )
        M.HitAnims[i] = '';     
    M.KFHitFront = '';
    M.KFHitBack = '';
    M.KFHitLeft = '';
    M.KFHitRight = '';
    M.IdleCrouchAnim = '';
    M.IdleWeaponAnim = '';
    M.IdleSwimAnim = '';
    M.IdleRestAnim = '';
    M.IdleHeavyAnim = '';
    M.IdleRifleAnim = '';
}

static function RestoreAnimations(KFMonster M)
{
    local int i;
    
    for ( i=0; i<ArrayCount(M.MeleeAnims); ++i )
        M.MeleeAnims[i] = M.default.MeleeAnims[i];
    for ( i=0; i<ArrayCount(M.HitAnims); ++i )
        M.HitAnims[i] = M.default.HitAnims[i];     
    M.KFHitFront = M.default.KFHitFront;
    M.KFHitBack = M.default.KFHitBack;
    M.KFHitLeft = M.default.KFHitLeft;
    M.KFHitRight = M.default.KFHitRight;
    M.IdleCrouchAnim = M.default.IdleCrouchAnim;
    M.IdleWeaponAnim = M.default.IdleWeaponAnim;
    M.IdleSwimAnim = M.default.IdleSwimAnim;
    M.IdleRestAnim = M.default.IdleRestAnim;
    M.IdleHeavyAnim = M.default.IdleHeavyAnim;
    M.IdleRifleAnim = M.default.IdleRifleAnim;
}

// adds IJC_Project_Santa Gun to the shot
auto simulated state InitShop
{
Begin:
    while ( KFLevelRules == none && FrozenCount == 0 ) {
        sleep(1.0);
        foreach DynamicActors(class'KFLevelRules', KFLevelRules)
            break;
    }
    KFLevelRules.NeutItemForSale.insert(0,1);
    KFLevelRules.NeutItemForSale[0] = class'FreezerPickup';

    if ( Role < ROLE_Authority )
        GotoState('Freezing');
    else
        GotoState('');
}

simulated state Freezing
{
    simulated function LoadFrozen()
    {
        local KFMonster M;
        local int i;

        for ( i=0; i<Frozen.length; ++i )
            RestoreAnimations(Frozen[i]);
        
        foreach DynamicActors(class'KFMonster', M) {
            if ( M.Health > 0 && M.OverlayMaterial == FrozenMaterial ) {
                RemoveAnimations(M);
                Frozen[i++] = M;
            }
        }
        Frozen.length = i;
    }

    simulated function Tick(float DeltaTime)
    {
        local int i;

        // remove dead or unfrozen zeds first
        while ( i < Frozen.length ) {
            if ( Frozen[i] == none || Frozen[i].Health <= 0 || Frozen[i].OverlayMaterial != FrozenMaterial )
                Frozen.remove(i, 1);
            else
                ++i;
        }

        if ( Frozen.length != FrozenCount )
            LoadFrozen();

        for ( i=0; i<Frozen.length; ++i ) {
            Frozen[i].bIsIdle = false;
            Frozen[i].bWaitForAnim = true;
            Frozen[i].StopAnimating();
        }
    }
}

defaultproperties
{
     FrozenMaterial=Texture'HTec_A.Overlay.IceOverlay'
}
