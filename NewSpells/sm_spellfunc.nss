#include "sm_consts"
#include "nw_i0_spells"
#include "x0_i0_spells"
#include "nwnx_creature"
#include "nwnx_object"
#include "nw_i0_generic"

int SMisArcane(int class);
int SMisDivine(int class);
int SMGetCasterLevel(object oCaster, int arcaneDivine);
int SMMaximizeOrEmpower(object oCaster, int feat, int damage, int max = 6);
float SMExtended(object oCaster, int feat, float duration);
int SMVoidStrike(object oCaster, object oTarget);
void SMCloneAttack(object oClone, object oTarget, object oMaster);
void SMVoidFadingDebuff(object oTarget, object oCaster);
void SMApplyVoidFadingDebuff(object oTarget, object oCaster, int rounds);
void SMVoidConsumedDebuff(object oTarget, object oCaster);
void SMApplyVoidConsumed(object oTarget, object oCaster, int rounds = 1);
void SMVoidScornedDebuff(object oTarget, object oCaster);
void SMApplyVoidScorned(object oTarget, object oCaster, int rounds = 1);
void SMVoidCursedStrikesDebuff(object oTarget, object oCaster);
void SMReinivigoratedBuff(object oCaster, object oTarget);
void SMApplySappingStrike(object oCaster, object oTarget);
void SMFadeOutBuff(object oGotHit);
string SMVoidDebuffString(object oTarget, object oCaster, string base);
int SMHasVoidDebuff(object oTarget, object oCaster, string base);
void SMRemoveBuff(object oTarget, string DEBUFF);
void SMSummonClone(object oCaster, location lLocation);
void SMNoDrops(object oCreature);
void SMSetHenchmanScripts(object oCreature);
void SMApplyVoidResistances(object oPlayer);

// Return TRUE if is an arcane class
int SMisArcane(int class)
{
    switch(class)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:

        // Add the additional classes here
        // case CLASS_PRES_PALE_MASTER:
        // case CLASS_TYPE_MYSTIC_THEURGE:
        // case CLASS_TYPE_ELDRITCH_KNIGHT:
            return TRUE;
    }
    return FALSE;
}

// Return TRUE if is divine class
int SMisDivine(int class)
{
    switch(class)
    {
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:

        // Add the additional classes here
            return TRUE;
    }
    return FALSE;
}

// Returns the modified level for spells
// Class should be 0 for Arcane, and 1 for Divine I think
int SMGetCasterLevel(object oCaster, int arcaneDivine)
{
    int total = 0;
    // Only doing if more than one class
    if (GetClassByPosition(2, oCaster) != CLASS_TYPE_INVALID)
    {
        int i = 0;
        for (i = 1; i < CLASS_MAX; i += 1)  // May change if
        {
            // Go through and add the various levels of arcane if class is arcane, and divine if divine
            int pClass = GetClassByPosition(i, oCaster);
            if (pClass != CLASS_TYPE_INVALID)
            {
                // Arcane Spellcaster
                if (SMisArcane(pClass) && arcaneDivine == ARCANE_CLASS)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                // Divine Spellcaster
                else if (SMisDivine(pClass) && arcaneDivine == DIVINE_CLASS)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                // Check for Prestige Classes Modifications
                else
                {
                    if (arcaneDivine == ARCANE_CLASS)
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
                        string DivineSpellMod = Get2DAString("classes", "DivSpellLvlMod", pClass);
                        int DivBonus = StringToInt(DivineSpellMod);
                        if (DivineSpellMod != "" && DivBonus > 0)
                        {
                            total += (GetLevelByClass(pClass, oCaster) + DivBonus - 1) / DivBonus;
                        }
                    }

                }
            }
            else    // Break out a little early - with a note for just in case
            {
                PrintString("Got an invalid class type in SMGetCasterLevel - May not be a problem - Classes Gone Through: "+ IntToString(pClass));
                return total;
            }
        }
    }
    else
    {
        // Arcane Spellcaster
        if (SMisArcane(GetClassByPosition(1, oCaster)) && arcaneDivine == ARCANE_CLASS)
        {
            total += GetLevelByPosition(1, oCaster);
        }
        // Divine Spellcaster
        else if (SMisDivine(GetClassByPosition(1, oCaster)) && arcaneDivine == DIVINE_CLASS)
        {
            total += GetLevelByPosition(1, oCaster);
        }
    }
    return total;
}

// Returns the updated damage if the caster used Maximize or Empower
// Needs max in case of Maximize - otherwise just assumes 6 arbitraily
int SMMaximizeOrEmpower(object oCaster, int feat, int damage, int max = 6)
{
    if (feat == METAMAGIC_MAXIMIZE)
        return max;
    if (feat == METAMAGIC_EMPOWER)
        return FloatToInt(IntToFloat(damage) * 1.5);
    return damage;
}

// Returns the Extended amount of a spell if the extended feat
// Should be able to call regardless
float SMExtended(object oCaster, int feat, float duration)
{
    if (feat == METAMAGIC_EXTEND)
        return duration * 2.0;
    return duration;
}

int SMVoidStrike(object oCaster, object oTarget)    //returns void strike damage amount
{
    int nVoidLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage = d2(nVoidLevel / 3);
    int bFading = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
    if (GetHasFeat(FEAT_VOID_DEFT_DAMAGE, oCaster))
    {
        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
        if (bFading)
            {nDamage = d3(nVoidLevel / 3) + nInt;}
        else 
            {nDamage = d4(nVoidLevel / 3) + nInt;}
    }
    else 
    {
        if (bFading)
            {nDamage = d2(nVoidLevel);}
    }
    return nDamage;
}

void SMCloneAttack(object oClone, object oTarget, object oMaster)
{
    int voidHatred = GetHasFeat(FEAT_VOID_HATRED, oMaster);
    int chance = 50;    //Change this when more accurate
    int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oMaster);

    if (GetHasFeat(FEAT_VOID_HATRED, oMaster))
    {
        chance += 10;
    }


    if (GetHasFeat(FEAT_VOID_SCORN, oMaster))
    {
        //Add Void Scorn Chance
        if (d100() < chance)
        {
            SpeakString("Void Scorn Applied", 1);
            SMApplyVoidScorned(oTarget, oMaster, 3);
        }
    }
    
    if (GetHasFeat(FEAT_VOID_CONSUMED_BY_VOID, oMaster))
    {
        //Add Consumed by void chance to be applied
        if (d100() < chance)
        {
            SpeakString("Consumed by Void Applied", 1);
            SMApplyVoidConsumed(oTarget, oMaster, 1);
        }
    }
    if (GetHasFeat(FEAT_SAPPING_STRIKE, oMaster))
    {
        SpeakString("Sapping Strikes Applied", 1);
        SMApplySappingStrike(oMaster, oTarget);
        
    }
    if (GetHasFeat(FEAT_VOID_RENEWALL, oMaster))
    {
        SpeakString("Void Renewall Applied", 1);
        //Maybe make this something else?
        effect eTempHit = EffectTemporaryHitpoints(d6(2));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHit, oMaster, RoundsToSeconds(10));
    }

    effect eIntBonus = EffectDamage(nIntMod, DAMAGE_TYPE_VOID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eIntBonus, oTarget);
}

// Void Fading Persistent Debuff
// On a failed Fortitude save takes HD VOID damage
// Requires the duration of saves to remove
// Need the Fading number of successes to remove
void SMVoidFadingDebuff(object oTarget, object oCaster)
{
    int fading_div = 2;
    string concatenate = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF);
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

// Applies the Fading Debuff, and starts the calling of the function as well
// If the target has the debuff already, simply extends the duration
void SMApplyFadingDebuff(object oTarget, object oCaster, int rounds = 1)
{
    string concatenate = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
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
    AssignCommand(GetModule(), DelayCommand(RoundsToSeconds(1), SMVoidFadingDebuff(oTarget, oCaster)));
}

// Void Consumed Persistent Debuff
// Target with Void Consumed has a chance to gain Fading for a round, or to extend the current one
void SMVoidConsumedDebuff(object oTarget, object oCaster)
{
    string concatenated = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF);
    int curr = GetLocalInt(oTarget, concatenated);
    
    PrintString("Void Consumed Iterate: " + IntToString(curr));
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

// Applies the Void Consumed, and makes sure to not double stack the effects
void SMApplyVoidConsumed(object oTarget, object oCaster, int rounds = 1)
{
    string concatenated = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF);
    int nDuration = GetLocalInt(oTarget, concatenated);
    if (nDuration < 1)
    {
        // Currently this is doing the Void Consumed on the clone/player - want to have this be applied on the target
        // Also is possible to have two iterations of it? Need to make sure that that doesn't happen
        // I think that I can do this to fix the first one...
        AssignCommand(GetModule(), DelayCommand(RoundsToSeconds(1), SMVoidConsumedDebuff(oTarget, oCaster)));
        nDuration = 0;      //Make sure negative doesn't affect it
        //May remove this check, and then that should allow multiple people to hit and apply debuffs - it will spread the duration between them though
        //That may be a bit fast though
        effect eVis = EffectVisualEffect(VFX_DUR_AURA_COLD);
        eVis = EffectLinkEffects(eVis, EffectIcon(EFFECT_ICON_VOID_CONSUMED));
        eVis = EffectLinkEffects(eVis, EffectRunScript("", "sm_s2_rmvdcon"));
        eVis = TagEffect(eVis, concatenated);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
    SetLocalInt(oTarget, concatenated, nDuration + rounds);
}

// Apply the Void Scorn Script
void SMApplyVoidScorned(object oTarget, object oCaster, int rounds = 1)
{
    string concatenated = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_SCORNED_DEBUFF);
    int currentInt = GetLocalInt(oTarget, concatenated);
    SetLocalInt(oTarget, concatenated, currentInt + 1);
    //-2 Will, AC, STR, DEX, Reflex
    effect eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2);
    effect eAC = EffectACDecrease(2);
    effect eSTR = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    effect eDEX = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
    effect eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 2);
    effect eVis = EffectLinkEffects(eWill, eAC);
    eVis = EffectLinkEffects(eVis, eSTR);
    eVis = EffectLinkEffects(eVis, eDEX);
    eVis = EffectLinkEffects(eVis, eReflex);
    eVis = HideEffectIcon(eVis);
    eVis = EffectLinkEffects(eVis, EffectIcon(EFFECT_ICON_VOID_SCORN));
    eVis = EffectLinkEffects(eVis, EffectRunScript("", "sm_s2_rmvscorn"));
    //Add Visual and Sound effects
    eVis = TagEffect(eVis, concatenated);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(rounds));
    effect eCessate = EffectVisualEffect(VFX_DUR_AURA_CYAN);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCessate, oTarget, 1.0);
}

// Cursed Strikes Debuff
// Once the delay is over, deal LVL d12 VOID damage
// Otherwise wait in the shadows
void SMVoidCursedStrikesDebuff(object oTarget, object oCaster)
{
    string concatenated = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CURSED_S_DEBUFF);
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

// Apply the Cursed Strikes, and prevent double uses
void SMApplyCursedStrikes(object oTarget, object oCaster, int rounds = 5)
{
    string concatenated = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CURSED_S_DEBUFF);
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
    AssignCommand(GetModule(), DelayCommand(0.0, SMVoidCursedStrikesDebuff(oTarget, oCaster)));
}

void SMReinivigoratedBuff(object oCaster, object oTarget)
{
    int nFading = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
    if (nFading == 0)
    {
        SpeakString("Target does not have Fading!");
        return;
    }
    int nLvl = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eTmpHp = EffectTemporaryHitpoints(2*nLvl);
    effect eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
    effect eRef = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
    effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
    
    effect eCombined = EffectLinkEffects(eDex, eStr);
    eCombined = EffectLinkEffects(eCombined, eTmpHp);
    eCombined = EffectLinkEffects(eCombined, eFort);
    eCombined = EffectLinkEffects(eCombined, eRef);
    eCombined = EffectLinkEffects(eCombined, eWill);
    eCombined = TagEffect(eCombined, CONST_VOID_REINVIGORATED);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCombined, oCaster, RoundsToSeconds(2*nLvl));
    effect eHeal = EffectHeal(GetMaxHitPoints(oCaster));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
    string sDebuffString = SMVoidDebuffString(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
    SMRemoveBuff(oTarget, sDebuffString);
}

void SMApplySappingStrike(object oCaster, object oTarget)
{
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster) + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_NONE, oCaster))
    {
        effect eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, 4, SAVING_THROW_ALL);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFort, oTarget, RoundsToSeconds(GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster)));
    }
}

// Fade Out Feat Persistent
// If Target is hit, gain 2 AC bonus for 1 round
// If Improved for 2 * INT bonus for
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
    eLink = EffectLinkEffects(eLink, EffectIcon(EFFECT_ICON_VOID_FADE_OUT)); //Make new icon name/picture
    eLink = TagEffect(eLink, CONST_FADE_OUT_BUFF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oGotHit, RoundsToSeconds(nduration));
}

// Helper function to identify if target has void debuff
int SMHasVoidDebuff(object oTarget, object oCaster, string base)
{
    string concat = base + ObjectToString(oCaster);
    return GetLocalInt(oTarget, concat);
}

//Helper function in case I need to change how this works later
string SMVoidDebuffString(object oTarget, object oCaster, string base)
{
    string concat = base + ObjectToString(oCaster);
    return concat;
}

// Helper function to remove Debuff's easily
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

// Helper Function to remove drops from target
void SMNoDrops(object oCreature)
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
    int nGold = GetGold(oCreature);
    TakeGoldFromCreature(nGold, oCreature, TRUE);
}

// SetHenchmanScripts
//Should change this to just SetCloneScripts
void SMSetHenchmanScripts(object oCreature)
{
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "x2_def_endcombat");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DEATH, "sm_s2_clonedeath");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "x2_def_ondamage");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "x2_def_ondisturb");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "nw_ch_ac1");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_NOTICE, "nw_ch_ac2");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "x2_def_attacked");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_RESTED, "x2_def_rested");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "nw_ch_ac9");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "nw_ch_acb");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "nw_ch_acd");
    SetAssociateListenPatterns(oCreature);
    SetLocalInt(oCreature,"NW_COM_MODE_COMBAT",ASSOCIATE_COMMAND_ATTACKNEAREST);
    SetLocalInt(oCreature,"NW_COM_MODE_MOVEMENT",ASSOCIATE_COMMAND_FOLLOWMASTER);
}

// Void Resistance Feat
// Applies the resistances to player
//I think I'm going to put these Resistances in NWNX? I'll keep this 
void SMApplyVoidResistances(object oPlayer)
{
    /*int nFireResist = 0;
    int nColdResist = 0;
    int nElecResist = 0;
    int nAcidResist = 0;
    int nSonicResist = 0;
    int nVoidResist = 0;*/
    int nDmgResist  = 0;

    if (GetHasFeat(FEAT_VOID_TOUCHED, oPlayer))
    {
        /*nFireResist += 1;
        nColdResist += 1;
        nElecResist += 1;
        nAcidResist += 1;
        nSonicResist += 1;
        nVoidResist += 1;*/
        nDmgResist += 1;
    }
    if (GetHasFeat(FEAT_VOID_STRENGTHEN, oPlayer))
    {
        /*nFireResist += VOID_STRENGTHEN_RES_BUFF_AMT;
        nColdResist += VOID_STRENGTHEN_RES_BUFF_AMT;
        nElecResist += VOID_STRENGTHEN_RES_BUFF_AMT;
        nAcidResist += VOID_STRENGTHEN_RES_BUFF_AMT;
        nSonicResist += VOID_STRENGTHEN_RES_BUFF_AMT;
        nVoidResist += VOID_STRENGTHEN_RES_BUFF_AMT;*/
        nDmgResist += VOID_STRENGTHEN_DR_BUFF_AMT;
    }
    if (nDmgResist == 0)//Should make this more conclusive in the future I think
    {
        return;
    }
    /*effect eFireResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, nFireResist);
    effect eColdResist = EffectDamageResistance(DAMAGE_TYPE_COLD, nColdResist);
    effect eElecResist = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nElecResist);
    effect eAcidResist = EffectDamageResistance(DAMAGE_TYPE_ACID, nAcidResist);
    effect eSonicResist = EffectDamageResistance(DAMAGE_TYPE_SONIC, nSonicResist);
    effect eVoidResist = EffectDamageResistance(DAMAGE_TYPE_VOID, nVoidResist);

    effect eLink = EffectLinkEffects(eFireResist, eColdResist);
    eLink = EffectLinkEffects(eElecResist, eLink);
    eLink = EffectLinkEffects(eAcidResist, eLink);
    eLink = EffectLinkEffects(eSonicResist, eLink);
    eLink = EffectLinkEffects(eVoidResist, eLink);
    eLink = EffectLinkEffects(eDmgResist, eLink);*/
    
    effect eDmgResist = EffectDamageResistance(DAMAGE_POWER_PLUS_FIVE, nDmgResist);

    effect eLink = TagEffect(eDmgResist, CONST_VOID_RESISTS);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPlayer);
    //May need to reset on Rest/Resurrection
}

//
int SMPrestigeArcaneSpellIncrease(int nClass)
{
    string ArcaneSpellMod = Get2DAString("classes", "ArcSpellLvlMod", nClass);
    int ArcBonus = StringToInt(ArcaneSpellMod);
    return ArcBonus != 0;
}

int SMGetLevel(object oTarget)
{
    int i = 1;
    int nTotal = 0;
    for (i; i < CLASS_MAX; i+=1)
    {
        if (GetClassByPosition(i, oTarget) == CLASS_TYPE_INVALID)
            return nTotal;
        nTotal += GetLevelByPosition(i, oTarget);
    }
    return nTotal;
}