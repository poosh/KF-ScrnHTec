class DamTypeFreezerBase extends KFWeaponDamageType
    abstract;

var float   FreezeRatio; // percent of damage used for freezing effect

// Freeze over Time
var int     FoT_Duration;   // for how long zed will freeze after receiving this damage
var float   FoT_Ratio;      // freeze per second in percent of damage received

var float   ShatteringDamageMult; // damage multiplier to already frozen zeds

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
    // do not count kills of decapitated specimens - those are counted in ScoredHeadshot()
    if ( Killed != none && Killed.bDecapitated )
        return;
        
    if( SRStatsBase(KFStatsAndAchievements)!=None && SRStatsBase(KFStatsAndAchievements).Rep!=None )
        SRStatsBase(KFStatsAndAchievements).Rep.ProgressCustomValue(Class'HTecProg',1);
}  

static function ScoredHeadshot(KFSteamStatsAndAchievements KFStatsAndAchievements, class<KFMonster> MonsterClass, bool bLaserSightedM14EBRKill)
{
    if( SRStatsBase(KFStatsAndAchievements)!=None && SRStatsBase(KFStatsAndAchievements).Rep!=None )
        SRStatsBase(KFStatsAndAchievements).Rep.ProgressCustomValue(Class'HTecProg',1);
}

defaultproperties
{
     FreezeRatio=1.000000
     ShatteringDamageMult=1.0
     WeaponClass=Class'ScrnHTec.FreezerGun'
     DeathString="%o frozen by %k."
     FemaleSuicide="%o froze till death."
     MaleSuicide="%o froze till death."
     bArmorStops=False
     DeathOverlayMaterial=Texture'HTec_A.Overlay.IceOverlay'
     DeathOverlayTime=5.000000
}
