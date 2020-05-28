class FreezeAchHandler extends ScrnAchHandlerBase;

var FreezeRules FreezeRules;

function ApplyGameRules()
{
    super.ApplyGameRules();
    // make sure that FreezeRules are spawned after ScrnGameRules
    FreezeRules = Class'FreezeRules'.static.FindOrSpawnMe(Level.Game);
    FreezeRules.ScrnGameRules = GameRules;
}

function WaveEnded(byte WaveNum)
{
    local ScrnPlayerInfo SPI;
    local int i, decaps;

    for ( SPI=GameRules.PlayerInfo; SPI!=none; SPI=SPI.NextPlayerInfo ) {
        if ( SPI.PlayerOwner == none )
            continue; // player disconnected

        decaps = 0;
        for ( i=0; i<SPI.WeapInfos.length; ++i ) {
            if ( ClassIsChildOf(SPI.WeapInfos[i].DamType, class'DamTypeFreezerBase') )
                decaps += SPI.WeapInfos[i].DecapsPerWave;
        }
        if ( decaps >= 30 )
            SPI.ProgressAchievement('Freeze_Dart', 1);
    }
}
