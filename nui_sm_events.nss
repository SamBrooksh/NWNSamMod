#include "nw_inc_nui"
#include "sm_nui_build"
#include "nwnx_creature"
#include "sm_spellfunc"

const string LEARN_SPELL_1 = "LEARNSPELL1";
const string LEARN_SPELL_2 = "LEARNSPELL2";

//Used to identify what class to add the spells to when learning from a prestige
//Will give it to just the first one found
int SpellLearnClass(object oPlayer, int nARCANEDIVINE = ARCANE_CLASS)
{
    int nIterate = 1;
    for (nIterate; nIterate < CLASS_MAX; nIterate += 1)
    {
        int nClass = GetClassByPosition(nIterate, oPlayer);
        switch(nARCANEDIVINE)
        {
            case ARCANE_CLASS:
                if (SMisArcane(nClass))
                    return nClass;
                break;
            case DIVINE_CLASS:
                if (SM_isDivine(nClass))
                    return nClass;
                break;
            default:
                break;
        }
    }
    return -1;
}

int SpellLevel(int nClass, int nSpellId)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARD:
            return StringToInt(Get2DAString("spells", "Bard", nSpellId));
        case CLASS_TYPE_CLERIC:
            return StringToInt(Get2DAString("spells", "Cleric", nSpellId));
        case CLASS_TYPE_DRUID:
            return StringToInt(Get2DAString("spells", "Druid", nSpellId));
        case CLASS_TYPE_PALADIN:
            return StringToInt(Get2DAString("spells", "Paladin", nSpellId));
        case CLASS_TYPE_RANGER:
            return StringToInt(Get2DAString("spells", "Ranger", nSpellId));
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SORCERER:
            return StringToInt(Get2DAString("spells", "Wiz_Sorc", nSpellId));
        default:
            return -1;
    }
}

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
        //string msg = "Button Pressed: " + IntToString(nButton);
        //SendMessageToPC(oPlayer, msg);
        //Get button pressed, left is choose, right is deselect, middle is see spell description
        if (sElement == "spell_ACCEPT")
        {
            int nSpell1 = GetLocalInt(oPlayer, LEARN_SPELL_1);
            int nSpell2 = GetLocalInt(oPlayer, LEARN_SPELL_2);
            if (nSpell1 == 0 || nSpell2 == 0)
            {
                SpeakString("NEED 2 SPELLS TO LEARN");
                return;
            }
            int nClass = SpellLearnClass(oPlayer, ARCANE_CLASS);
            if (nClass == -1)
            {
                SpeakString("ERROR: SPELLLEARNCLASS RETURNED -1 [nui_sm_events]");
                return;
            }
            int nSpellLevel1 = SpellLevel(nClass, nSpell1 - 1);
            if (nSpellLevel1 == -1)
            {
                SpeakString("ERROR: SPELLLEVEL RETURNED -1 [nui_sm_events] [nSpell1]");
                return;
            }
            int nSpellLevel2 = SpellLevel(nClass, nSpell2 - 1);
            if (nClass == -1)
            {
                SpeakString("ERROR: SPELLLEVEL RETURNED -1 [nui_sm_events] [nSpell2]");
                return;
            }
            NWNX_Creature_AddKnownSpell(oPlayer, nClass, nSpellLevel1, nSpell1 - 1);
            NWNX_Creature_AddKnownSpell(oPlayer, nClass, nSpellLevel2, nSpell2 - 1);
            string oPCUUID = GetObjectUUID(oPlayer);
            string sSql = "INSERT INTO spellid, spelllvl, uuid, classid INTO TABLE VALUES (?, ?, ?, ?);"
            if (NWNX_SQL_PrepareQuery(sSql))
            {
                NWNX_SQL_PreparedInt(0, nSpell1 - 1);
                NWNX_SQL_PreparedInt(1, nSpellLevel1);
                NWNX_SQL_PreparedString(2, oPCUUID);
                NWNX_SQL_PreparedInt(3, nClass);
                //Might want to just use the SQL in NWN right now? Need to look into it
            }
            SendMessageToPC(oPlayer, "ACCEPTED");
        }
        else 
        {
            string number = GetStringRight(sElement, GetStringLength(sElement) - 6);//The spell_ addon
            int nSpell = StringToInt(number);
            switch (nButton)
            {
                case NUI_MOUSE_BUTTON_LEFT:
                    int curr1 = GetLocalInt(oPlayer, LEARN_SPELL_1);
                    int curr2 = GetLocalInt(oPlayer, LEARN_SPELL_2);
                    if (curr1 > 0 && curr1 != nSpell)
                    {
                        if (curr2 > 0 && curr2 != nSpell)
                        {
                            curr1 = curr2;
                            curr2 = nSpell;
                        }
                        else if (curr2 == nSpell)
                        {
                            return;
                        }
                        else 
                        {
                            curr2 = nSpell;
                        }
                    }
                    else if (curr1 == nSpell)
                    {
                        return;
                    }
                    else 
                    {
                        curr1 = nSpell;
                        curr2 = 0;
                    }

                    SetLocalInt(oPlayer, LEARN_SPELL_1, curr1);
                    SetLocalInt(oPlayer, LEARN_SPELL_2, curr2);
                    NuiSetBind(oPlayer, nToken, "spell_"+IntToString(curr1), NuiColor(255,0,0));
                    NuiSetBind(oPlayer, nToken, "spell_"+IntToString(curr2), NuiColor(255,0,0));
                    break;
                case NUI_MOUSE_BUTTON_MIDDLE:
                case NUI_MOUSE_BUTTON_RIGHT:
                default:
                    return;
            }
            SendMessageToPC(oPlayer, "OTHER "+sElement);
        }

    }
}
