#include "nwnx_events"
//#include "nwnx_creature"
#include "sm_consts"

void main()
{
    // Looks like there may not be a on rest event in nwnx_events but I should be able to signal it
    // Will have to set that up in the rest script regardless
    object oPC = OBJECT_SELF;
    //int nID = StringToInt(NWNX_Events_GetEventData("EVENT_ID"));
    //if (nID == NWNX_EVENTS_TIMING_BAR_REST)
    PrintString("In Void Rest");
    int nTalentAmount = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    // Originally Had +1 but the player will one use by default anyway
    int nMissileCount = nTalentAmount;
    int nSappingStrikeCount = nTalentAmount;
    int nVoidRipCount = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC) / 2;
    if (GetHasFeat(FEAT_VOID_TALENTS, oPC))
    {
        nTalentAmount += 3;
    }
    if (GetHasFeat(FEAT_VOID_EXTRA_MISSILE, oPC))
    {
        nMissileCount += 3;
    }

    // Set Local ints for each if they have it
    // Probably could just assign all of these
    if (GetHasFeat(FEAT_VOID_MISSILE, oPC))
    {
        //Need to make uses here
        SetLocalInt(oPC, CONST_USES_VMISSILE, nMissileCount);
    }

    if (GetHasFeat(FEAT_VOID_HIDDEN, oPC))
    {
        SetLocalInt(oPC, CONST_USES_VOID_HIDDEN, nTalentAmount + 1);
        // Void Hidden is 2+Int not 1+Int so needs the +1 here
    }

    if (GetHasFeat(FEAT_VOID_HASTE, oPC))
    {
        SetLocalInt(oPC, CONST_USES_VOID_HASTE, nTalentAmount);
    }

    if (GetHasFeat(FEAT_VOID_SHADOWED, oPC))
    {
        SetLocalInt(oPC, CONST_USES_VOID_SHADOW, nTalentAmount);
    }

    if (GetHasFeat(FEAT_VOID_CONSUMED_BY_VOID, oPC))
    {
        SetLocalInt(oPC, CONST_USES_VOID_CONSUMED, nTalentAmount);
    }

    if (GetHasFeat(FEAT_VOID_RIP, oPC))
    {
        SetLocalInt(oPC, CONST_USES_VOID_RIP, nVoidRipCount);
    }

    if (GetHasFeat(FEAT_SAPPING_STRIKE, oPC))
    {
        SetLocalInt(oPC, CONST_USES_SAPPING_STRIKE, nSappingStrikeCount);
    }

}