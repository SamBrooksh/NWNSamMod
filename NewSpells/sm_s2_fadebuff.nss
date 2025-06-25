#include "sm_spellfunc"

// There currently isn't anyway for this to get called - may use, may not. We will see
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