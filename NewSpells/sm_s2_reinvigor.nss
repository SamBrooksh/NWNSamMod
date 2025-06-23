#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    if (! SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF))
    {
        SpeakString("Target does not have FADING debuff!");
        //IncrementRemainingFeatUses(oCaster, FEAT_REINVIGORATE);
        return;
    }

    int nHealAmount = GetMaxHitPoints(oCaster);
    int nTempHPAmount = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster) * 2;
    int nDuration = nTempHPAmount;
    effect eImmediate = EffectHeal(nHealAmount);

    effect eDur = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eAdd = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    eDur = EffectLinkEffects(eDur, eAdd);
    eAdd = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    // This may not work
    eDur = EffectLinkEffects(eDur, eAdd);
    eAdd = EffectTemporaryHitpoints(nTempHPAmount);
    eDur = EffectLinkEffects(eDur, eAdd);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImmediate, oCaster);
    SMRemoveBuff(oTarget, SMVoidDebuffString(oTarget, oCaster, CONST_VOID_FADING_DEBUFF));
}