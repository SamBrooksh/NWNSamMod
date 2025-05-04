#include "nwnx_events"

void main()
{
    object oPlayer = OBJECT_SELF;
    //Happens if player cancels out character sheet
    if (oPlayer == OBJECT_INVALID)
        return;
    string name = NWNX_Event_GetEventData("PLAYER_NAME");
    string cdkey = NWNX_EventGetEventData("CDKEY");
    //I need to figure out what else I need to do here...
    ExportSingleCharacter(oPlayer);

    
}