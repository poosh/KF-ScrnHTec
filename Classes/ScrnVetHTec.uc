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
    if ( GetClientVeteranSkillLevel(KFPRI) > 0 ) {
        if ( ClassIsChildOf(Other, class'HTecZEDGun') || ClassIsChildOf(Other, class'HTecZEDMKII')
                || ClassIsInArray(default.PerkedWeapons, Other)  //v3 - custom weapon support
            ) 
		{
            return 1.0501 + fmin(0.30, 0.05 * GetClientVeteranSkillLevel(KFPRI));
        }
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
            return 1.0 + 0.20 * fmax(0, GetClientVeteranSkillLevel(KFPRI)/2 - 3); // 1 extra nade per 2 levelS above 6
    else if ( ClassIsChildOf(AmmoType, class'KVoltAmmo') 
                || ClassIsChildOf(AmmoType, class'CryoThrowerAmmo') 
                || ClassIsChildOf(AmmoType, class'FreezerAmmo') 
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
        if ( GetClientVeteranSkillLevel(KFPRI) == 0 )
            InDamage *= 1.05;
        else if ( GetClientVeteranSkillLevel(KFPRI) <= 6 )
            InDamage *= (1.00 + 0.10*GetClientVeteranSkillLevel(KFPRI)); // Up to 60% increase in Damage with ZED Guns
        else
            InDamage *= (1.60 + 0.05*(GetClientVeteranSkillLevel(KFPRI)-6)); 
    }

    return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
    if ( InDamage == 0 )
        return 0;
    
    if ( ClassIsChildOf(DmgType, class'DamTypeFreezerBase') )
        return 0; // can't freeze himself     

    if ( (DmgType == class'DamTypeVomit' || DmgType == class'SirenScreamDamage') 
            && Injured != none && Injured.ShieldStrength > 100 )    
        InDamage *= fmax(1.0 - 0.07*GetClientVeteranSkillLevel(KFPRI), 0.58);
    
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
        switch (GetClientVeteranSkillLevel(KFPRI)) {
            case 0: 
                return 0;
            case 1: case 2:
                return 1.5;
            case 3: case 4:
                return 2.0;
            case 5: 
                return 2.5;
            default: 
                return 3.0;
        }
    }
    else if ( ClassIsChildOf(Item, class'ZEDGunPickup') || ClassIsChildOf(Item, class'ZEDMKIIPickup')
            || ClassIsChildOf(Item, class'KVoltPickup') || ClassIsChildOf(Item, class'CryoThrowerPickup') 
            || ClassIsChildOf(Item, class'FreezerPickup')
            || ClassIsChildOf(Item, class'ScrnHorzineVestPickup')
            || ClassIsInArray(default.PerkedPickups, Item) ) 
    {
        if ( GetClientVeteranSkillLevel(KFPRI) <= 6 )
            return 0.9 - 0.10 * float(GetClientVeteranSkillLevel(KFPRI)); // 10% perk level up to 6
        else
            return fmax(0.1, 0.3 - (0.05 * float(GetClientVeteranSkillLevel(KFPRI)-6))); // 5% post level 6
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
    local byte BonusLevel;

    S = Default.CustomLevelInfo;
    BonusLevel = GetBonusLevel(Level)-6;
    
    ReplaceText(S,"%L",string(BonusLevel+6));
    ReplaceText(S,"%s",GetPercentStr(0.60 + 0.05*BonusLevel));
    //ReplaceText(S,"%c",GetPercentStr(1.00 + 0.10*BonusLevel));
    ReplaceText(S,"%d",GetPercentStr(0.7 + fmin(0.2, 0.05*BonusLevel)));
    //ReplaceText(S,"%g",string(3+BonusLevel/2));

    return S;
} 
    
defaultproperties
{
    DefaultDamageType=Class'ScrnHTec.DamTypeFreezerDart'
    DefaultDamageTypeNoBonus=Class'ScrnHTec.DamTypeFreezerNoDmgBonus' // allows perk progression, but doesn't add damage bonuses

    progressArray0(0)=30
    progressArray0(1)=75
    progressArray0(2)=300
    progressArray0(3)=1500
    progressArray0(4)=4500
    progressArray0(5)=10500
    progressArray0(6)=16500
    SRLevelEffects(0)="*** BONUS LEVEL 0 (HTec v3.10)|5% more damage with ZED Guns|5% faster freezing|5% larger ZED Gun clips|10% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(1)="*** BONUS LEVEL 1 (HTec v3.10)|10% more damage with ZED/Cryo Guns|10% faster freezing|10% larger ZED Gun clips|7% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|150% frozen dosh value|20% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(2)="*** BONUS LEVEL 2 (HTec v3.10)|20% more damage with ZED/Cryo Guns|20% faster freezing|15% larger ZED Gun clips|14% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|150% frozen dosh value|30% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(3)="*** BONUS LEVEL 3 (HTec v3.10)|30% more damage with ZED/Cryo Guns|30% faster freezing|20% larger ZED Gun clips|21% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|200% frozen dosh value|40% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(4)="*** BONUS LEVEL 4 (HTec v3.10)|40% more damage with ZED/Cryo Guns|40% faster freezing|25% larger ZED Gun clips|28% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|200% frozen dosh value|50% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(5)="*** BONUS LEVEL 5 (HTec v3.10)|50% more damage with ZED/Cryo Guns|50% faster freezing|30% larger ZED Gun clips|35% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|250% frozen dosh value|60% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    SRLevelEffects(6)="*** BONUS LEVEL 6 (HTec v3.10)|60% more damage with ZED/Cryo Guns|60% faster freezing|35% larger ZED Gun clips|42% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|300% frozen dosh value|70% HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"
    CustomLevelInfo="*** BONUS LEVEL %L (HTec v3.10)|%s more damage with ZED Guns|%s faster freezing|35% larger ZED Gun clips|42% less damage from Bloat Bile and Siren Scream while wearing Horzine Armor (>100)|300% frozen dosh value|%d HTec Inventory|Armor does not slow you down|Spawn with Cryo Grenades"

    PerkIndex=11
    OnHUDIcon=Texture'ScrnTex.Perks.HTec'
    OnHUDGoldIcon=Texture'ScrnTex.Perks.HTec_Gold'
    OnHUDIcons(0)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Gray',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Gray',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(1)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Gold',StarIcon=Texture'KillingFloor2HUD.Perk_Icons.Hud_Perk_Star_Gold',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(2)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Green',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Green',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(3)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Blue',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Blue',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(4)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Purple',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Purple',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(5)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Orange',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Orange',DrawColor=(B=255,G=255,R=255,A=255))
    OnHUDIcons(6)=(PerkIcon=Texture'ScrnTex.Perks.HTec_Blood',StarIcon=Texture'ScrnTex.Perks.Hud_Perk_Star_Blood',DrawColor=(B=255,G=255,R=255,A=255))
    
    Requirements(0)="Freeze or zap %x ZEDs"
    VeterancyName="Horzine Technician"
}    