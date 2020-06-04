class ScrnVetHTec extends ScrnVeterancyTypes
    abstract;

static function int GetStatValueInt(ClientPerkRepLink StatOther, byte ReqNum)
{
    return StatOther.GetCustomValueInt(Class'HTecProg');
}

static function AddCustomStats( ClientPerkRepLink Other )
{
    super.AddCustomStats(Other); //init achievements
    Other.AddCustomValue(Class'HTecProg');
}

static function float GetWeaponMovementSpeedBonus(KFPlayerReplicationInfo KFPRI, Weapon Weap)
{
    local ScrnHumanPawn p;

    // doesn't work on client side, unless pawn is locally controlled
    if ( Controller(KFPRI.Owner) != none )
        p = ScrnHumanPawn(Controller(KFPRI.Owner).Pawn);
    if ( p != none )
        return fmax(0.0, p.GetCurrentVestClass().default.SpeedModifier);

    return 0.0;
}

static function float GetMagCapacityModStatic(KFPlayerReplicationInfo KFPRI, class<KFWeapon> Other)
{
    if ( ClassIsChildOf(Other, class'HTecZEDGun') || ClassIsChildOf(Other, class'HTecZEDMKII')
            || ClassIsChildOf(Other, class'CryoThrower')
            || ClassIsInArray(default.PerkedWeapons, Other)  //v3 - custom weapon support
        )
    {
        return 1.2001 + 0.025 * GetClientVeteranSkillLevel(KFPRI);
    }
    return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
    return AddExtraAmmoFor(KFPRI, Other.class);
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
    if ( AmmoType == class'FragAmmo' )
            return 1.0 + 0.20 * GetClientVeteranSkillLevel(KFPRI)/2; // 1 extra nade per 2 levels
    else if ( ClassIsChildOf(AmmoType, class'KVoltAmmo')
                || ClassIsChildOf(AmmoType, class'CryoThrowerAmmo')
                || ClassIsChildOf(AmmoType, class'FreezerAmmo')
                || ClassIsChildOf(AmmoType, class'FreezerDartAmmo')
                || ClassIsChildOf(AmmoType, class'ZEDGunAmmo')
                || ClassIsChildOf(AmmoType, class'ZEDMKIIAmmo' )
                || ClassIsInArray(default.PerkedAmmo, AmmoType)  //v3 - custom weapon support
            )
        return 1.0 + 0.05 * GetClientVeteranSkillLevel(KFPRI);
    return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType)
{
    if ( DmgType == default.DefaultDamageTypeNoBonus )
        return InDamage;

    if ( ClassIsChildOf(DmgType, class'DamTypeFreezerBase')
            || ClassIsChildOf(DmgType, class'DamTypeZEDGun')
            || ClassIsChildOf(DmgType, class'DamTypeZEDGunMKII') )
    {
        // 30% base bonus + 5% per level
        InDamage *= 1.30 + 0.05 * GetClientVeteranSkillLevel(KFPRI);
    }

    return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
    if ( InDamage == 0 )
        return 0;

    if ( Instigator == Injured && ClassIsChildOf(DmgType, class'DamTypeFreezerBase') )
        return 0; // can't freeze himself

    if ( (DmgType == class'DamTypeVomit' || DmgType == class'SirenScreamDamage')
            && Injured != none && Injured.ShieldStrength > 100 )
        InDamage *= 0.4;

    return max(1, InDamage); // at least 1 damage must be done
}

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
    return class'CryoNade';
}

static function bool CanCookNade(KFPlayerReplicationInfo KFPRI, Weapon Weap)
{
    return false;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
    // couldn't find any good place to put it...
    class'ScrnHorzineVestPickup'.default.CorrespondingPerkIndex = default.PerkIndex;

    if ( Item == class'FrozenDosh' ) {
        return 3.0;
    }
    else if ( ClassIsChildOf(Item, class'ZEDGunPickup') || ClassIsChildOf(Item, class'ZEDMKIIPickup')
            || ClassIsChildOf(Item, class'KVoltPickup') || ClassIsChildOf(Item, class'CryoThrowerPickup')
            || ClassIsChildOf(Item, class'FreezerPickup')
            || ClassIsChildOf(Item, class'ScrnHorzineVestPickup')
            || ClassIsInArray(default.PerkedPickups, Item) )
    {
        // 30% base discount + 5% extra per level
        return fmax(0.10, 0.70 - 0.05 * GetClientVeteranSkillLevel(KFPRI));
    }

    return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
    if ( ClassIsChildOf(Item, class'FragPickup') )
        return 1.5; // more expensive cryo nades

    return 1.0;
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    ReplaceText(S,"%L",string(Level));
    ReplaceText(S,"%x",GetPercentStr(0.30 + 0.05*Level));
    ReplaceText(S,"%m",GetPercentStr(0.20 + 0.025*Level));
    ReplaceText(S,"%a",GetPercentStr(0.05*Level));
    ReplaceText(S,"%g",string(Level/2));
    ReplaceText(S,"%$",GetPercentStr(fmin(0.90, 0.30 + 0.05*Level)));
    return S;
}

defaultproperties
{
    DefaultDamageType=Class'ScrnHTec.DamTypeFreezerDart'
    DefaultDamageTypeNoBonus=Class'ScrnHTec.DamTypeFreezerNoDmgBonus' // allows perk progression, but doesn't add damage bonuses
    SamePerkAch="OP_HTec"

    progressArray0(0)=30
    progressArray0(1)=75
    progressArray0(2)=300
    progressArray0(3)=1500
    progressArray0(4)=4500
    progressArray0(5)=10500
    progressArray0(6)=16500

    SkillInfo="PERK SKILLS (HTec v4.03):|Cryo Grenades|Higher frozen dosh value|Armor does not slow you down|60% less damage from Bloat Bile and Siren Scream while Armor > 100"
    CustomLevelInfo="PERK BONUSES (LEVEL %L):|%x more damage with ZED/Cryo Guns|%x faster freezing|%m larger ZED Gun clips|%a more ZED/Cryo Ammo|+%g extra Cryo grenades|%$ discount on HTec Inventory"

    PerkIndex=11
    OnHUDIcon=Texture'ScrnTex.Perks.HTec'
    OnHUDGoldIcon=Texture'ScrnTex.Perks.HTec_Gold'
    OnHUDIcons(0)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Gray',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Gray',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(1)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Gold',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Gold',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(2)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Green',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Green',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(3)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Blue',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Blue',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(4)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Purple',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Purple',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(5)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Orange',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Orange',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(6)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Blood',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Blood',DrawColor=(B=255,G=255,R=255,A=255))

    Requirements(0)="Freeze or zap %x ZEDs"
    VeterancyName="Horzine Technician"
}
