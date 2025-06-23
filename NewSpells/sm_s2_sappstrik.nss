#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    int nUses = GetLocalInt(oCaster, CONST_USES_SAPPING_STRIKE);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_SAPPING_STRIKE);
    }
    SetLocalInt(oCaster, CONST_USES_SAPPING_STRIKE, nUses - 1);

    SMApplySappingStrike(oCaster, oTarget);
}
