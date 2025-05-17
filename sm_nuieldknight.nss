#include "nw_inc_nui"
#include "sm_consts"

void SMEldritchKnightSpellCritical(object oPlayer)
//Add button for Arcane/Divine Spells?
{
    int nPreviousToken = NuiFindWindow(oPlayer, NUI_SM_ELDRITCH_SPELL_CRIT);
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
    string label = Get2DAString("spells", "Label", pos);

    int chosen1 = GetLocalInt(oPlayer, SM_SPELL_CRITICAL_CONST);
    int chosen2 = GetLocalInt(oPlayer, SM_SPELL_CRITICAL2_CONST);
    int chosen3 = GetLocalInt(oPlayer, SM_SPELL_CRITICAL3_CONST);

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
            jButton = NuiId(jButton, IntToString(pos + 1));
            jButton = NuiStyleForegroundColor(jButton, NuiBind(IntToString(pos+1)));

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

    json information = NuiText(JsonString("Choose 3 spells to have!\nGreen is 1st priority\nBlue is 2nd Priority\nRed is 3rd Priority"), FALSE, NUI_SCROLLBARS_NONE);
    information = NuiHeight(information, 80.0);    
    information = NuiWidth(information, 200.0);
    information = JsonArrayInsert(JsonArray(), information);
    information = NuiRow(information);

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

    jRoot = JsonArrayInsert(jRoot, information);

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
    json nui = NuiWindow(jRoot, JsonString("Nui All Spells"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPlayer, nui, NUI_SM_ELDRITCH_SPELL_CRIT);

    NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
    NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));

    int iterate = 0;
    for (iterate = 0; iterate < pos; iterate += 1)
    {
        if (chosen1 == iterate + 1)
        {
           NuiSetBind(oPlayer, nToken, IntToString(iterate), NuiColor(0,255,0));
        }
        else if (chosen2 == iterate + 1)
        {
           NuiSetBind(oPlayer, nToken, IntToString(iterate), NuiColor(0,0,255));
        }
        else if (chosen3 == iterate + 1)
        {
            NuiSetBind(oPlayer, nToken, IntToString(iterate), NuiColor(255,0,0));
        }
        else
        {
            NuiSetBind(oPlayer, nToken, IntToString(iterate), NuiColor(100,100,100));
        }
    }
}