#include "sm_consts"
#include "nw_inc_nui"

const string NUI_ARCANE_SPELL_SYNTH = "NUI_ARCANE_SPELL_SYNTH";
const string NUI_DIVINE_SPELL_SYNTH = "NUI_DIVINE_SPELL_SYNTH";
int ARCANE = 1;
int DIVINE = 2;

string GetDivineSpellcasterClass(object oPC)
{
    int i;
    // Should Probably get highest level of these classes
    for (i = 1; i < CLASS_MAX; i += 1)
    {
        int nClass = GetClassByPosition(i, oPC);
        switch (nClass)
        {
            case CLASS_TYPE_CLERIC:
                return CLASS_TYPE_CLERIC;
            case CLASS_TYPE_DRUID:
                return CLASS_TYPE_DRUID;
            case CLASS_TYPE_PALADIN:
                return CLASS_TYPE_PALADIN;
            case CLASS_TYPE_RANGER:
                return CLASS_TYPE_RANGER;
            case CLASS_TYPE_INVALID:
                return CLASS_TYPE_INVALID;
        }
    }
    return CLASS_TYPE_INVALID;
}

int GetArcaneSpellcasterClass(object oPC)
{
    int i;
    // Should Probably get highest level of these classes
    for (i = 1; i < CLASS_MAX; i += 1)
    {
        int nClass = GetClassByPosition(i, oPC);
        switch (nClass)
        {
            case CLASS_TYPE_SORCERER:
                return CLASS_TYPE_SORCERER;
            case CLASS_TYPE_WIZARD:
                return CLASS_TYPE_WIZARD;
            case CLASS_TYPE_BARD:
                return CLASS_TYPE_BARD;
            case CLASS_TYPE_INVALID:
                return CLASS_TYPE_INVALID;
        }
    }
    return CLASS_TYPE_INVALID;
}

json SMGetMemorizedSpells(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    int nLevelIterate = 0;
    json jRoot = JsonArray();
	json jAddedSpells = JsonArray();
    for (nLevelIterate; nLevelIterate <= nLevel; nLevelIterate += 1)
    {
        int nSpellIndex = 0;
        json jRow = JsonArray();
        for (nSpellIndex; nSpellIndex < GetMemorizedSpellCountByLevel(oPC, nClass, nLevelIterate); nSpellIndex += 1)
        {
            int nSpellPosition = GetMemorizedSpellId(oPC, nClass, nLevelIterate, nSpellIndex);
			json jFound = JsonFind(jAddedSpells, JsonInt(nSpellPosition));
			SpeakString(JsonDump(jFound));
			if (nSpellPosition == -1 || JsonDump(jFound) != "null")
			{
				continue;
			}
            string name = Get2DAString("spells", "Name", nSpellPosition);
            string iconResRef = Get2DAString("spells", "IconResRef", nSpellPosition);
			
			SpeakString(GetStringByStrRef(StringToInt(name)));
            json jButton = NuiButtonImage(JsonString(iconResRef));
            jButton = NuiTooltip(jButton, JsonString(GetStringByStrRef(StringToInt(name))));
            jButton = NuiId(jButton, "spell_"+(IntToString(nSpellPosition+1)));
            jButton = NuiStyleForegroundColor(jButton, NuiBind("spell_"+IntToString(nSpellPosition+1)));
            jButton = NuiWidth(jButton, 48.0);
            jButton = NuiHeight(jButton, 48.0);

            jRow = JsonArrayInsert(jRow, jButton);
			jAddedSpells = JsonArrayInsert(jAddedSpells, JsonInt(nSpellPosition));
        }
        jRoot = JsonArrayInsert(jRoot, NuiRow(jRow));
    }
    return NuiCol(jRoot);
}

/*
    Used for Bard/Sorc
*/
json SMGetLearnedSpells(object oPC, int nClass)
{

}

// Possible Classes that it will go through
// Bard - Cleric - Druid - Paladin - Range - Wiz_Sorc
void SMChooseSpellSynthMenu(int nArcaneDivine, object oPC)
{
    string sToken;
    int nClassName;  //This will be the class to search through the 2da spells
    if (nArcaneDivine == ARCANE)
    {
        sToken = NUI_ARCANE_SPELL_SYNTH;
        nClassName = GetArcaneSpellcasterClass(oPC);
    }
    else 
    {
        sToken = NUI_DIVINE_SPELL_SYNTH;
        nClassName = GetDivineSpellcasterClass(oPC);
    }
    int nPreviousToken = NuiFindWindow(oPC, sToken);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPC, nPreviousToken);
    }
    /*
    In the json of an object
    ClassList - value 
    Several indexes here
    Class - value has the class id
    MemorizedList0-9 Has the various spells known For Clerics and Wizard

    To get them 
    Iterate through the levels, and use these
    Wiz/Cleric/Ranger/Druid/Paladin
    GetMemorizedSpellId()
    GetMemorizedSpellCountByLevel()
    For Bard/Sorcerer
    GetHasSpell
    */

    json jRoot = JsonArray();

    switch (nClassName)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        {
            jRoot = JsonArrayInsert(jRoot, SMGetLearnedSpells(oPC, nClassName));
        }
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_PALADIN:
        {
            jRoot = JsonArrayInsert(jRoot, SMGetMemorizedSpells(oPC, nClassName));
        }
    }

    json jAccept = NuiButton(JsonString("Quit"));
    string currentSpell = "CURRENTLYCHOSEN";
    json jSpellChosen = JsonArray();
	jSpellChosen = JsonArrayInsert(jSpellChosen, NuiLabel(NuiBind(currentSpell), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_TOP)));
    jSpellChosen = JsonArrayInsert(jSpellChosen, NuiId(NuiButton(JsonString("Switch")), "nui_sm_switch_arcanedivine"));
	jRoot = JsonArrayInsert(jRoot, NuiRow(jSpellChosen));

    jRoot = JsonArrayInsert(jRoot, NuiRow(jAccept));
    jRoot = NuiCol(jRoot);
    json nui = NuiWindow(jRoot, JsonString("Spell Synthesis Spell Choice"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPC, nui, sToken);
    
    NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, -1.0f, 480.0f, 240.0f));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    int nSpellLength = Get2DARowCount("spells");
    for (iterate = 0; iterate < nSpellLength; iterate += 1)
    {
        NuiSetBind(oPC, nToken, "spell_"+IntToString(iterate), NuiColor(100, 100, 100, 255));
    }
    
    NuiSetBind(oPC, nToken, "spell_ACCEPT", NuiColor(100,100,100));
    int nCurrentArcane = GetLocalInt(oPC, SM_SPELLSYNTHESIS_ARCANE);
    int nCurrentDivine = GetLocalInt(oPC, SM_SPELLSYNTHESIS_DIVINE);
    NuiSetBind(oPC, nToken, "spell_"+IntToString(nCurrentArcane), NuiColor(255, 0, 0, 255));
    NuiSetBind(oPC, nToken, "spell_"+IntToString(nCurrentDivine), NuiColor(255, 0, 0, 255));
    if (nArcaneDivine == ARCANE && nCurrentArcane > 0)
    {
        int nCurrentName = Get2DAString("spells", "Name", nCurrentArcane - 1);
        json jCurrentSpell = JsonString(GetStringByStrRef(StringToInt(nCurrentName)));
        NuiSetBind(oPC, nToken, currentSpell, jCurrentSpell);
    }
    else if (nCurrentDivine > 0)
    {
        int nCurrentName = Get2DAString("spells", "Name", nCurrentDivine - 1);
        json jCurrentSpell = JsonString(GetStringByStrRef(StringToInt(nCurrentName)));
        NuiSetBind(oPC, nToken, currentSpell, jCurrentSpell);
    }
    else 
    {
        NuiSetBind(oPC, nToken, currentSpell, JsonString("Not yet Selected"));
    }
}