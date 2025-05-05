/*
For a sample of how it would work without NWNX
*/
#include "nwnx_creature"
void SMSQLCreateSpellTable(object oPC)
{
    sqlquery s = SqlPrepareQueryObject(oPC, "CREATE TABLE IF NOT EXISTS spellslearned (spellid INT NOT NULL, spelllvl INT NOT NULL, uuid INT NOT NULL, classid INT NOT NULL, PRIMARY KEY (spellid, uuid));");
    SqlStep(s);
}

/***
* Adds the spell to the creatures SQL as well as adds the known spell
*/
void SMSQLLearnSpell(object oTarget, int nClass, int nSpellLvl, int nSpellID)
{
    //Add check here to make sure that target doesn't have spell in class already
    
    object oPC = oTarget;
    SMSQLCreateSpellTable(oPC); //Creates table just in case it doesn't exist and throw error
    string oPCUUID = GetObjectUUID(oPC);
    sqlquery s = SqlPrepareQueryObject(oPC, "insert into spellslearned (spellid, spelllvl, uuid, classid) values (@spellid, @spelllvl, @uuid, @classid);");
    SqlBindString(s, "@uuid", oPCUUID);
    SqlBindInt(s, "@classid", nClass);
    SqlBindInt(s, "@spellid", nSpellID+1);  //Saving at +1 for tracking 0
    SqlBindInt(s, "@spelllvl", nSpellLvl);
    SqlStep(s);
    NWNX_Creature_AddKnownSpell(oPC, nClass, nSpellLvl, nSpellID);
}

void SMSQLRelearnSpells(object oTarget)
{
    object oPC = oTarget;
    
    SMSQLCreateSpellTable(oPC); //Creates table just in case
    //uuid may not be useful here at all if it's stored on the player...
    sqlquery s = SqlPrepareQueryObject(oPC, "select spellid, spelllvl, uuid, classid from spellslearned;");
    while (SqlStep(s))
    {
        /*
        SpeakString("spellid: " + IntToString(SqlGetInt(s, 0)));
        SpeakString("spelllvl: " + IntToString(SqlGetInt(s, 1)));
        SpeakString("uuid: " + SqlGetString(s, 2));
        SpeakString("classid: " + IntToString(SqlGetInt(s, 3)));
        */
        NWNX_Creature_AddKnownSpell(oPC, SqlGetInt(s, 3), SqlGetInt(s, 1), SqlGetInt(s, 0)-1);
        //Need to adjust spellid be 1 to account for spellid == 0 
    }
}
//Looks like This will be a better way
//May need to keep track of the hotbar as well...

void testlearnspell(object oPC)
{
    SMSQLLearnSpell(oPC, CLASS_TYPE_WIZARD, 9, 185);
}