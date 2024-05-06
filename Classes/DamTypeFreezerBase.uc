class DamTypeFreezerBase extends DamTypeBaseFreeze
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
     FreezeRatio=1.000000
     ShatteringDamageMult=1.0
     WeaponClass=class'FreezerGun'
     DeathString="%o frozen by %k."
     FemaleSuicide="%o froze till death."
     MaleSuicide="%o froze till death."
     bArmorStops=False
     DeathOverlayMaterial=Texture'HTec_A.Overlay.IceOverlay'
     DeathOverlayTime=5.000000
}
