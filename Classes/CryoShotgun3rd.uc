class CryoShotgun3rd extends SPShotgunAttachment;

#exec OBJ LOAD FILE=HTec_A.ukx

var array<string> SkinRefs;

static function PreloadAssets(optional KFWeaponAttachment Spawned)
{
    local int i;

    super.PreloadAssets(Spawned);

    for (i = 0; i < default.SkinRefs.Length; ++i) {
        default.Skins[i] = Material(DynamicLoadObject(default.SkinRefs[i], class'Material'));
    }

    if (Spawned != none) {
        Spawned.Skins = default.Skins;
    }
}

static function bool UnloadAssets()
{
    local int i;

    super.UnloadAssets();

    for (i = 0; i < default.SkinRefs.Length; ++i) {
        default.Skins[i] = none;
    }

    return true;
}

// No dynamic light when firing this
simulated function WeaponLight() {}

defaultproperties
{
    mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdNailGun'
    Skins(0)=none
    SkinRefs(0)="HTEC_A.CryoShotgun.CryoShotgun_3rd"
}
