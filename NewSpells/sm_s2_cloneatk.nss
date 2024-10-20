#include "sm_spellfunc"

void main()
{
    object oAttacker = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    object oCaster = GetMaster(oAttacker);
    int voidHatred = GetHasFeat(FEAT_VOID_HATRED, oAttacker);
    if (GetHasFeat(FEAT_VOID_SCORN, oCaster))
    {
        //Add Void Scorn Chance
        SpeakString("Void Scorn Applied", 1);
    }
    if (GetHasFeat(FEAT_VOID_CONSUMED_BY_VOID, oCaster))
    {
        //Add Consumed by void chance to be applied
        SpeakString("Consumed by Void Applied", 1);
    }
    if (GetHasFeat(FEAT_SAPPING_STRIKE, oCaster))
    {

    }
}