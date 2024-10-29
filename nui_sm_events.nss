#include "nw_inc_nui"
#include "sm_nui_build"

void main()
{

    object oPlayer   = NuiGetEventPlayer();
    int nToken       = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    int nIndex       = NuiGetEventArrayIndex();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);
    if (sWindowId != NUI_SAM_ALL_SPELLS)
    {
        return;
    }


    if (sEvent != "mouseup")
    {
        return;
    }

    SetLocalInt(oPlayer, "SM_DEMO", StringToInt(sElement));
    SendMessageToPC(oPlayer, "Changed Spell");
}
