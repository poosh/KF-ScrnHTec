//=============================================================================
// KVOLT 2 PICKUP
//=============================================================================
class KVoltPickup extends KFWeaponPickup;


defaultproperties
{
     Weight=3
     cost=1000
     AmmoCost=23
     BuyClipSize=40
     PowerValue=54
     SpeedValue=90
     RangeValue=80
     Description="Horzine modification of The K-Volt Prototype to fire cryo darts. K-Volt's cryo darts are weaker than Mass Driver's, but they have longer aftereffect and enhanced shattering capability."
     ItemName="HTec K-VOLT Cryo"
     ItemShortName="HTec K-VOLT"
     AmmoItemName="Cryo Darts"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=11
     EquipmentCategoryID=2
     InventoryType=class'KVolt'
     PickupMessage="You got the HTec K-VOLT Cryo"
     PickupSound=Sound'HTec_A.KVolt.kvolt_magin'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'HTec_A.kvolt_pickup'
     DrawScale=1.200000
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
