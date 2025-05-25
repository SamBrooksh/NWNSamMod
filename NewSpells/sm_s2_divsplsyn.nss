#include "sm_nuispellsynth"

void main()
{
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_SPELL_SYNTHESIS);
    SMChooseSpellSynthMenu(DIVINE_CLASS, OBJECT_SELF);
}