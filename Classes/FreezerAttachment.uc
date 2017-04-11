class FreezerAttachment extends KFWeaponAttachment;

#exec OBJ LOAD FILE=HTec_A.ukx

// No dynamic light when firing this
simulated function WeaponLight(){}

defaultproperties
{
     mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdNailGun'
     MovementAnims(0)="JogF_Cheetah"
     MovementAnims(1)="JogB_Cheetah"
     MovementAnims(2)="JogL_Cheetah"
     MovementAnims(3)="JogR_Cheetah"
     TurnLeftAnim="TurnL_Cheetah"
     TurnRightAnim="TurnR_Cheetah"
     CrouchAnims(0)="CHwalkF_Cheetah"
     CrouchAnims(1)="CHwalkB_Cheetah"
     CrouchAnims(2)="CHwalkL_Cheetah"
     CrouchAnims(3)="CHwalkR_Cheetah"
     WalkAnims(0)="WalkF_Cheetah"
     WalkAnims(1)="WalkB_Cheetah"
     WalkAnims(2)="WalkL_Cheetah"
     WalkAnims(3)="WalkR_Cheetah"
     CrouchTurnRightAnim="CH_TurnR_Cheetah"
     CrouchTurnLeftAnim="CH_TurnL_Cheetah"
     IdleCrouchAnim="CHIdle_Cheetah"
     IdleWeaponAnim="Idle_Cheetah"
     IdleRestAnim="Idle_Cheetah"
     IdleChatAnim="Idle_Cheetah"
     IdleHeavyAnim="Idle_Cheetah"
     IdleRifleAnim="Idle_Cheetah"
     FireAnims(0)="Fire_AK47"
     FireAnims(1)="Fire_AK47"
     FireAnims(2)="Fire_AK47"
     FireAnims(3)="Fire_AK47"
     FireAltAnims(0)="Fire_AK47"
     FireAltAnims(1)="Fire_AK47"
     FireAltAnims(2)="Fire_AK47"
     FireAltAnims(3)="Fire_AK47"
     FireCrouchAnims(0)="CHFire_AK47"
     FireCrouchAnims(1)="CHFire_AK47"
     FireCrouchAnims(2)="CHFire_AK47"
     FireCrouchAnims(3)="CHFire_AK47"
     FireCrouchAltAnims(0)="CHFire_AK47"
     FireCrouchAltAnims(1)="CHFire_AK47"
     FireCrouchAltAnims(2)="CHFire_AK47"
     FireCrouchAltAnims(3)="CHFire_AK47"
     HitAnims(0)="HitF_Cheetah"
     HitAnims(1)="HitB_Cheetah"
     HitAnims(2)="HitL_Cheetah"
     HitAnims(3)="HitR_Cheetah"
     PostFireBlendStandAnim="Blend_Cheetah"
     PostFireBlendCrouchAnim="CHBlend_Cheetah"
     MeshRef="HTec_A.FreezerGun_3rd"
     Mesh=SkeletalMesh'HTec_A.FreezerGun_3rd'
}
