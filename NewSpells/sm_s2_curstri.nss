#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nDC = 10 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster) + GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    if(!GetIsReactionTypeFriendly(oTarget))
	{
        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster, 0.0))
        {
            SMApplyCursedStrikes(oTarget, oCaster);
        }
    }
}