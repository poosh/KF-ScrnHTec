class FreezerAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=90
     MaxAmmo=720
     InitialAmount=270
     PickupClass=Class'ScrnHTec.FreezerAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="Liquid Nitrogen"
}
