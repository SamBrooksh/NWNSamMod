#include "nw_i0_spells"
#include "sm_consts"
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
    dc = dc + GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster) / fading_div;

    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, dc, SAVING_THROW_TYPE_ALL, oCaster))
    {
        int nDamage = GetHitDice(oTarget);
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
        effect eVis = EffectVisualEffect(VFX_IMP_MIRV_VOID); //Find visuals for this
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
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE);
    effect second = EffectIcon(EFFECT_ICON_WOUNDING);
    eVis = EffectLinkEffects(eVis, second);
    eVis = TagEffect(eVis, CONST_VOID_FADING_DEBUFF);
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
        SetLocalInt(oTarget, concatenated, 0);
        effect removeVisual = GetFirstEffect(oTarget);
        while (GetIsEffectValid(removeVisual))
        {
            if (GetEffectTag(removeVisual) == CONST_VOID_CONSUMED_DEBUFF)
            {
                RemoveEffect(oTarget, removeVisual);
            }
            removeVisual = GetNextEffect(oTarget);
        }
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
        //May remove this check, and then that should allow multiple people to hit and apply debuffs - it will spread the duration between them though
        //That may be a bit fast though
    }
    SetLocalInt(oTarget, concatenated, nDuration + rounds);
    effect eVis = EffectVisualEffect(VFX_DUR_GLOW_GREY);
    effect second = EffectIcon(EFFECT_ICON_WOUNDING);
    eVis = EffectLinkEffects(eVis, second);
    eVis = TagEffect(eVis, CONST_VOID_FADING_DEBUFF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}
