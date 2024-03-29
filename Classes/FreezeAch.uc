Class FreezeAch extends ScrnAchievements;

// The engine limits the size of a localized string to 4096.
// That's why we need to do the copy-paste crap below to bypass the limitaion.
var localized string DisplayName0, Description0;
var localized string DisplayName1, Description1;
var localized string DisplayName2, Description2;
var localized string DisplayName3, Description3;
var localized string DisplayName4, Description4;
var localized string DisplayName5, Description5;
var localized string DisplayName6, Description6;
var localized string DisplayName7, Description7;
var localized string DisplayName8, Description8;
var localized string DisplayName9, Description9;
var localized string DisplayName10, Description10;
var localized string DisplayName11, Description11;
var localized string DisplayName12, Description12;
var localized string DisplayName13, Description13;

simulated function SetDefaultAchievementData()
{
    AchDefs[0].DisplayName = DisplayName0;
    AchDefs[1].DisplayName = DisplayName1;
    AchDefs[2].DisplayName = DisplayName2;
    AchDefs[3].DisplayName = DisplayName3;
    AchDefs[4].DisplayName = DisplayName4;
    AchDefs[5].DisplayName = DisplayName5;
    AchDefs[6].DisplayName = DisplayName6;
    AchDefs[7].DisplayName = DisplayName7;
    AchDefs[8].DisplayName = DisplayName8;
    AchDefs[9].DisplayName = DisplayName9;
    AchDefs[10].DisplayName = DisplayName10;
    AchDefs[11].DisplayName = DisplayName11;
    AchDefs[12].DisplayName = DisplayName12;
    AchDefs[13].DisplayName = DisplayName13;

    AchDefs[0].Description = Description0;
    AchDefs[1].Description = Description1;
    AchDefs[2].Description = Description2;
    AchDefs[3].Description = Description3;
    AchDefs[4].Description = Description4;
    AchDefs[5].Description = Description5;
    AchDefs[6].Description = Description6;
    AchDefs[7].Description = Description7;
    AchDefs[8].Description = Description8;
    AchDefs[9].Description = Description9;
    AchDefs[10].Description = Description10;
    AchDefs[11].Description = Description11;
    AchDefs[12].Description = Description12;
    AchDefs[13].Description = Description13;

    super.SetDefaultAchievementData();
}

defaultproperties
{
	ProgressName="Cryo Achievements"
	DefaultAchGroup="WEAP"

    GroupInfo(1)=(Group="WEAP",Caption="Custom Weapons")

    AchDefs(0)=(id="Freeze_Dosh",DisplayName="Frozen DO$H",Description="Collect £%c from shattered zeds",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=1337,DataSize=11)
    AchDefs(1)=(id="Freeze_IceAge",DisplayName="Ice Age 2015",Description="Freeze %c zeds",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=2015,DataSize=11)
    AchDefs(2)=(id="Freeze_Chainsaw",DisplayName="Ice Sculpting",Description="Cut %c frozen zeds with a Chainsaw",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=93,DataSize=7,Group="TW")
    AchDefs(3)=(id="Freeze_Storm",DisplayName="Ice Storm",Description="Blow up 10 frozen zeds at once (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=15,DataSize=4)
    AchDefs(4)=(id="Freeze_Expert",DisplayName="Cryo Expert",Description="Do everything yourself: freeze zed, shatter it and collect all 5 pieces of frozen dosh (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=50,DataSize=6,Group="MASTER")
    AchDefs(5)=(id="Freeze_Dart",DisplayName="Cryo Sniper",Description="Decapitate 30 zeds with ice darts in a single wave(x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=10,DataSize=4)
    AchDefs(6)=(id="Freeze_Festival",DisplayName="Ice Sculpture Festival",Description="Get 20 frozen zeds at the same time",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=1,DataSize=1)
    AchDefs(7)=(id="Freeze_CR",DisplayName="Spider Rain",Description="Freeze %c Crawlers in midair",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=30,DataSize=5)
    AchDefs(8)=(id="Freeze_FP",DisplayName="Frozen Flesh",Description="Freeze the Fleshpound",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=1,DataSize=1)
    AchDefs(9)=(id="Freeze_Pat",DisplayName="Frozen Scientist",Description="Freeze the Patriarch",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=1,DataSize=1)
    AchDefs(10)=(id="Freeze_ShatterPat",DisplayName="Death to the Frozen Scientist",Description="Shatter frozen Patriarch",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=1,DataSize=1,Group="TW")
	AchDefs(11)=(id="Freeze_ShatterZeds",DisplayName="TeamWork: Shattering Ice",Description="Shatter %c zeds frozen by teammates",Icon=Texture'ScrnAch_T.Teamwork.Checked_Cryo',MaxProgress=250,DataSize=8,Group="TW")
    AchDefs(12)=(id="Freeze_DoshSui",DisplayName="Suicidal Dosh Maniac",Description="Grab £%c of frozen dosh while your health is below 25%",Icon=Texture'ScrnAch_T.Achievements.Checked_Cryo',MaxProgress=99,DataSize=7)
    AchDefs(13)=(id="OP_HTec",DisplayName="Is HTec OP?",Description="Survive 3+player game where everybody is playing Horzine Technician",Icon=Texture'ScrnAch_T.Teamwork.Checked_TW',MaxProgress=1,DataSize=1,Group="TW")

    DisplayName0="Frozen DO$H"
    DisplayName1="Ice Age 2015"
    DisplayName2="Ice Sculpting"
    DisplayName3="Ice Storm"
    DisplayName4="Cryo Expert"
    DisplayName5="Cryo Sniper"
    DisplayName6="Ice Sculpture Festival"
    DisplayName7="Spider Rain"
    DisplayName8="Frozen Flesh"
    DisplayName9="Frozen Scientist"
    DisplayName10="Death to the Frozen Scientist"
    DisplayName11="TeamWork: Shattering Ice"
    DisplayName12="Suicidal Dosh Maniac"
    DisplayName13="Is HTec OP?"

    Description0="Collect £%c from shattered zeds"
    Description1="Freeze %c zeds"
    Description2="Cut %c frozen zeds with a Chainsaw"
    Description3="Blow up 10 frozen zeds at once (x%c)"
    Description4="Do everything yourself: freeze zed, shatter it and collect all 5 pieces of frozen dosh (x%c)"
    Description5="Decapitate 30 zeds with ice darts in a single wave(x%c)"
    Description6="Get 20 frozen zeds at the same time"
    Description7="Freeze %c Crawlers in midair"
    Description8="Freeze the Fleshpound"
    Description9="Freeze the Patriarch"
    Description10="Shatter frozen Patriarch"
    Description11="Shatter %c zeds frozen by teammates"
    Description12="Grab £%c of frozen dosh while your health is below 25%"
    Description13="Survive 3+player game where everybody is playing Horzine Technician"
}