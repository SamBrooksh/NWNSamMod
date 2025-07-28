#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetCampaignInt(SM_DB_NAME, CONST_USES_VOID_HIDDEN, oCaster);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_HIDDEN);
    }
    SetCampaignInt(SM_DB_NAME, CONST_USES_VOID_HIDDEN, nUses - 1, oCaster);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eLink = EffectLinkEffects(eImpact, eInvis);
    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oCaster, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oCaster);
}