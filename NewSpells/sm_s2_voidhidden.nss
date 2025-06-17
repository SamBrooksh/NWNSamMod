#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetLocalInt(oCaster, CONST_USES_VOID_HIDDEN);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_HIDDEN);
    }
    SetLocalInt(oCaster, CONST_USES_VOID_HIDDEN, nUses - 1);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eLink = EffectLinkEffects(eImpact, eInvis);
    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oCaster, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oCaster);
}