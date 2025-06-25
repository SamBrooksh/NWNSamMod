#include "nwnx_events"
#include "nwnx_creature"
#include "sm_nuiarcsetup"

void main()
{
    string sEvent = NWNX_Events_GetCurrentEvent();
    object oCreature = OBJECT_SELF;
    int nCurrLevel = SMGetLevel(oCreature);
    // May actually be able to do OBJECT_SELF somehow
    if (sEvent == NWNX_ON_LEVEL_UP_AFTER)
    {
        int nLastLevel = NWNX_Creature_GetClassByLevel(oCreature, nCurrLevel - 1);
        if (SMPrestigeArcaneSpellIncrease(nLastLevel))
        {
            NUILearnNewArcaneSpells(oCreature, 2);
        }
    }
}