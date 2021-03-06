Class FreezeAch extends ScrnAchievements;

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
}