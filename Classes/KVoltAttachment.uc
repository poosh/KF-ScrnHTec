class KVoltAttachment extends KrissMAttachment;

var transient bool bReloading;
var transient float ReloadFinishTime;
var name ReloadAnim3rd;
var name InstigatorReloadAnim; // pawn's animation name
var float InstigatorReloadRate; // shouldn't be sligthly longer than pawns's reload animation to avoid double playing


simulated function Tick(float dt)
{
    super.Tick(dt);
    
    if ( bReloading && Level.TimeSeconds > ReloadFinishTime )
        bReloading = false;
    else if ( !bReloading && Level.NetMode == NM_Client && Instigator != none && Instigator.AnimAction == InstigatorReloadAnim )
        PlayReload();
}

simulated function PlayReload()
{
    if ( bReloading )
        return;
    bReloading = true;
    ReloadFinishTime = Level.TimeSeconds + InstigatorReloadRate; 
    PlayAnim(ReloadAnim3rd);
}

simulated function Notify_3rd_HideMag()
{
	SetBoneScale(0,0.0,'kvolt_mag');
}

simulated function Notify_3rd_ShowMag()
{
	SetBoneScale(0,1.0,'kvolt_mag');
}

defaultproperties
{
    MeshRef="HTec_A.kvolt_3rd"

    //mMuzFlashClass=Class'ScrnHTec.MuzzleFlash3rdKVolt'
    mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdNailGun'
    mShellCaseEmitterClass=None
    ReloadAnim3rd="Reload"
    InstigatorReloadRate=3.5
    InstigatorReloadAnim="Reload_Kriss"
}
