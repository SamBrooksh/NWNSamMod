#include "sm_consts"
#include "nw_inc_nui"

int GetDivineSpellcasterClass(object oPC)
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
            //SpeakString(JsonDump(jFound));
            if (nSpellPosition == -1 || JsonDump(jFound) != "null")
            {
                continue;
            }
            string name = Get2DAString("spells", "Name", nSpellPosition);
            string iconResRef = Get2DAString("spells", "IconResRef", nSpellPosition);

            //SpeakString(GetStringByStrRef(StringToInt(name)));
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
    Goes through the Character Json to get the info
*/
json SMGetLearnedSpells(object oPC, int nClass)
{
	json jRoot = JsonArray();
    json jPlayer = ObjectToJson(oPC);
    //Need to find the right class
    int nClassPosition = 1;
    json jClass = JsonObjectGet(jPlayer, "ClassList");
    json jClassArray = JsonObjectGet(jClass, "value");
	int nLength = JsonGetLength(jClassArray);
	int nIterate = 0;
	for (nIterate; nIterate < nLength; nIterate += 1)
	{
		json jIndividualClass = JsonArrayGet(jClassArray, nIterate);
		json jClassValue = JsonObjectGet(JsonObjectGet(jIndividualClass, "Class"), "value");
		if (nClass != JsonGetInt(jClassValue))
		{
			continue;
		}
		json jSpellsPerDayList = JsonObjectGet(JsonObjectGet(jIndividualClass, "SpellsPerDayList"), "value");
		int nKnownList = 0;
		for (nKnownList; nKnownList < 10; nKnownList += 1)
		{
			json jSpellUsesLeft = JsonObjectGet(JsonObjectGet(JsonArrayGet(jSpellsPerDayList, nKnownList), "NumSpellsLeft"), "value");
			int nSpellUsesLeft = JsonGetInt(jSpellUsesLeft);
			//SpeakString(JsonDump(jSpellUsesLeft));
			if (nSpellUsesLeft < 1)
			{
				//SpeakString("Skipping Level");
				continue;
			}
			json jRow = JsonArray();
			json jKnownList = JsonObjectGet(JsonObjectGet(jIndividualClass, "KnownList"+IntToString(nKnownList)), "value");
			
			int nKnownListLength = JsonGetLength(jKnownList);
			int nSpellIterate = 0;
			for (nSpellIterate; nSpellIterate < nKnownListLength; nSpellIterate += 1)
			{
				//Only add it if the same position in the SpellsPerDayList is over 0
				
				int nSpellPosition = JsonGetInt(JsonObjectGet(JsonObjectGet(JsonArrayGet(jKnownList, nSpellIterate), "Spell"), "value"));
				string name = Get2DAString("spells", "Name", nSpellPosition);
				string iconResRef = Get2DAString("spells", "IconResRef", nSpellPosition);
				json jButton = NuiButtonImage(JsonString(iconResRef));
				jButton = NuiTooltip(jButton, JsonString(GetStringByStrRef(StringToInt(name))));
				jButton = NuiId(jButton, "spell_"+(IntToString(nSpellPosition+1)));
				jButton = NuiStyleForegroundColor(jButton, NuiBind("spell_"+IntToString(nSpellPosition+1)));
				jButton = NuiWidth(jButton, 48.0);
				jButton = NuiHeight(jButton, 48.0);
				jRow = JsonArrayInsert(jRow, jButton);
			}
			jRoot = JsonArrayInsert(jRoot, NuiRow(jRow));
		}
	}
    return NuiCol(jRoot);
}

// Possible Classes that it will go through
// Bard - Cleric - Druid - Paladin - Range - Wiz_Sorc
void SMChooseSpellSynthMenu(int nArcaneDivine, object oPC)
{
    string sToken;
    int nClassName;  //This will be the class to search through the 2da spells
    if (nArcaneDivine == ARCANE_CLASS)
    {
        nClassName = GetArcaneSpellcasterClass(oPC);
        sToken = NUI_ARCANE_SPELL_SYNTH;
    }
    else
    {
        nClassName = GetDivineSpellcasterClass(oPC);
        sToken = NUI_DIVINE_SPELL_SYNTH;
    }

    int nPreviousToken = NuiFindWindow(oPC, NUI_ARCANE_SPELL_SYNTH);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPC, nPreviousToken);
    }

    nPreviousToken = NuiFindWindow(oPC, NUI_DIVINE_SPELL_SYNTH);
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

    json jAccept = NuiId(NuiButton(JsonString("Close")), "Quit");
    string currentSpell = "CURRENTLYCHOSEN";
    json jSpellChosen = JsonArray();
    jSpellChosen = JsonArrayInsert(jSpellChosen, NuiWidth(NuiLabel(NuiBind(currentSpell), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_TOP)), 300.0));
    json jSwitchButton = NuiId(NuiButton(JsonString("Switch")), "nui_sm_switch_splsyn");


    jSpellChosen = JsonArrayInsert(jSpellChosen, jSwitchButton);
    jSpellChosen = JsonArrayInsert(jSpellChosen, jAccept);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jSpellChosen));

    //jRoot = JsonArrayInsert(jRoot, NuiRow(jAccept));
    jRoot = NuiCol(jRoot);
    json nui = NuiWindow(jRoot, JsonString("Spell Synthesis Spell Choice"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));
    int nToken = NuiCreate(oPC, nui, sToken);

    NuiSetBind(oPC, nToken, "geometry", NuiRect(10.0f, 10.0f, 960.0f, 480.0f));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    int nSpellLength = Get2DARowCount("spells");
    int iterate;
    for (iterate = 0; iterate < nSpellLength; iterate += 1)
    {
        NuiSetBind(oPC, nToken, "spell_"+IntToString(iterate), NuiColor(100, 100, 100, 255));
    }

    NuiSetBind(oPC, nToken, "spell_ACCEPT", NuiColor(100,100,100));
    int nCurrentArcane = GetLocalInt(oPC, SM_SPELLSYNTHESIS_ARCANE);
    int nCurrentDivine = GetLocalInt(oPC, SM_SPELLSYNTHESIS_DIVINE);
    //SpeakString("Arcane Value upon making: " +IntToString(nCurrentArcane));
    //SpeakString("Divine Value upon making: " +IntToString(nCurrentDivine));
    NuiSetBind(oPC, nToken, "spell_"+IntToString(nCurrentArcane), NuiColor(255, 0, 0, 255));
    NuiSetBind(oPC, nToken, "spell_"+IntToString(nCurrentDivine), NuiColor(255, 0, 0, 255));
    if (nArcaneDivine == ARCANE_CLASS && nCurrentArcane > 0)
    {
        string nCurrentName = Get2DAString("spells", "Name", nCurrentArcane - 1);
        json jCurrentSpell = JsonString(GetStringByStrRef(StringToInt(nCurrentName)));
        NuiSetBind(oPC, nToken, currentSpell, jCurrentSpell);
    }
    else if (nArcaneDivine == DIVINE_CLASS && nCurrentDivine > 0)
    {
        string nCurrentName = Get2DAString("spells", "Name", nCurrentDivine - 1);
        json jCurrentSpell = JsonString(GetStringByStrRef(StringToInt(nCurrentName)));
        NuiSetBind(oPC, nToken, currentSpell, jCurrentSpell);
    }
    else
    {
        NuiSetBind(oPC, nToken, currentSpell, JsonString("Not yet Selected"));
    }
}