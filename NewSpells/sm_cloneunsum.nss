#include "nwnx_events"
#include "sm_consts"
void main()
{
    //string sEvent = NWNX_Events_GetCurrentEvent();
    object oCreature = StringToObject(NWNX_Events_GetEventData("ASSOCIATE_OBJECT_ID"));
    object oMaster = GetMaster(oCreature);
    //Check if Clone - then do this
    if (GetTag(oCreature) == VOID_CLONE_TAG || GetTag(oCreature) == VOID_CLONE_TAG_2)
    {
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