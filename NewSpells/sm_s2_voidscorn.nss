#include "sm_consts"

void VoidScornedDebuff(object oTarget, object oCaster, int chance)
{//Should have there be a chance for a random effect? Heal Caster?
    if (d100() > chance)
    {
        //SpeakString("Void Scorn!");
    }
}

void ApplyVoidScorned(object oTarget, object oCaster, int rounds = 1)
{
    string concatenated = CONST_VOID_SCORNED_DEBUFF + ObjectToString(oCaster);
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
    eVis = EffectLinkEffects(eVis, EffectRunScript());
    //Add Visual and Sound effects
    eVis = TagEffect(eVis, concatenated);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void RemoveVoidScorned(object oTarget, object oCaster)
{
    string concatenated = CONST_VOID_SCORNED_DEBUFF + ObjectToString(oCaster);
    int currentInt = GetLocalInt(oTarget, concatenated);
    SetLocalInt(oTarget, concatenated, currentInt - 1);
    effect eRemove = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eRemove))
    {
        if (GetEffectTag(eRemove) == concatenated)
        {
            RemoveEffect(oTarget, eRemove);
            return;
        }
        eRemove = GetNextEffect(oTarget);
    }
}

void main()
{
    int nEvent = GetLastRunScriptEffectScriptType();
    effect eOriginal = GetLastRunScriptEffect();
    object oCaster = GetEffectCreator(eOriginal);
    object oTarget = OBJECT_SELF;
    int chance = StringToInt(GetEffectString(eOriginal, 0));
    switch(nEvent)
    {
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED:
            ApplyVoidScorned(oTarget, oCaster);
            break;
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL:
            VoidScornedDebuff(oTarget, oCaster, chance);
            break;
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED:
            RemoveVoidScorned(oTarget, oCaster);
            break;
        default:
            SpeakString("Default in void scorn - Error", 1);
    }

}