#include "sm_spellfunc"

void main()
{
    object oTarget = OBJECT_SELF;
    effect eOriginal = GetLastRunScriptEffect();
    object oCaster = GetEffectCreator(eOriginal);

    SMRemoveBuff(oTarget, SMVoidDebuffString(oTarget, oCaster, CONST_VOID_SCORNED_DEBUFF));
    // Should probably apply some sort of "recovery looking effect here" - just using this for now
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCessate, oTarget, 0.5);
}