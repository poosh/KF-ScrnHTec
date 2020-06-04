class FrozenDosh extends ScrnCashPickup;

var FrozenDosh HeadDosh, NextDosh;
var bool bCryoExpertAchFailed;
// fixes none reference issue -- PooSH
function GiveCashTo( Pawn Other )
{
    local SRStatsBase Stats;
    
    if( Other.Controller!=None && Other.Controller.PlayerReplicationInfo!=none ) {
        Other.Controller.PlayerReplicationInfo.Score += CashAmount;
        Stats = SRStatsBase(PlayerController(Other.Controller).SteamStatsAndAchievements);
        if ( Stats != none ) {
            if ( Other.Health < 25 )
                class'ScrnAchievements'.static.ProgressAchievementByID(Stats.Rep, 'Freeze_DoshSui', CashAmount);
            class'ScrnAchievements'.static.ProgressAchievementByID(Stats.Rep, 'Freeze_Dosh', CashAmount);
        }
    }
    if ( DroppedBy != none && DroppedBy == Other.Controller ) {
        if ( HeadDosh == self && NextDosh == none && !bCryoExpertAchFailed )
            class'ScrnAchievements'.static.ProgressAchievementByID(Stats.Rep, 'Freeze_Expert', 1);
    }    
    else if ( HeadDosh != none )
        HeadDosh.bCryoExpertAchFailed = true;
    AnnouncePickup(Other);
    Destroy();
}

simulated function Destroyed()
{
    local FrozenDosh dosh;
    local int c;
    
    if ( HeadDosh == self ) {
        for ( dosh=NextDosh; dosh!=none && (++c)<=10; dosh=dosh.NextDosh )  {
            dosh.HeadDosh = NextDosh;
            dosh.bCryoExpertAchFailed = bCryoExpertAchFailed;
        }
    }
    else {
        for ( dosh=HeadDosh; dosh!=none && (++c)<=10; dosh=dosh.NextDosh )
            if ( dosh.NextDosh == self ) {
                dosh.NextDosh = NextDosh;
                break;
            }
    }
    
    super.Destroyed();
}

defaultproperties
{
    FadeOutTime=20
    bAutoFadeOutTime=False
    DrawScale=0.3
    UV2Texture=none
}