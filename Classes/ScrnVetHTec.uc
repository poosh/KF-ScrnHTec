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
        return 1.2001 + 0.05 * GetClientVeteranSkillLevel(KFPRI);
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
                || ClassIsChildOf(AmmoType, class'CryoHarpoonAmmo' )
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
        InDamage *= 1.3001 + 0.05 * GetClientVeteranSkillLevel(KFPRI);
    }

    return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
    if ( InDamage == 0 )
        return 0;

    if ( Instigator == Injured && ClassIsChildOf(DmgType, class'DamTypeFreezerBase') )
        return 0; // can't freeze himself

    if ( (DmgType == class'DamTypeVomit' || DmgType == class'SirenScreamDamage' || DmgType == class'DamTypeSirenDart')
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
    if ( Item == class'FrozenDosh' ) {
        return 3.0;
    }
    else if ( ClassIsChildOf(Item, class'ZEDGunPickup') || ClassIsChildOf(Item, class'ZEDMKIIPickup')
            || ClassIsChildOf(Item, class'KVoltPickup') || ClassIsChildOf(Item, class'CryoThrowerPickup')
            || ClassIsChildOf(Item, class'FreezerPickup')
            || ClassIsChildOf(Item, class'CryoHarpoonPickup')
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
    ReplaceText(S,"%m",GetPercentStr(0.20 + 0.05*Level));
    ReplaceText(S,"%a",GetPercentStr(0.05*Level));
    ReplaceText(S,"%g",string(Level/2));
    ReplaceText(S,"%$",GetPercentStr(fmin(0.90, 0.30 + 0.05*Level)));
    return S;
}

defaultproperties
{
    DefaultDamageType=class'DamTypeFreezerDart'
    DefaultDamageTypeNoBonus=class'DamTypeFreezerNoDmgBonus' // allows perk progression, but doesn't add damage bonuses
    SamePerkAch="OP_HTec"

    SkillInfo="PERK SKILLS:|Cryo Grenades|Higher frozen dosh value|Armor does not slow you down|60% less damage from Bloat Bile and Siren Scream while Armor > 100"
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
    ShortName="HTEC"
    progressArray0(0)=20
    progressArray0(1)=100
    progressArray0(2)=400
    progressArray0(3)=1700
    progressArray0(4)=3300
    progressArray0(5)=6700
    progressArray0(6)=11700
    progressArray0(7)=18300
    progressArray0(8)=26700
    progressArray0(9)=36700
    progressArray0(10)=48000
    progressArray0(11)=62000
    progressArray0(12)=77000
    progressArray0(13)=93000
    progressArray0(14)=112000
    progressArray0(15)=132000
    progressArray0(16)=153000
    progressArray0(17)=177000
    progressArray0(18)=202000
    progressArray0(19)=228000
    progressArray0(20)=257000
    progressArray0(21)=320000
    progressArray0(22)=387000
    progressArray0(23)=453000
    progressArray0(24)=520000
    progressArray0(25)=590000
    progressArray0(26)=663000
    progressArray0(27)=737000
    progressArray0(28)=810000
    progressArray0(29)=887000
    progressArray0(30)=967000
    progressArray0(31)=1063000
    progressArray0(32)=1160000
    progressArray0(33)=1260000
    progressArray0(34)=1360000
    progressArray0(35)=1470000
    progressArray0(36)=1570000
    progressArray0(37)=1680000
    progressArray0(38)=1790000
    progressArray0(39)=1900000
    progressArray0(40)=2010000
    progressArray0(41)=2140000
    progressArray0(42)=2270000
    progressArray0(43)=2400000
    progressArray0(44)=2540000
    progressArray0(45)=2670000
    progressArray0(46)=2810000
    progressArray0(47)=2950000
    progressArray0(48)=3090000
    progressArray0(49)=3240000
    progressArray0(50)=3380000
    progressArray0(51)=3550000
    progressArray0(52)=3710000
    progressArray0(53)=3880000
    progressArray0(54)=4050000
    progressArray0(55)=4220000
    progressArray0(56)=4390000
    progressArray0(57)=4560000
    progressArray0(58)=4740000
    progressArray0(59)=4910000
    progressArray0(60)=5090000
    progressArray0(61)=5290000
    progressArray0(62)=5490000
    progressArray0(63)=5690000
    progressArray0(64)=5890000
    progressArray0(65)=6090000
    progressArray0(66)=6300000
    progressArray0(67)=6500000
    progressArray0(68)=6710000
    progressArray0(69)=6920000
    progressArray0(70)=7130000
}
