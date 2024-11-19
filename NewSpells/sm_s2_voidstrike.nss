#include "sm_consts"
// Eventually Remove this
int SMHasVoidDebuff(object oTarget, object oCaster, string base)
{
    string concat = base + ObjectToString(oCaster);
    return GetLocalInt(oTarget, concat);
}

// On hit for item, deal Void damage
void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nVoidLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage = nVoidLevel / 3;
    int bFading = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
    if (GetHadFeat(FEAT_VOID_DEFT_DAMAGE, oCaster))
    {
        if (bFading)
            nDamage = nVoidLevel * 2;
        else 
            nDamage = nVoidLevel / 2;
    }
    else 
    {
        if (bFading)
            nDamage = nVoidLevel;
    }
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
    //Apply VFX
    eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_COM_HIT_NEGATIVE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
}