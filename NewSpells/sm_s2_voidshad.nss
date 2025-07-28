#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetCampaignInt(SM_DB_NAME, CONST_USES_VOID_SHADOW, oCaster);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_SHADOWED);
    }
    SetCampaignInt(SM_DB_NAME, CONST_USES_VOID_SHADOW, nUses - 1, oCaster);

    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);

    effect eMiss = EffectConcealment(40);

    effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eVis, eDur);
    eLink = EffectLinkEffects(eLink, eMiss);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
}