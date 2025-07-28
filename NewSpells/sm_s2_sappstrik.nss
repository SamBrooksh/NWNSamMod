#include "sm_spellfunc"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetCampaignInt(SM_DB_NAME, CONST_USES_SAPPING_STRIKE, oPC) > 0)
    {
        if (GetLocalInt(oPC, CONST_SAP_STRIKE_NEXT_ATTACK) > 0)
        {
            SpeakString("Not Applying Sapping Strike", TALKVOLUME_WHISPER);
            DeleteLocalInt(oPC, CONST_SAP_STRIKE_NEXT_ATTACK);
        }
        else 
        {
            RemoveVoidOnAttacks(oPC);
            SpeakString("Applying Sapping Strike on Next Attack", TALKVOLUME_WHISPER);
            SetLocalInt(oPC, CONST_SAP_STRIKE_NEXT_ATTACK, TRUE);
        }
    }
    else 
    {
        SpeakString("No more uses of Sapping Strike Left!", TALKVOLUME_WHISPER);
    }
}