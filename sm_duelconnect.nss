#include "nwnx_events"
#include "sm_cannydef"

void main()
{
    object oPC = OBJECT_SELF;
    //PrintString("In DuelConnect: " + IntToString(GetHasFeat(FEAT_CANNY_DEFENSE, oPC)));
    if (GetHasFeat(FEAT_CANNY_DEFENSE, oPC))
    {
        SMUpdateCannyDef(oPC);
    }
}