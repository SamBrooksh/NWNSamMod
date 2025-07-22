#include "sm_spellfunc"

void main()
{
    object oTarget = OBJECT_SELF;
    effect eOriginal = GetLastRunScriptEffect();
    object oCaster = GetEffectCreator(eOriginal);

    SMRemoveBuff(oTarget, SMVoidDebuffString(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF));
    // Should probably apply some sort of "recovery looking effect here" - just using this for now
    effect eCessate = EffectVisualEffect(VFX_COM_HIT_FROST);
    PrintString("Removing Void Consumed");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCessate, oTarget);
}