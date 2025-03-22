#include "sm_spellfunc"
// Give this to the Clone to identify additional clone 
void main()
{
    object oAttacker = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    object oCaster = GetMaster(oAttacker);
    int voidHatred = GetHasFeat(FEAT_VOID_HATRED, oCaster);
    int chance = 50;    //Change this when more accurate
    if (GetHasFeat(FEAT_VOID_SCORN, oCaster))
    {
        //Add Void Scorn Chance
        if (d100() < chance)
        {
            SpeakString("Void Scorn Applied", 1);
        }
    }
    
    if (GetHasFeat(FEAT_VOID_CONSUMED_BY_VOID, oCaster))
    {
        //Add Consumed by void chance to be applied
        if (d100() < chance)
        {
            SpeakString("Consumed by Void Applied", 1);
        }
    }
    if (GetHasFeat(FEAT_SAPPING_STRIKE, oCaster))
    {

    }
}