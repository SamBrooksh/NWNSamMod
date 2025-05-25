#include "sm_nuiarcsetup"
#include "sm_learnspellsql"

const string LEARN_SPELL = "LEARNSPELL";
const string NUI_SPELL_HELPER = "SPELLHELPER";

//Need to change this (and everything with it)
const string NUI_SAM_ALL_SPELLS = "nui_sam_all_spells";

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
                if (SMisDivine(nClass))
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
    }
    return -1;
}

void CreateSpellHelper(object oPC, int nSpell)
{
    int nPreviousToken = NuiFindWindow(oPC, NUI_SPELL_HELPER);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPC, nPreviousToken);
    }
    string desc = Get2DAString("spells", "SpellDesc", nSpell);
    string name = Get2DAString("spells", "Name", nSpell);
    json jRoot = JsonArray();
    json jDesc = NuiText(NuiStrRef(StringToInt(desc)));
    jRoot = NuiRow(JsonArrayInsert(jRoot, jDesc));
    json nui = NuiWindow(jRoot, NuiStrRef(StringToInt(name)), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

    int nToken = NuiCreate(oPC, nui, NUI_SPELL_HELPER);
    //Increase size 
    NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 480.0f));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
}

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken       = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    int nIndex       = NuiGetEventArrayIndex();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);
    if (sWindowId != NUI_SAM_ALL_SPELLS && sWindowId != NUI_SM_LEARN_ARCANE_SPELLS && sWindowId != NUI_ARCANE_SPELL_SYNTH && sWindowId != NUI_DIVINE_SPELL_SYNTH)
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
        int nSpellsToLearn = GetLocalInt(oPlayer, SM_LEARN_ARCANE_COUNT);
        //string msg = "Button Pressed: " + IntToString(nButton);
        //SendMessageToPC(oPlayer, msg);
        //Get button pressed, right is see spell description
        if (sElement == "spell_ACCEPT")
        {
            /* Change this to accept the currently chosen spell*/
            int nSpell = GetLocalInt(oPlayer, LEARN_SPELL);
            if (nSpell == 0)
            {
                SpeakString("NEED TO SELECT SPELL TO LEARN");
                return;
            }
            int nClass = SpellLearnClass(oPlayer, ARCANE_CLASS);
            if (nClass == -1)
            {
                SpeakString("ERROR: SPELLLEARNCLASS RETURNED -1 [nui_sm_events]");
                return;
            }
            int nSpellLevel1 = SpellLevel(nClass, nSpell - 1);
            if (nSpellLevel1 == -1)
            {
                SpeakString("ERROR: SPELLLEVEL RETURNED -1 [nui_sm_events] [nSpell]");
                return;
            }

            SMSQLLearnSpell(oPlayer, nClass, nSpellLevel1, nSpell-1);
            SetLocalInt(oPlayer, SM_LEARN_ARCANE_COUNT, nSpellsToLearn - 1);
            DeleteLocalInt(oPlayer, LEARN_SPELL);
            NuiDestroy(oPlayer, nToken);
            if (nSpellsToLearn - 1 > 0)
                NUILearnNewArcaneSpells(oPlayer, nSpellsToLearn - 1);
            //I think I need to destroy and remake it the screen to remove the ones already learned
            SendMessageToPC(oPlayer, "ACCEPTED");
        }
        else 
        {
            string number = GetStringRight(sElement, GetStringLength(sElement) - 6);//The spell_ addon
            int nSpell = StringToInt(number);
            switch (nButton)
            {
                case NUI_MOUSE_BUTTON_LEFT:
                {    
                    int curr1 = GetLocalInt(oPlayer, LEARN_SPELL);
                    NuiSetBind(oPlayer, nToken, "spell_"+IntToString(curr1), NuiColor(100,100,100));
                    curr1 = nSpell;
                    SetLocalInt(oPlayer, LEARN_SPELL, curr1);
                    NuiSetBind(oPlayer, nToken, "spell_"+IntToString(curr1), NuiColor(255,0,0));
                    break;
                }
                case NUI_MOUSE_BUTTON_MIDDLE:
                {
                    break;
                }
                case NUI_MOUSE_BUTTON_RIGHT:
                {//Make a helper window with the details in it?
                    CreateSpellHelper(oPlayer, nSpell-1);
                    break;
                }
                default:
                    return;
            }
            //SendMessageToPC(oPlayer, "OTHER "+sElement);
        }
    }
    else if (sWindowId == NUI_ARCANE_SPELL_SYNTH || sWindowId == NUI_DIVINE_SPELL_SYNTH)
    {
        json jPayload = NuiGetEventPayload();
        json jKeys = JsonObjectKeys(jPayload);
        json jButton = JsonObjectGet(jPayload, "mouse_btn");
        int nButton = JsonGetInt(jButton);
        int nArcaneSpell = GetLocalInt(oPlayer, SM_SPELLSYNTHESIS_ARCANE);
        int nDivineSpell = GetLocalInt(oPlayer, SM_SPELLSYNTHESIS_DIVINE);
        //SendMessageToPC(oPlayer,"Arcane Spell Chosen: "+IntToString(nArcaneSpell));
        //SendMessageToPC(oPlayer,"Divine Spell Chosen: "+IntToString(nDivineSpell));
        //SendMessageToPC(oPlayer, sElement);
        if (sElement == "nui_sm_switch_splsyn")
        {   
            if (sWindowId == NUI_ARCANE_SPELL_SYNTH)
            {
                ExecuteScript("sm_s2_divsplsyn", oPlayer);
            }
            else 
            {
                ExecuteScript("sm_s2_arcsplsyn", oPlayer);
            }
            return;
        }
        else if (sElement == "Quit")
        {
            NuiDestroy(oPlayer, nToken);
            return;
        }

        string number = GetStringRight(sElement, GetStringLength(sElement) - 6);//The spell_ addon
        
        int nSpell = StringToInt(number);
        int nCurrSpell;
        if (sWindowId == NUI_ARCANE_SPELL_SYNTH)
        {
            NuiSetBind(oPlayer, nToken, "spell_"+IntToString(nArcaneSpell), NuiColor(100, 100, 100, 255));
            nCurrSpell = nArcaneSpell - 1;
            SetLocalInt(oPlayer, SM_SPELLSYNTHESIS_ARCANE, nSpell);
        }
        else 
        {
            
            NuiSetBind(oPlayer, nToken, "spell_"+IntToString(nDivineSpell), NuiColor(100, 100, 100, 255));
            nCurrSpell = nDivineSpell - 1;
            SetLocalInt(oPlayer, SM_SPELLSYNTHESIS_DIVINE, nSpell);
        }
        
        NuiSetBind(oPlayer, nToken, sElement, NuiColor(255, 0, 0, 255));
        string nCurrentName = Get2DAString("spells", "Name", nSpell - 1);
        json jCurrentSpell = JsonString(GetStringByStrRef(StringToInt(nCurrentName)));
        NuiSetBind(oPlayer, nToken, "CURRENTLYCHOSEN", jCurrentSpell);
    }
    
}
