class HTecMut extends Mutator;

function PostBeginPlay()
{
    // FreezeRules are spawned inside FreezeAchHandler, which ensures that they are added 
    // AFTER ScrnGameRules. Don't spawn them anywhere else.
    class'ScrnAchievements'.static.RegisterAchievements(class'FreezeAch');
    Level.Game.Spawn(class'FreezeAchHandler');
    Destroy();
}

defaultproperties
{
    bAddToServerPackages=True
    GroupName="KF-Freezer"
    FriendlyName="ScrN Horzine Technician"
    Description="Horzine Technician featuring IJC Cryo Mass Driver 14. Requires ScrN Balance v9+."
}