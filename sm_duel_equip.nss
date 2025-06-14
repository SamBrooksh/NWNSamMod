#include "nwnx_events"
#include "sm_cannydef"

void main()
{
    //PrintString("Called Duel Equip");
    object oPC = OBJECT_SELF;
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));
    int nSlot = StringToInt(NWNX_Events_GetEventData("SLOT"));

    if (nSlot == INVENTORY_SLOT_CHEST && GetHasFeat(FEAT_CANNY_DEFENSE, oPC))
    {
        //PrintString("Duelists equip");
        SMUpdateCannyDef(oPC);  
    }
}