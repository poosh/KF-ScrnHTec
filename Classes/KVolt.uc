//=============================================================================
// K-VOLT 2
//=============================================================================
class KVolt extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=HTec_A.ukx


//=============================================================================
// Dynamic Asset Load
//=============================================================================

//=============================================================================
// Functions
//=============================================================================

exec function ReloadMeNow()
{
	if(!AllowReload())
		return;
		
	if ( ThirdPersonActor != none && Level.NetMode != NM_DedicatedServer )
			KVoltAttachment(ThirdPersonActor).PlayReload();
			
	super.ReloadMeNow();
}

function bool RecommendRangedAttack()
{
	return true;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}


defaultproperties
{
     HudImageRef="HTec_A.KVolt.kvolt_unsel"
     SelectedHudImageRef="HTec_A.KVolt.kvolt_sel"
     SelectSoundRef="HTec_A.KVolt.kvolt_deploy"
     MeshRef="HTec_A.kvolt_mesh"
     SkinRefs(0)="HTec_A.KVolt.kvolt_tex_a"
     SkinRefs(2)="HTec_A.KVolt.kvolt_text"
     SkinRefs(3)="HTec_A.KVolt.kvolt_a_shdr"
     SkinRefs(4)="HTec_A.KVolt.kvolt_b_shdr"

     MagCapacity=40
     ReloadRate=2.900000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Kriss"
     Weight=4
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'ScrnHTec.KVoltFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     TraderInfoTexture=Texture'HTec_A.KVolt.kvolt_trader'
     PutDownAnim="PutDown"
     SelectAnimRate=1.000000
     BringUpTime=0.700000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Horzine modification of The K-Volt Prototype to fire cryo darts. K-Volt's cryo darts are weaker than Mass Driver's, but they have longer aftereffect and enhanced shattering capability."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=70
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'ScrnHTec.KVoltPickup'
     PlayerViewOffset=(X=20.000000,Y=21.500000,Z=-9.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ScrnHTec.KVoltAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="HTec K-VOLT Cryo"
     TransientSoundVolume=1.250000
}
