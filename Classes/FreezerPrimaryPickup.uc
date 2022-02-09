class FreezerPrimaryPickup extends KFWeaponPickup
    abstract;

var int AltMagAmmoRemaining;

function InitDroppedPickupFor(Inventory Inv)
{
    local FreezerGun W;

    W = FreezerGun(Inv);
    if ( W != none ) {
        AltMagAmmoRemaining = W.AltMagAmmoRemaining;
    }
    super.InitDroppedPickupFor(Inv);
}

defaultproperties
{
     Weight=7.000000
     cost=4000
     AmmoCost=25
     BuyClipSize=30
     PowerValue=30
     SpeedValue=55
     RangeValue=25
     Description="Cryo Mass Driver v014 or simply a 'Freezer Gun' is developed to ... blah blah blah ... freeze zeds"
     ItemName="Cryo Mass Driver 14 SE"
     ItemShortName="Cryo MD14 SE"
     AmmoItemName="Ice Darts"
     CorrespondingPerkIndex=11
     EquipmentCategoryID=3
     InventoryType=class'FreezerGun'
     PickupMessage="You got the Cryo Mass Driver 14"
     PickupSound=Sound'KF_NailShotgun.Handling.KF_NailShotgun_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'HTec_A.FreezerGun_Pickup'
     DrawScale=1.500000
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
