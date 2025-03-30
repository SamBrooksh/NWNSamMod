#include "nwnx_events"
#include "sqllite"

void main()
{
    object oPlayer = OBJECT_SELF;
    //Happens if player cancels out character sheet
    if (oPlayer == OBJECT_INVALID)
        return;
    string name = NWNX_Event_GetEventData("PLAYER_NAME");
    string cdkey = NWNX_EventGetEventData("CDKEY");
    //Need to decide
    ExportSingleCharacter(oPlayer);

    
}

/*
string sVarName;
string sSQL = "SELECT val FROM module WHERE name = ?";
if (NWNX_SQL_PrepareQuery(sSQL)) {
    NWNX_SQL_PreparedString(0, sVarName);
    if (NWNX_SQL_ExecutePreparedQuery()) {
        if (NWNX_SQL_ReadyToReadNextRow()) {
            NWNX_SQL_ReadNextRow();
            return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        }
    }
}
return 0;
the ? states where something will be filled in
So if I am saving spells, character-uuid, spell level, class id it would be
First time
string sSql = "INSERT spellid, spelllvl, character, classid INTO TABLE VALUES (?, ?, ?, ?);""
if (NWNX_SQL_PrepareQuery(sSql))
{
    NWNX_SQL_PreparedInt(0, );
    NWNX_SQL_PreparedInt(1, );
    NWNX_SQL_PreparedInt(3, );
    NWNX_SQL_Prepared


SELECT spellid, spelllvl, character, classid FROM TABLE WHERE 
spellid=? AND character=? AND spelllvl=? AND classid=?;
}

*/