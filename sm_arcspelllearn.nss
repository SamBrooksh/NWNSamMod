#include "sm_spellfunc"
#include "nwnx_creature"
#include "nw_inc_nui"

int GetLevel(object oCaster)
{
    int i =1;
    int total = 0;
    for (i; i < CLASS_MAX; i += 1)
    {
        int toAdd = GetLevelByPosition(i, oCaster);
        if (toAdd == 0)
            return total; 
        total += toAdd;
    }
    return total;
}

int PrestigeArcaneClass(int nClass)
{
    //Should auto update as well
    int val = StringToInt(Get2DAString("classes", "ArcSpellLvlMod", nClass));
    if (val != 0)
        return TRUE;
    return FALSE;
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
    string desc = Get2DAString("spells", "SpellDesc", pos);
    int nArcaneCasterLevel = (SMGetCasterLevel(oPlayer, ARCANE_CLASS) + 1) / 2;
    int bard = GetLevelByClass(CLASS_TYPE_BARD, oPlayer);
    int wizSorc = GetLevelByClass(CLASS_TYPE_WIZARD, oPlayer);
    int count = Get2DARowCount("spells");
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
    while (pos < count)
    {
        json jButton = NuiButton(JsonString(GetStringByStrRef(StringToInt(name))));
        jButton = NuiTooltip(jButton, JsonString(GetStringByStrRef(StringToInt(desc))));
        jButton = NuiId(jButton, "spell_"+IntToString(pos + 1));
        jButton = NuiStyleForegroundColor(jButton, NuiBind("spell_"+IntToString(pos+1)));

        if (StringToInt(spellLevel) <= nArcaneCasterLevel && !GetIsInKnownSpellList(oPlayer, classType, pos))
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
        desc = Get2DAString("spells", "SpellDesc", pos);

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

    json jAccept = NuiButton(JsonString("Accept"));
    jAccept = NuiId(jAccept, "spell_ACCEPT");
    jAccept = JsonArrayInsert(JsonArray(), jAccept);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jAccept));

    jRoot = NuiCol(jRoot);
    json nui = NuiWindow(jRoot, JsonString("Choose two spells"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPlayer, nui, NUI_SM_LEARN_ARCANE_SPELLS);

    NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
    NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));

    int iterate = 0;
    for (iterate = 0; iterate < pos; iterate += 1)
    {
        NuiSetBind(oPlayer, nToken, "spell_"+IntToString(iterate), NuiColor(100,100,100));
    }
    NuiSetBind(oPlayer, nToken, "spell_ACCEPT", NuiColor(100,100,100));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nClass = NWNX_Creature_GetClassByLevel(oCaster, GetLevel(oCaster));
    if (PrestigeArcaneClass(nClass))
    {
        LearnNewArcaneSpells(oCaster);
    }
}