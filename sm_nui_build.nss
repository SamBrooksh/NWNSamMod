#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "sm_spellfunc"

const string NUI_TUTORIAL_HELLO_WORLD_WINDOW = "nui_tutorial_hello_world_window";
const string NUI_SAM_ALL_SPELLS             =   "nui_sam_all_spells";
const string NUI_SM_LEARN_ARCANE_SPELLS     =   "nui_sm_learn_arcane_spells";

void Nui_Tutorial_Hello_World(object oPlayer)
{
        int nPreviousToken = NuiFindWindow(oPlayer, NUI_TUTORIAL_HELLO_WORLD_WINDOW);
        if (nPreviousToken != 0)
        {
                NuiDestroy(oPlayer, nPreviousToken);
        }


        json jRoot = JsonArray();

        json jButtonHello       = NuiId(NuiButton(JsonString("Hello")), "nui_tut_button_hello");
        json jButtonGoodBye = NuiId(NuiButton(JsonString("GoodBye")), "nui_tut_button_goodbye");

        json jRow = JsonArray();
        jRow      = JsonArrayInsert(jRow, NuiSpacer());
        jRow      = JsonArrayInsert(jRow, jButtonHello);
        jRow      = JsonArrayInsert(jRow, jButtonGoodBye);
        jRow      = JsonArrayInsert(jRow, NuiSpacer());
        jRow      = NuiRow(jRow);
        jRoot     = JsonArrayInsert(jRoot, jRow);

        json jButtonYes = NuiId(NuiButton(JsonString("Yes")), "nui_tut_button_yes");
        json jButtonNo  = NuiId(NuiButton(JsonString("No")), "nui_tut_button_no");

        jRow  = JsonArray();
        jRow  = JsonArrayInsert(jRow, NuiSpacer());
        jRow  = JsonArrayInsert(jRow, jButtonYes);
        jRow  = JsonArrayInsert(jRow, jButtonNo);
        jRow  = JsonArrayInsert(jRow, NuiSpacer());
        jRow  = NuiRow(jRow);
        jRoot = JsonArrayInsert(jRoot, jRow);

        json jButtonStop  = NuiId(NuiButton(JsonString("Stop")), "nui_tut_button_stop");
        json jButtonRest  = NuiId(NuiButton(JsonString("Rest")), "nui_tut_button_rest");
        json jButtonBored = NuiId(NuiButton(JsonString("Bored")), "nui_tut_button_bored");

        jRow  = JsonArray();
        jRow  = JsonArrayInsert(jRow, jButtonStop);
        jRow  = JsonArrayInsert(jRow, jButtonRest);
        jRow  = JsonArrayInsert(jRow, jButtonBored);
        jRow  = NuiRow(jRow);
        jRoot = JsonArrayInsert(jRoot, jRow);


        json lLabelCount = NuiLabel(NuiBind("nui_tut_label_count"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
        jRoot = JsonArrayInsert(jRoot, lLabelCount);

        jRoot = NuiCol(jRoot);

        json nui = NuiWindow(jRoot, JsonString("Hello World (title)"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

        int nToken = NuiCreate(oPlayer, nui, NUI_TUTORIAL_HELLO_WORLD_WINDOW);

        NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
        NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
        NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
        NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
        NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
        NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));



        int nCount = GetLocalInt(oPlayer, "nui_tut_button_clicks");
        NuiSetBind(oPlayer, nToken, "nui_tut_label_count", JsonString("Count: " + IntToString(nCount)));
}

void NuiAllSpells(object oPlayer)
//Add button for Arcane/Divine Spells?
{
    int nPreviousToken = NuiFindWindow(oPlayer, NUI_SAM_ALL_SPELLS);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPlayer, nPreviousToken);
    }
    json jRoot = JsonArray();
    json jLevel0 = JsonArray();
    json jLevel1 = JsonArray();
    json jLevel2 = JsonArray();
    json jLevel3 = JsonArray();
    json jLevel4 = JsonArray();
    json jLevel5 = JsonArray();
    json jLevel6 = JsonArray();
    json jLevel7 = JsonArray();
    json jLevel8 = JsonArray();
    json jLevel9 = JsonArray();
    int pos = 0;
    string name = Get2DAString("spells", "Name", pos);
    string bard = Get2DAString("spells", "Bard", pos);
    string wizard = Get2DAString("spells", "Wiz_Sorc", pos);
    string cleric = Get2DAString("spells", "Cleric", pos);
    string druid = Get2DAString("spells", "Druid", pos);
    string paladin = Get2DAString("spells", "Paladin", pos);
    string ranger = Get2DAString("spells", "Ranger", pos);
    string label = Get2DAString("spells", "Label", pos);
    int firstTime = 0;
    while (label != "")
    {
        int wizsorcbardspell = 0;
        if (wizard != "")
        {
            wizsorcbardspell = StringToInt(wizard) + 1;
        }
        else if (bard != "")
        {
            wizsorcbardspell = StringToInt(wizard) + 1;
        }
        //Offset by 1 so that can tell if valid

        if (GetHasSpell(pos, oPlayer) && wizsorcbardspell != 0)
        {
            //Add the id for the NUI later
            json jButton = NuiButton(JsonString(GetStringByStrRef(StringToInt(name))));
            jButton = NuiId(jButton, IntToString(pos));

            switch (wizsorcbardspell)
            {
                case 1:
                    if ((firstTime & 1) != 1)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 0"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel0 = JsonArrayInsert(jLevel0, jLabel);
                        firstTime += 1;
                    }
                    jLevel0 = JsonArrayInsert(jLevel0, jButton);
                    break;
                case 2:
                    if ((firstTime & 2) != 2)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 1"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel1 = JsonArrayInsert(jLevel1, jLabel);
                        firstTime += 2;
                    }
                    jLevel1 = JsonArrayInsert(jLevel1, jButton);
                    break;
                case 3:
                    if ((firstTime & 4) != 4)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 2"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel2 = JsonArrayInsert(jLevel2, jLabel);
                        firstTime += 4;
                    }
                    jLevel2 = JsonArrayInsert(jLevel2, jButton);
                    break;
                case 4:
                    if ((firstTime & 8) != 8)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 3"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel3 = JsonArrayInsert(jLevel3, jLabel);
                        firstTime += 8;
                    }
                    jLevel3 = JsonArrayInsert(jLevel3, jButton);
                    break;
                case 5:
                    if ((firstTime & 16) != 16)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 4"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel4 = JsonArrayInsert(jLevel4, jLabel);
                        firstTime += 16;
                    }
                    jLevel4 = JsonArrayInsert(jLevel4, jButton);
                    break;
                case 6:
                    if ((firstTime & 32) != 32)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 5"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel5 = JsonArrayInsert(jLevel5, jLabel);
                        firstTime += 32;
                    }
                    jLevel5 = JsonArrayInsert(jLevel5, jButton);
                    break;
                case 7:
                    if ((firstTime & 64) != 64)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 6"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel6 = JsonArrayInsert(jLevel6, jLabel);
                        firstTime += 64;
                    }
                    jLevel6 = JsonArrayInsert(jLevel6, jButton);
                    break;
                case 8:
                    if ((firstTime & 128) != 128)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 7"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel7 = JsonArrayInsert(jLevel7, jLabel);
                        firstTime += 128;
                    }
                    jLevel7 = JsonArrayInsert(jLevel7, jButton);
                    break;
                case 9:
                    if ((firstTime & 256) != 256)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 8"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel8 = JsonArrayInsert(jLevel8, jLabel);
                        firstTime += 256;
                    }
                    jLevel8 = JsonArrayInsert(jLevel8, jButton);
                    break;
                case 10:
                    if ((firstTime & 512) != 512)
                    {
                        json jLabel = NuiText(JsonString("\nLevel 9"), FALSE, NUI_SCROLLBARS_NONE);
                        jLabel = NuiWidth(jLabel, 60.0);
                        jLevel9 = JsonArrayInsert(jLevel9, jLabel);
                        firstTime += 512;
                    }
                    jLevel9 = JsonArrayInsert(jLevel9, jButton);
                    break;
            }
        }
        pos += 1;
        name = Get2DAString("spells", "Name", pos);
        label = Get2DAString("spells", "Label", pos);
        bard = Get2DAString("spells", "Bard", pos);
        wizard = Get2DAString("spells", "Wiz_Sorc", pos);
    }
    jLevel0 = NuiRow(jLevel0);
    jLevel1 = NuiRow(jLevel1);
    jLevel2 = NuiRow(jLevel2);
    jLevel3 = NuiRow(jLevel3);
    jLevel4 = NuiRow(jLevel4);
    jLevel5 = NuiRow(jLevel5);
    jLevel6 = NuiRow(jLevel6);
    jLevel7 = NuiRow(jLevel7);
    jLevel8 = NuiRow(jLevel8);
    jLevel9 = NuiRow(jLevel9);

    jRoot = JsonArrayInsert(jRoot, jLevel0);
    jRoot = JsonArrayInsert(jRoot, jLevel1);
    jRoot = JsonArrayInsert(jRoot, jLevel2);
    jRoot = JsonArrayInsert(jRoot, jLevel3);
    jRoot = JsonArrayInsert(jRoot, jLevel4);
    jRoot = JsonArrayInsert(jRoot, jLevel5);
    jRoot = JsonArrayInsert(jRoot, jLevel6);
    jRoot = JsonArrayInsert(jRoot, jLevel7);
    jRoot = JsonArrayInsert(jRoot, jLevel8);
    jRoot = JsonArrayInsert(jRoot, jLevel9);

    jRoot = NuiCol(jRoot);
    json nui = NuiWindow(jRoot, JsonString("Hello World (title)"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPlayer, nui, NUI_SAM_ALL_SPELLS);

    NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
    NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));

}

void LearnNewArcaneSpells(object oPlayer)
{
    int nPreviousToken = NuiFindWindow(oPlayer, NUI_SM_LEARN_ARCANE_SPELLS);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPlayer, nPreviousToken);
    }
    json jRoot = JsonArray();
    json jLevel0 = JsonArray();
    json jLevel1 = JsonArray();
    json jLevel2 = JsonArray();
    json jLevel3 = JsonArray();
    json jLevel4 = JsonArray();
    json jLevel5 = JsonArray();
    json jLevel6 = JsonArray();
    json jLevel7 = JsonArray();
    json jLevel8 = JsonArray();
    json jLevel9 = JsonArray();
    int pos = 0;
    string name = Get2DAString("spells", "Name", pos);
    
    string label = Get2DAString("spells", "Label", pos);
    int nArcaneCasterLevel = (SMGetCasterLevel(oPlayer, 0) + 1) / 2;
    int bard = GetLevelByClass(CLASS_TYPE_BARD, oPlayer);
    int wizSorc = GetLevelByClass(CLASS_TYPE_WIZARD, oPlayer);
    int classType = CLASS_TYPE_WIZARD;
    string classTypeName = "Wiz_Sorc";
    if (wizSorc < 1)
    {
        wizSorc = GetLevelByClass(CLASS_TYPE_SORCERER, oPlayer);
    }

    if (bard > wizSorc)
    {
        classType = CLASS_TYPE_BARD;
        classTypeName = "Bard";
    }
    
    string spellLevel = Get2DAString("spells", classTypeName, pos);

    while (label != "")
    {
        json jButton = NuiButton(JsonString(GetStringByStrRef(StringToInt(name))));
        jButton = NuiId(jButton, IntToString(pos));
        if (nArcaneCasterLevel < StringToInt(spellLevel) && !GetIsInKnownSpellList(oPlayer, classType, pos))
        {
            switch (StringToInt(spellLevel))
            {
                case 1:
                    jLevel0 = JsonArrayInsert(jLevel0, jButton);
                    break;
                case 2:
                    jLevel1 = JsonArrayInsert(jLevel1, jButton);
                    break;
                case 3:
                    jLevel2 = JsonArrayInsert(jLevel2, jButton);
                    break;
                case 4:
                    jLevel3 = JsonArrayInsert(jLevel3, jButton);
                    break;
                case 5:
                    jLevel4 = JsonArrayInsert(jLevel4, jButton);
                    break;
                case 6:
                    jLevel5 = JsonArrayInsert(jLevel5, jButton);
                    break;
                case 7:
                    jLevel6 = JsonArrayInsert(jLevel6, jButton);
                    break;
                case 8:
                    jLevel7 = JsonArrayInsert(jLevel7, jButton);
                    break;
                case 9:
                    jLevel8 = JsonArrayInsert(jLevel8, jButton);
                    break;
                case 10:
                    jLevel9 = JsonArrayInsert(jLevel9, jButton);
                    break;
            }
        }
        pos += 1;
        name = Get2DAString("spells", "Name", pos);
        spellLevel = Get2DAString("spells", classTypeName, pos);
        label = Get2DAString("spells", "Label", pos);
        
    }
    jLevel0 = NuiRow(jLevel0);
    jLevel1 = NuiRow(jLevel1);
    jLevel2 = NuiRow(jLevel2);
    jLevel3 = NuiRow(jLevel3);
    jLevel4 = NuiRow(jLevel4);
    jLevel5 = NuiRow(jLevel5);
    jLevel6 = NuiRow(jLevel6);
    jLevel7 = NuiRow(jLevel7);
    jLevel8 = NuiRow(jLevel8);
    jLevel9 = NuiRow(jLevel9);

    jRoot = JsonArrayInsert(jRoot, jLevel0);
    jRoot = JsonArrayInsert(jRoot, jLevel1);
    jRoot = JsonArrayInsert(jRoot, jLevel2);
    jRoot = JsonArrayInsert(jRoot, jLevel3);
    jRoot = JsonArrayInsert(jRoot, jLevel4);
    jRoot = JsonArrayInsert(jRoot, jLevel5);
    jRoot = JsonArrayInsert(jRoot, jLevel6);
    jRoot = JsonArrayInsert(jRoot, jLevel7);
    jRoot = JsonArrayInsert(jRoot, jLevel8);
    jRoot = JsonArrayInsert(jRoot, jLevel9);

    jRoot = NuiCol(jRoot);
    json nui = NuiWindow(jRoot, JsonString("Choose two spells"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPlayer, nui, NUI_SAM_ALL_SPELLS);

    NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
    NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));
}