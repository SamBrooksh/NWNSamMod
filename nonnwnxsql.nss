/*
For a sample of how it would work without NWNX

*/

void create()
{
    object oPC = OBJECT_SELF;
    sqlquery s = SqlPrepareQueryObject(oPC, "CREATE TABLE spellslearned (spellid INT NOT NULL, spelllvl INT NOT NULL, uuid INT NOT NULL, classid INT NOT NULL, PRIMARY KEY (spellid, uuid));");
    SqlStep(s);
}

void insert()
{
    object oPC = OBJECT_SELF;
    int nClass = 0;
    string oPCUUID = GetObjectUUID(oPC);
    int nSpellLevel1 = 0;
    int nSpell1 = 0;
    sqlquery s = SqlPrepareQueryObject(oPC, "insert into spellslearned (spellid, spelllvl, uuid, classid) values (@spellid, @spelllvl, @uuid, @classid);");
    SqlBindString(s, "@uuid", oPCUUID);
    SqlBindInt(s, "@classid", nClass);
    SqlBindInt(s, "@spellid", nSpell1-1);
    SqlBindInt(s, "@spelllvl", nSpellLevel1);
    SqlStep(s);
}

void retrieve()
{
    object oPC = OBJECT_SELF;
    sqlquery s = SqlPrepareQueryObject(oPC, "select spellid, spelllvl, uuid, classid from spellslearned;")
    while (SqlStep(s))
    {
        SpeakString("spellid: " + IntToString(SqlGetInt(s, 0)));
        SpeakString("spelllvl: " + IntToString(SqlGetInt(s, 1)));
        SpeakString("uuid: " + SqlGetString(s, 2));
        SpeakString("classid: " + IntToString(SqlGetInt(s, 3)));
    }
}
//Looks like This will be a better way