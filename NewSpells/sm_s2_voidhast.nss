#include "sm_consts"
#include "x0_i0_spells"

void main()
{
    object oCaster = OBJECT_SELF;
    int nUses = GetLocalInt(CONST_VOID_HASTE, oCaster);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, CONST_USES_VOID_HASTE);
    }
    SetLocalInt(oCaster, CONST_VOID_HIDDEN, nUses - 1);

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oCaster))
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, oCaster, oCaster);
    if (GetHasSpellEffect(SPELL_MASS_HASTE, oCaster));
        RemoveSpellEffects(SPELL_MASS_HASTE, oCaster, oCaster);
    if (GetHasSpellEffect(647, oCaster))    //Epic Blinding Speed Feat Spell I think
        RemoveSpellEffects(647, oCaster, oCaster);

    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);

    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
}