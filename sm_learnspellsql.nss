/*
For a sample of how it would work without NWNX
*/
#include "nwnx_creature"
#include "sm_consts"

void SMSQLCreateSpellTable(object oPC)
{
    sqlquery s = SqlPrepareQueryObject(oPC, "CREATE TABLE IF NOT EXISTS spellslearned (spellid INT NOT NULL, spelllvl INT NOT NULL, uuid STRING NOT NULL, classid INT NOT NULL, PRIMARY KEY (spellid, uuid));");
    SqlStep(s);
}

/*
This should get if a creature has a spell learned (To prevent duplicates)
Just being used for WIZARD/SORC/BARD currently
Could probably make it a bit more efficient by using the class id to switch instead...
*/
int SMGetHasSpellLearned(object oPC, int nSpellIdToFind, int nClass)
{
    int nSpellId, nIndex, nCount, nSpellLevel;
    
    switch (nClass) 
    {
        case CLASS_TYPE_WIZARD:
            for (nSpellLevel = 9; nSpellLevel > 0; nSpellLevel--) {
                nCount = GetKnownSpellCount(oPC, CLASS_TYPE_WIZARD, nSpellLevel);
                //This finds it if learned for Wizards
                for (nIndex = 0; nIndex <= nCount; nIndex++) {
                    nSpellId = GetKnownSpellId(oPC, CLASS_TYPE_WIZARD, nSpellLevel, nIndex);
                    if(nSpellId > -1) {
                        if (nSpellId == nSpellIdToFind)
                            return TRUE;
                    }
                }
            }
            return FALSE;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD: 
            return GetHasSpell(nSpellIdToFind, oPC) > 0;
    }
    //Should probably specify that a different class was found
    return FALSE;
}

/***
* Adds the spell to the creatures SQL as well as adds the known spell

Need to change the table to be a module one that is saved - currently loses all information when server shuts down
I think... Maybe not actually
*/
void SMSQLLearnSpell(object oTarget, int nClass, int nSpellLvl, int nSpellID)
{
    //Add check here to make sure that target doesn't have spell in class already
    object oPC = oTarget;
    SMSQLCreateSpellTable(oPC); //Creates table just in case it doesn't exist and throw error
    string oPCUUID = GetObjectUUID(oPC);
    sqlquery s = SqlPrepareQueryObject(oPC, "insert into spellslearned (spellid, spelllvl, uuid, classid) values (@spellid, @spelllvl, @uuid, @classid);");
    /*
    SqlBindString(s, "@uuid", oPCUUID);
    SqlBindInt(s, "@classid", nClass);
    SqlBindInt(s, "@spellid", nSpellID+1);  //Saving at +1 for tracking 0
    SqlBindInt(s, "@spelllvl", nSpellLvl);
    */
    SqlStep(s);
    NWNX_Creature_AddKnownSpell(oPC, nClass, nSpellLvl, nSpellID);
}

/*
Looks like wizards learn it properly from so relearning 
should only apply those that needed to 

*/
void SMSQLRelearnSpells(object oTarget)
{
    object oPC = oTarget;
    PrintString("Relearning Spells");
    PrintObject(oPC);
    SMSQLCreateSpellTable(oPC); //Creates table just in case
    //uuid may not be useful here at all if it's stored on the player...
    sqlquery s = SqlPrepareQueryObject(oPC, "select spellid, spelllvl, uuid, classid from spellslearned;");
    while (SqlStep(s))
    {
        int nSpellId = SqlGetInt(s, 0)-1;
        PrintString("Spell Found");
        /*
        SpeakString("spellid: " + IntToString(nSpellId));
        SpeakString("spelllvl: " + IntToString(SqlGetInt(s, 1)));
        SpeakString("uuid: " + SqlGetString(s, 2));
        SpeakString("classid: " + IntToString(SqlGetInt(s, 3)));
        */
        if (!SMGetHasSpellLearned(oPC, nSpellId, SqlGetInt(s, 3)))
            NWNX_Creature_AddKnownSpell(oPC, SqlGetInt(s, 3), SqlGetInt(s, 1), nSpellId);
        else
            SpeakString("Found Spell already");
        //Need to adjust spellid be 1 to account for spellid == 0 
    }
}
//Looks like This will be a better way
//May need to keep track of the hotbar as well...


/* 
Check if object needs to learn more spells
*/
void SMTriggerLearnSpells(object oTarget)
{
    //Will eventually have it something like this I believe
    if (GetLocalInt(oTarget, SM_LEARN_ARCANE_COUNT) > 0)
        ExecuteScript("sm_arcspelllearn", oTarget);
}

void testlearnspell(object oPC)
{
    SMSQLLearnSpell(oPC, GetClassByPosition(1, oPC), 1, 0);
    //Acid Fog works!
}