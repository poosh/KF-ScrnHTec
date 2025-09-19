class DamTypeHTecZEDGun extends DamTypeZEDGun
    abstract;


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
    WeaponClass=class'HTecZEDGun'
    HeadShotDamageMult=1.65
}