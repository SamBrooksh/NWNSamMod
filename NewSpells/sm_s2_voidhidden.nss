#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetLocalInt(CONST_VOID_HIDDEN, oCaster);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_HIDDEN);
    }
    SetLocalInt(oCaster, CONST_VOID_HIDDEN, nUses - 1);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eLink = EffectLinkEffects(eImpact, eInvis);
    int nDuration = GetLevelByClass(oCaster, CLASS_TYPE_VOID_SCARRED);
    ApplyEffectToObject(DRUATION_TYPE_TEMPORARY, eInvis, oCaster, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oCaster);  
}
