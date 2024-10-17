#include "sm_consts"
#include "nw_i0_spells"
#include "nwnx_creature"

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
        return;
    }
    int dc = 10 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    dc = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster) / fading_div;

    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, dc, oCaster))
    {
        int nDamage = GetHitDice(oTarget);
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
        effect eVis = EffectVisualEffect(); //Find visuals for this
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        rounds = rounds + 1;    //This makes it so # of rounds successes are needed - May be too strong
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

void SMApplyVoidConsumed(object oTarget, oCaster, int rounds = 1)
{
    string concatenated = CONST_VOID_CONSUMED_DEBUFF + ObjectToString(oCaster);
    int nDuration = GetLocalInt(oTarget, concatenated);
    if (nDuration < 1)
    {
        DelayCommand(RoundsToSeconds(1), SMVoidConsumedDebuff(oTarget, oCaster));
        //May remove this check, and then that should allow multiple people to hit and apply debuffs - it will spread the duration between them though
        //That may be a bit fast though
    }
    SetLocalInt(oTarget, concatenated, nDuration + rounds);
}

void SMVoidScornedDebuff(int rounds, object oTarget, object oCaster)
{
    string concatenated = CONST_VOID_SCORNED_DEBUFF + ObjectToString(oCaster);
    int current = GetLocalInt(oTarget, concatenated);
    if (GetIsDead(oTarget) || current < 1)
    {
        SetLocalInt(oTarget, concatenated, 0);
        return;
    }

    DelayCommand(RoundsToSeconds(1), SMVoidScornedDebuff(oTarget, oCaster));
}

void SMApplyVoidScorned(object oTarget, object oCaster, int rounds = 1)
{

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
    }
    DelayCommand(RoundsToSeconds(1), SMVoidCursedStrikesDebuff(oTarget, oCaster));
}

void SMApplyCursedStrikes(object oTarget, object oCaster, int rounds = 5)
{
    string concatenated = CONST_VOID_CURSED_S_DEBUFF + ObjectToString(oCaster);
    if (GetLocalInt(oTarget, concatenated))
    {
        SpeakString("Target already has Cursed Strikes!", 1);
        return;
    }
    SetLocalInt(oTarget, concatenated, rounds);
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_BLACK);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, IntToFloat(rounds));
    DelayCommand(RoundsToSeconds(1), SMVoidCursedStrikesDebuff(oTarget, oCaster));
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
    eLink = EffectTag(eLink, CONST_FADE_OUT_BUFF);
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
    eCombined = SupernaturalEffect(eCombined);
    eCombined = EffectTag(eCombined, CONST_VOID_SUMMON_DEBUFF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCombined, oCaster);

    object oSummon2;
    object oSummon = ObjectCopy(oCaster, lLocation);
    int bVoidPerf = GetHasFeat(FEAT_VOID_PERFECTION, oCaster); 
    oSummon = SMNoDrops(oSummon);//This may do what I want exactly
    ForceRefreshObjectUUID(oSummon);
    NWNX_Creature_AddAssociate(oCaster, oSummon, ASSOCIATE_TYPE_SUMMONED);
    //These should be all the Feat modifications
    //Set Max HP to 75%, -2 to all Base Stats I think, unless Void Perfection
    if (bVoidPerf)
    {
        oSummon2 = ObjectCopy(oCaster, lLocation);
        oSummon2 = SMNoDrops(oSummon2); //This may do what I want exactly
        ForceRefreshObjectUUID(oSummon2);
        NWNX_Creature_AddAssociate(oCaster, oSummon2, ASSOCIATE_TYPE_SUMMONED);
    }
    else 
    {
        
    }
    //Need to modify weapon on hit modifier, and potentially scripts attached to the creature?
    //Probably just add the one 

}

void SMRemoveBuff(object oCaster, string DEBUFF)
{
    effect eEffect = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == DEBUFF)
            RemoveEffect(oCaster, eEffect);
        eEffect = GetNextEffect(oCaster);
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