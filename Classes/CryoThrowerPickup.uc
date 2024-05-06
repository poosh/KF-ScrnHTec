class CryoThrowerPickup extends KFWeaponPickup;

defaultproperties
{
    CorrespondingPerkIndex=11
    Weight=7
    cost=2000
    AmmoCost=55
    BuyClipSize=100
    PowerValue=50
    SpeedValue=80
    RangeValue=20
    Description="A leaf blower modified to spray liquid nitrogen."
    ItemName="HTec Cryo Thrower"
    ItemShortName="HTec Cryo Thrower"
    AmmoItemName="Bile"
    AmmoMesh=StaticMesh'KillingFloorStatics.FT_AmmoMesh'
    EquipmentCategoryID=3
    InventoryType=class'CryoThrower'
    PickupMessage="You got the CryoThrower"
    PickupSound=Sound'KF_FY_BlowerThrowerSND.foley.WEP_Bile_Foley_Pickup'
    PickupForce="AssaultRiflePickup"
    StaticMesh=StaticMesh'HTec_A.CryoThrower_Pickup'
    DrawScale=0.900000
    CollisionRadius=30.000000
    CollisionHeight=5.000000
}