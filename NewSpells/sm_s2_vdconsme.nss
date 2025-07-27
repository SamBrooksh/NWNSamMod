#include "sm_consts"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetCampaignInt(SM_DB_NAME, CONST_USES_VOID_CONSUMED, oPC) > 0)
    {
        if (GetLocalInt(oPC, CONST_VOID_CONSUME_NEXT_ATTACK) > 0)
        {
            SpeakString("Not Applying Void Consume", TALKVOLUME_WHISPER);
            DeleteLocalInt(oPC, CONST_VOID_CONSUME_NEXT_ATTACK);
        }
        else 
        {
            SpeakString("Applying Void Consume on Next Attack", TALKVOLUME_WHISPER);
            SetLocalInt(oPC, CONST_VOID_CONSUME_NEXT_ATTACK, TRUE);
        }
    }
    else 
    {
        SpeakString("No more uses of Void Consume Left!", TALKVOLUME_WHISPER);
    }
}