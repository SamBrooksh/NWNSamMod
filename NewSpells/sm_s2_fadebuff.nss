#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    int nUses = GetLocalInt(oCaster, CONST_USES_VOID_CONSUMED);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_CONSUMED_BY_VOID);
    }
    SetLocalInt(oCaster, CONST_USES_VOID_CONSUMED, nUses - 1);
}