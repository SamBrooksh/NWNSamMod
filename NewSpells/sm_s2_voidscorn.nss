#include "sm_consts"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetCampaignInt(SM_DB_NAME, CONST_USES_VOID_SCORN, oPC) > 0)
    {
        if (GetLocalInt(oPC, CONST_VOID_SCORN_NEXT_ATTACK) > 0)
        {
            SpeakString("Not Applying Void Scorn", TALKVOLUME_WHISPER);
            DeleteLocalInt(oPC, CONST_VOID_SCORN_NEXT_ATTACK);
        }
        else 
        {
            SpeakString("Applying Void Scorn on Next Attack", TALKVOLUME_WHISPER);
            SetLocalInt(oPC, CONST_VOID_SCORN_NEXT_ATTACK, TRUE);
        }
    }
    else 
    {
        SpeakString("No more uses of Void Scorn Left!", TALKVOLUME_WHISPER);
    }
}