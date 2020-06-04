class CryoThrowerAttachment extends KFWeaponAttachment;

var        array<string>    SkinRefs;

static function PreloadAssets(optional KFWeaponAttachment Spawned)
{
    local int i;
    
    super.PreloadAssets(Spawned);
    
    for ( i = 0; i < default.SkinRefs.Length; i++ )
        default.Skins[i] = Material(DynamicLoadObject(default.SkinRefs[i], class'Material'));


    if ( Spawned != none ){
        for ( i = 0; i < default.SkinRefs.Length; i++ )
            Spawned.Skins[i] = default.Skins[i];
    }
}

static function bool UnloadAssets()
{
    local int i;
    
    super.UnloadAssets();

    for ( i = 0; i < default.SkinRefs.Length; i++ )
        default.Skins[i] = none;

    return true;
}

// No dynamic light when firing this
simulated function WeaponLight(){}

defaultproperties
{
     mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdNailGun'
     MovementAnims(0)="JogF_IJC_BlowerThrower"
     MovementAnims(1)="JogB_IJC_BlowerThrower"
     MovementAnims(2)="JogL_IJC_BlowerThrower"
     MovementAnims(3)="JogR_IJC_BlowerThrower"
     TurnLeftAnim="TurnL_IJC_BlowerThrower"
     TurnRightAnim="TurnR_IJC_BlowerThrower"
     CrouchAnims(0)="CHWalkF_IJC_BlowerThrower"
     CrouchAnims(1)="CHWalkB_IJC_BlowerThrower"
     CrouchAnims(2)="CHWalkL_IJC_BlowerThrower"
     CrouchAnims(3)="CHWalkR_IJC_BlowerThrower"
     WalkAnims(0)="WalkF_IJC_BlowerThrower"
     WalkAnims(1)="WalkB_IJC_BlowerThrower"
     WalkAnims(2)="WalkL_IJC_BlowerThrower"
     WalkAnims(3)="WalkR_IJC_BlowerThrower"
     CrouchTurnRightAnim="CH_TurnR_IJC_BlowerThrower"
     CrouchTurnLeftAnim="CH_TurnL_IJC_BlowerThrower"
     IdleCrouchAnim="CHIdle_IJC_BlowerThrower"
     IdleWeaponAnim="Idle_IJC_BlowerThrower"
     IdleRestAnim="Idle_IJC_BlowerThrower"
     IdleChatAnim="Idle_IJC_BlowerThrower"
     IdleHeavyAnim="Idle_IJC_BlowerThrower"
     IdleRifleAnim="Idle_IJC_BlowerThrower"
     FireAnims(0)="Fire_IJC_BlowerThrower"
     FireAnims(1)="Fire_IJC_BlowerThrower"
     FireAnims(2)="Fire_IJC_BlowerThrower"
     FireAnims(3)="Fire_IJC_BlowerThrower"
     FireAltAnims(0)="Fire_IJC_BlowerThrower"
     FireAltAnims(1)="Fire_IJC_BlowerThrower"
     FireAltAnims(2)="Fire_IJC_BlowerThrower"
     FireAltAnims(3)="Fire_IJC_BlowerThrower"
     FireCrouchAnims(0)="CHFire_IJC_BlowerThrower"
     FireCrouchAnims(1)="CHFire_IJC_BlowerThrower"
     FireCrouchAnims(2)="CHFire_IJC_BlowerThrower"
     FireCrouchAnims(3)="CHFire_IJC_BlowerThrower"
     FireCrouchAltAnims(0)="CHFire_IJC_BlowerThrower"
     FireCrouchAltAnims(1)="CHFire_IJC_BlowerThrower"
     FireCrouchAltAnims(2)="CHFire_IJC_BlowerThrower"
     FireCrouchAltAnims(3)="CHFire_IJC_BlowerThrower"
     HitAnims(0)="HitF_IJC_BlowerThrower"
     HitAnims(1)="HitB_IJC_BlowerThrower"
     HitAnims(2)="HitL_IJC_BlowerThrower"
     HitAnims(3)="HitR_IJC_BlowerThrower"
     PostFireBlendStandAnim="Blend_IJC_BlowerThrower"
     PostFireBlendCrouchAnim="CHBlend_IJC_BlowerThrower"
     MeshRef="KF_Weapons3rd3_IJC.BlowerThrower_3rd"
     SkinRefs(0)="HTec_A.CryoThrower.CryoThrower_3rd_D"
     WeaponAmbientScale=2.000000
}
