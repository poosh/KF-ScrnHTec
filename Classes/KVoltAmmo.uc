//=============================================================================
// L85 Ammo.
//=============================================================================
class KVoltAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=50
     MaxAmmo=400
     InitialAmount=150
     PickupClass=class'KVoltAmmoAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="Cryo darts"
}
