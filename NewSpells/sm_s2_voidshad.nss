#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetLocalInt(oCaster, CONST_USES_VOID_SHADOW);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_SHADOWED);
    }
    SetLocalInt(oCaster, CONST_USES_VOID_SHADOW, nUses - 1);

    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);

    effect eMiss = EffectConcealment(40);

    effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eVis, eDur);
    eLink = EffectLinkEffects(eLink, eMiss);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
}