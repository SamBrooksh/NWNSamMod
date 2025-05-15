#include "sm_learnspellsql"

void main()
{
    object oPC = OBJECT_SELF;

    SMSQLRelearnSpells(oPC);
    SMTriggerLearnSpells(oPC);
}
/*

    I think instead of doing it on connect - it's be on client load?
    Ok it looks like maybe NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE
    Especially I'll probably have to try and validate some as well? Or just skip all validation and add them?
    I may be able to use it without actually importing the validation

    - NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE
    - NWNX_ON_ELC_VALIDATE_CHARACTER_AFTER

    `OBJECT_SELF` = The player

    Note: NWNX_ELC must be loaded for these events to work. The `_AFTER` event only fires if the character successfully
          completes validation.
    I need to test if this part is even needed of course
    */