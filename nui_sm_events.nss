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
    //SendMessageToPC(oPlayer, sWindowId);
    if (sWindowId != NUI_SAM_ALL_SPELLS && sWindowId != NUI_SM_LEARN_ARCANE_SPELLS)
    {
        return;
    }

    if (sEvent != "mouseup")
    {
        return;
    }
    if (sWindowId == NUI_SAM_ALL_SPELLS)
    {
        json jPayload = NuiGetEventPayload();
        json jKeys = JsonObjectKeys(jPayload);
        json jButton = JsonObjectGet(jPayload, "mouse_btn");
        int nButton = JsonGetInt(jButton);
        switch(nButton)
        {
            case 0:
            if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST) == StringToInt(sElement))
            {
                //Change color of SM_DEMO to None
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST, 0);
            }
            else if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST) == StringToInt(sElement))
            {
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST, 0);
            }
            NuiSetBind(oPlayer, nToken, IntToString(GetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST)), NuiColor(100,100,100));
            NuiSetBind(oPlayer, nToken, sElement, NuiColor(0,255,0));
            SetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST, StringToInt(sElement));
            //SendMessageToPC(oPlayer, "Changed Spell");
            break;

            case 2:
            if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST) == StringToInt(sElement))
            {
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST, 0);
            }
            else if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST) == StringToInt(sElement))
            {
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST, 0);
            }
            NuiSetBind(oPlayer, nToken, IntToString(GetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST)), NuiColor(100,100,100));
            NuiSetBind(oPlayer, nToken, sElement, NuiColor(0,0,255));
            SetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST, StringToInt(sElement));
            break;

            case 3:
            if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST) == StringToInt(sElement))
            {
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST, 0);
            }
            else if (GetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST) == StringToInt(sElement))
            {
                SetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST, 0);
            }
            NuiSetBind(oPlayer, nToken, IntToString(GetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST)), NuiColor(100,100,100));
            NuiSetBind(oPlayer, nToken, sElement, NuiColor(255,0,0));
            SetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST, StringToInt(sElement));

        }
    }
    else if (sWindowId == NUI_SM_LEARN_ARCANE_SPELLS)
    {
        json jPayload = NuiGetEventPayload();
        json jKeys = JsonObjectKeys(jPayload);
        json jButton = JsonObjectGet(jPayload, "mouse_btn");
        int nButton = JsonGetInt(jButton);
        string msg = "Button Pressed: " + IntToString(nButton);
        //SendMessageToPC(oPlayer, msg);
    }
}
