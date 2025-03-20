#include "nwnx_events"
//Trigger when killed or unsummoned
#include "sm_consts"
void main()
{
    //string sEvent = NWNX_Events_GetCurrentEvent();
    object oCreature = StringToObject(NWNX_Events_GetEventData("ASSOCIATE_OBJECT_ID"));
    //Check if Clone - then do this
    if (GetTag(oCreature) == VOID_CLONE_TAG || GetTag(oCreature) == VOID_CLONE_TAG_2)
    {
        object oMaster = GetMaster(oCreature);
        //Probably Want to add test if master has another clone
        effect eEffect = GetFirstEffect(oMaster);
        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectTag(eEffect) == CONST_VOID_SUMMON_DEBUFF)
            {
                RemoveEffect(oMaster, eEffect);
                return;
            }
            eEffect = GetNextEffect(oMaster);
        }
    }
    
}