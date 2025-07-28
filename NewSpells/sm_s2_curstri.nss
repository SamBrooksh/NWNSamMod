#include "sm_spellfunc"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetCampaignInt(SM_DB_NAME, CONST_USES_CURSED_STRIKE, oPC) > 0)
    {
        if (GetLocalInt(oPC, CONST_CURSED_STRIKE_NEXT_ATTACK) > 0)
        {
            SpeakString("Not Applying Cursed Strikes", TALKVOLUME_WHISPER);
            DeleteLocalInt(oPC, CONST_CURSED_STRIKE_NEXT_ATTACK);
        }
        else 
        {
            RemoveVoidOnAttacks(oPC);
            SpeakString("Applying Cursed Strikes on Next Attack", TALKVOLUME_WHISPER);
            SetLocalInt(oPC, CONST_CURSED_STRIKE_NEXT_ATTACK, TRUE);
        }
    }
    else 
    {
        SpeakString("No more uses of Cursed Strikes Left!", TALKVOLUME_WHISPER);
    }
}