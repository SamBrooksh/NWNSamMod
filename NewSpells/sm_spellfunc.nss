#include "sm_consts"
#include "nw_i0_spells"
#include "nwnx_creature"

int SMisArcane(int class);
int SMisDivine(int class);
int SMGetCasterLevel(object oCaster, int arcaneDivine);
int SMMaximizeOrEmpower(object oCaster, int feat, int damage, int max = 6);
float SMExtended(object oCaster, int feat, float duration);
void SMIncreaseUsesPerDay(object oTarget);
void SMRestFinishedFunctions(object oSleeper);
void SMVoidFadingDebuff(object oTarget, object oCaster);
void SMApplyVoidFadingDebuff(object oTarget, object oCaster, int rounds);
void SMVoidConsumedDebuff(object oTarget, object oCaster);
void SMApplyVoidConsumed(object oTarget, object oCaster, int rounds = 1);
void SMVoidScornedDebuff(object oTarget, object oCaster);
void SMApplyVoidScorned(object oTarget, object oCaster, int rounds = 1);
void SMVoidCursedStrikesDebuff(object oTarget, object oCaster);
void SMReinivigoratedBuff(object oCaster, object oTarget);
void SMFadeOutBuff(object oGotHit);
int SMHasVoidDebuff(object oTarget, object oCaster, string base);
void SMRemoveBuff(object oTarget, string DEBUFF);
void SMSummonClone(object oCaster, Location lLocation);
object SMNoDrops(object oCreature);
void SMApplyVoidResistances(object oPlayer);

//Return TRUE if is an arcane class 
int SMisArcane(int class)
{
    switch(class)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
        
        //Add the additional classes here
        //case CLASS_PRES_PALE_MASTER:
        //case CLASS_TYPE_MYSTIC_THEURGE:
        //case CLASS_TYPE_ELDRITCH_KNIGHT:
            return TRUE;
        default:
            return FALSE;
    }
}

//Return TRUE if is divine class
int SMisDivine(int class)
{
    switch(class)
    {
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:

        //Add the additional classes here
            return TRUE;
        default:
            return FALSE;
    }
}

//Returns the modified level for spells
//class should be 0 for Arcane, and 1 for Divine I think
int SMGetCasterLevel(object oCaster, int arcaneDivine)
{
    const int ARCANE = 0;
    const int DIVINE = 1;
    int total = 0;
    //Only doing if more than one class
    if (GetClassByPosition(oCaster, 2) != CLASS_TYPE_INVALID)
    {
        for (int i = 0; i < CLASS_MAX; i += 1)  //May change if 
        {
            //Go through and add the various levels of arcane if class is arcane, and divine if divine
            int pClass = GetClassByPosition(i, oCaster);
            if (pClass != CLASS_TYPE_INVALID)
            {
                //Arcane Spellcaster
                if (SM_isArcane(pClass) && arcaneDivine == ARCANE)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                //Divine Spellcaster
                else if (SM_isDivine(pClass) && arcaneDivine == DIVINE)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                //Check for Prestige Classes Modifications
                else 
                {
                    if (arcaneDivine == ARCANE)
                    {
                        string ArcaneSpellMod = Get2DAString("classes", "ArcSpellLvlMod", pClass);
                        int ArcBonus = StringToInt(ArcaneSpellMod);
                        if (ArcaneSpellMod != "" && ArcBonus > 0)
                        {
                            total += (GetLevelByClass(pClass, oCaster) + ArcBonus - 1) / ArcBonus;
                        }
                    }
                    else
                    {
                        string DivineSpellMod = Get2DAString("classes", "DivSpellLvlMod", PClass);
                        int DivBonus = StringToInt(DivineSpellMod);
                        if (DivineSpellMod != "" && DivBonus > 0)
                        {
                            total += (GetLevelByClass(pClass, oCaster) + DivBonus - 1) / DivBonus;
                        }
                    }
                    
                }
            }
            else    //Break out a little early
                return total;
        }
    }
    return total;
}

// Returns the updated damage if the caster used Maximize or Empower
//Needs max in case of Maximize - otherwise just assumes 6 arbitraily
int SMMaximizeOrEmpower(object oCaster, int feat, int damage, int max = 6)
{
    if (feat == METAMAGIC_MAXIMIZE)
        return max;
    if (feat == METAMAGIC_EMPOWER)
        return damage * 1.5;
    return damage;
}

//Returns the Extended amount of a spell if the extended feat
//Should be able to call regardless
float SMExtended(object oCaster, int feat, float duration)
{
    if (feat == METAMAGIC_EXTEND)
        return duration * 2.0;
    return duration;
}

//Used on rest to manually add modifier to uses for a specific feat?
void SMIncreaseUsesPerDay(object oTarget)
{
    int chaMod = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
    int intMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
    if (GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oTarget))  //Being a bit more efficient
    {
        if (GetHasFeat(FEAT_VOID_MISSILE, oTarget))
        {
            int extra = GetHasFeat(FEAT_VOID_EXTRA_MISSILE, oTarget);
            int vMissUses = (extra * 3) + intMod + 1;
            SetLocalInt(oTarget, CONST_USES_VMISSILE, vMissUses);
        }
        if (GetHasFeat(FEAT_VOID_RIP, oTarget))
        {
            int vRipUses = 1 + intMod / 2;
            SetLocalInt(oTarget, CONST_USES_VOID_RIP, vRipUses);
        }
    }
}

//Put all on rest functions in here, so it is simple to add to the finished rest function
void SMRestFinishedFunctions(object oSleeper)
{
    SMIncreaseUsesPerDay(oSleeper);
}

// Persistent Debuff 
void SMVoidFadingDebuff(object oTarget, object oCaster)
{   
    int fading_div = 2;
    string concatenate = CONST_VOID_FADING_DEBUFF + ObjectToString(oCaster);
    int remaining = GetLocalInt(oTarget, concatenate);
    if (GetIsDead(oTarget) || remaining < 1)
    {
        SetLocalInt(oTarget, concatenate, 0);
        SMRemoveBuff(oTarget, concatenate);
        return;
    }
    int dc = 10 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    dc = dc + GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster) / fading_div;

    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, dc, SAVING_THROW_TYPE_ALL, oCaster))
    {
        int nDamage = GetHitDice(oTarget);
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
        //effect eVis = EffectVisualEffect(); //Find visuals for this
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        remaining = remaining + 1;    //This makes it so # of rounds successes are needed - May be too strong
    }
    SetLocalInt(oTarget, concatenate, remaining - 1);
    DelayCommand(RoundsToSeconds(1), SMVoidFadingDebuff(oTarget, oCaster));
}

void SMApplyFadingDebuff(object oTarget, object oCaster, int rounds = 1)
{
    string concatenate = CONST_VOID_FADING_DEBUFF + ObjectToString(oCaster);
    if (GetLocalInt(oTarget, concatenate))
    {   
        //Should probably have something be said as well
        //I think I'll just have it extend the duration
        int current = GetLocalInt(oTarget, concatenate) + rounds;
        SetLocalInt(oTarget, concatenate, current);
        return;//Don't have it trigger twice as often
    }
    //Put in a VFX here as well
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_BLACK);
    eVis = EffectLinkEffects(eVis, EffectIcon(EFFECT_ICON_VOID_FADING));
    eVis = EffectLinkEffects(eVis, EffectRunScript());
    eVis = TagEffect(eVis, concatenate);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    SetLocalInt(oTarget, concatenate, rounds);
    DelayCommand(RoundsToSeconds(1), SMVoidFadingDebuff(oTarget, oCaster));
}

void SMVoidConsumedDebuff(object oTarget, object oCaster)
{
    string concatenated = CONST_VOID_CONSUMED_DEBUFF + ObjectToString(oCaster);
    int curr = GetLocalInt(oTarget, concatenated);
    if (GetIsDead(oTarget) || curr < 1)
    {
        //This may not work if target is dead...
        SMRemoveBuff(oTarget, concatenated);
        SetLocalInt(oTarget, concatenated, 0);
        return;
    }
    int chance = 75;
    if (d100() > chance)
    {
        //Apply the Fading Debuff for a single round
        SMApplyFadingDebuff(oTarget, oCaster, 1);
    }
    
    SetLocalInt(oTarget, concatenated, curr - 1);
    DelayCommand(RoundsToSeconds(1), SMVoidConsumedDebuff(oTarget, oCaster));
}

void SMApplyVoidConsumed(object oTarget, object oCaster, int rounds = 1)
{
    string concatenated = CONST_VOID_CONSUMED_DEBUFF + ObjectToString(oCaster);
    int nDuration = GetLocalInt(oTarget, concatenated);
    if (nDuration < 1)
    {
        DelayCommand(RoundsToSeconds(1), SMVoidConsumedDebuff(oTarget, oCaster));
        nDuration = 0;      //Make sure negative doesn't affect it
        //May remove this check, and then that should allow multiple people to hit and apply debuffs - it will spread the duration between them though
        //That may be a bit fast though
        effect eVis = EffectVisualEffect(VFX_DUR_AURA_ODD);
        eVis = EffectLinkEffects(eVis, EffectIcon(EFFECT_ICON_VOID_CONSUMED));
        eVis = EffectLinkEffects(eVis, EffectRunScript());
        eVis = TagEffect(eVis, concatenated);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
    SetLocalInt(oTarget, concatenated, nDuration + rounds);
}

void SMApplyVoidScorned(object oTarget, object oCaster, int rounds = 1)
{
    effect eApply = EffectRunScript("sm_s2_voidscorn", "sm_s2_voidscorn", "sm_s2_voidscorn", RoundsToSeconds(1), IntToString(rounds));
}

void SMVoidCursedStrikesDebuff(object oTarget, object oCaster)
{
    string concatenated = CONST_VOID_CURSED_S_DEBUFF + ObjectToString(oCaster);
    int current = GetLocalInt(oTarget, concatenated);
    if (GetIsDead(oTarget))
    {
        return;
    }
    if (current < 1)
    {
        int nDamage = d12(GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster));
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SetLocalInt(oTarget, concatenated, 0);
        SMRemoveBuff(oTarget, concatenated);
        return;
    }
    SetLocalInt(oTarget, concatenated, current - 1);
    DelayCommand(RoundsToSeconds(1), SMVoidCursedStrikesDebuff(oTarget, oCaster));
}

void SMApplyCursedStrikes(object oTarget, object oCaster, int rounds = 5)
{
    string concatenated = CONST_VOID_CURSED_S_DEBUFF + ObjectToString(oCaster);
    if (GetLocalInt(oTarget, concatenated))
    {
        SpeakString("Target already has Cursed Strikes!", 1);
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_CURSED_STRIKES);
        return;
    }
    SetLocalInt(oTarget, concatenated, rounds);
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_BLACK);
    effect eIcon = EffectIcon(EFFECT_ICON_CURSED_STRIKES); //Make new icon
    eVis = EffectLinkEffects(eVis, eIcon);
    eVis = EffectLinkEffects(eVis, EffectRunScript());
    eVis = TagEffect(eVis, concatenated);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(rounds));
    DelayCommand(0.0, SMVoidCursedStrikesDebuff(oTarget, oCaster));
}

void SMReinivigoratedBuff(object oCaster, object oTarget)
{
    
}

void SMFadeOutBuff(object oGotHit)
{
    int nduration = 1;
    int nACBonus = 2;
    if (GetHasFeat(FEAT_VOID_IMPROVED_FADE_OUT, oGotHit))
    {
        nduration = nduration + GetAbilityModifier(ABILITY_INTELLIGENCE, oGotHit);
        nACBonus = nACBonus * GetAbilityModifier(ABILITY_INTELLIGENCE, oGotHit);    //May change the bonus of the improved
    }
    effect eACBonus = EffectACIncrease(nACBonus);
    //Need to figure out what to show on occurence
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE);
    effect eLink = EffectLinkEffects(eACBonus, eVis);
    eLink = HideEffectIcon(eLink);
    eLink = EffectLinkEffect(eLink, EffectIcon(EFFECT_ICON_VOID_FADE_OUT)); //Make new icon name/picture
    eLink = TagEffect(eLink, CONST_FADE_OUT_BUFF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oGotHit, RoundsToSeconds(nduration));
}

int SMHasVoidDebuff(object oTarget, object oCaster, string base)
{
    string concat = base + ObjectToString(oCaster);
    return GetLocalInt(oTarget, concat);
}

void SMSummonClone(object oCaster, Location lLocation)
{
    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);    //10 minutes per level I think
    int chaPen = 3;
    int strPen = 4;
    int refPen = 2;
    int willPen = 2;
    int fortPen = 2;
    if (GetHasFeat(FEAT_VOID_ASSIMILATION, oCaster))
    {
        //Reduce penalties
    }
    
    effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, chaPen);
    effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, strPen);
    effect eRef = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, refPen);
    effect eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, willPen);
    effect eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, fortPen);
    effect eCombined = EffectLinkEffects(eCha, eStr);
    eCombined = EffectLinkEffects(eRef, eCombined);
    eCombined = EffectLinkEffects(eWill, eCombined);
    eCombined = EffectLinkEffects(eFort, eCombined);
    eCombined = HideEffectIcon(eCombined);
    eCombined = EffectLinkEffect(eCombined, EffectIcon(EFFECT_ICON_CLONE_PENALTY)); //Make new icon name/picture
    eCombined = EffectLinkEffects(eCombined, EffectRunScript());
    eCombined = SupernaturalEffect(eCombined);
    eCombined = TagEffect(eCombined, CONST_VOID_SUMMON_DEBUFF);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCombined, oCaster);

    object oSummon2;
    object oSummon = ObjectCopy(oCaster, lLocation);
    int bVoidPerf = GetHasFeat(FEAT_VOID_PERFECTION, oCaster); 
    oSummon = SMNoDrops(oSummon);//This may do what I want exactly
    ForceRefreshObjectUUID(oSummon);
    NWNX_Creature_AddAssociate(oCaster, oSummon, ASSOCIATE_TYPE_SUMMONED);
    SetLocalInt(oCaster, VOID_CLONE_HEX_NUM, ObjectToString(oSummon));
    //These should be all the Feat modifications
    //Set Max HP to 75%, -2 to all Base Stats I think, unless Void Perfection
    if (bVoidPerf)
    {
        oSummon2 = ObjectCopy(oCaster, lLocation);
        oSummon2 = SMNoDrops(oSummon2); //This may do what I want exactly
        ForceRefreshObjectUUID(oSummon2);
        NWNX_Creature_AddAssociate(oCaster, oSummon2, ASSOCIATE_TYPE_SUMMONED);
        SetLocalInt(oCaster, VOID_CLONE_HEX_NUM2, ObjectToString(oSummon2));
    }
    else 
    {
        
    }
    //Need to modify weapon on hit modifier, and potentially scripts attached to the creature?
    //Probably just add the one 

}

void SMRemoveBuff(object oTarget, string DEBUFF)
{
    effect eEffect = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == DEBUFF)
            RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

object SMNoDrops(object oCreature)
{
    object oGear = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);   
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
        ActionTakeItem(oGear, oCreature);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BELT, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
    if(GetIsObjectValid(oGear))
    {
         SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    if(GetIsObjectValid(oGear))
    {
         SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_NECK, oCreature);
    if(GetIsObjectValid(oGear))
    {
        SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    if(GetIsObjectValid(oGear))
    {
         SetDroppableFlag(oGear, FALSE);
    }
    oGear = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCreature);
    if(GetIsObjectValid(oGear))
    {
         SetDroppableFlag(oGear, FALSE);
    }

    oGear = GetFirstItemInInventory(oCreature);
    while (oGear != OBJECT_INVALID)
    {
        SetDroppableFlag(oGear, FALSE);
        oGear = GetNextItemInInventory(oCreature);
    }
    return oCreature;
}

void SMApplyVoidResistances(object oPlayer)
{
    int nFireResist = 0;
    int nColdResist = 0;
    int nElecResist = 0;
    int nAcidResist = 0;
    int nSonicResist = 0;
    int nVoidResist = 0;
    int nDmgResist  = 0;

    if (GetHasFeat(FEAT_VOID_TOUCHED, oPlayer))
    {
        nFireResist += 1;
        nColdResist += 1;
        nElecResist += 1;
        nAcidResist += 1;
        nSonicResist += 1;
        nVoidResist += 1;
        nDmgResist += 1;
    }
    if (GetHasFeat(FEAT_VOID_STRENGTHEN, oPlayer))
    {
        nFireResist += 4;
        nColdResist += 4;
        nElecResist += 4;
        nAcidResist += 4;
        nSonicResist += 4;
        nVoidResist += 4;
        nDmgResist += 2;    
    }
    if (nFireResist == 0)//Should make this more conclusive in the future I think
    {
        return;
    }
    effect eFireResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, nFireResist);
    effect eColdResist = EffectDamageResistance(DAMAGE_TYPE_COLD, nColdResist);
    effect eElecResist = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nElecResist);
    effect eAcidResist = EffectDamageResistance(DAMAGE_TYPE_ACID, nAcidResist);
    effect eSonicResist = EffectDamageResistance(DAMAGE_TYPE_SONIC, nSonicResist);
    effect eVoidResist = EffectDamageResistance(DAMAGE_TYPE_VOID, nVoidResist);
    effect eDmgResist = EffectDamageResistance(DAMAGE_POWER_PLUS_FIVE, nDmgResist);

    effect eLink = EffectLinkEffects(eFireResist, eColdResist);
    eLink = EffectLinkEffects(eElecResist, eLink);
    eLink = EffectLinkEffects(eAcidResist, eLink);
    eLink = EffectLinkEffects(eSonicResist, eLink);
    eLink = EffectLinkEffects(eVoidResist, eLink);
    eLink = EffectLinkEffects(eDmgResist, eLink);
    eLink = TagEffect(CONST_VOID_RESISTS, eLink);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPlayer);
    //May need to reset on rest
}
