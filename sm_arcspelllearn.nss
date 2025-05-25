#include "sm_nuiarcsetup"

int PrestigeArcaneClass(int nClass)
{
    //Should auto update as well
    int val = StringToInt(Get2DAString("classes", "ArcSpellLvlMod", nClass));
    if (val != 0)
        return TRUE;
    return FALSE;
}


void main()
{
    object oCaster = OBJECT_SELF;
    //SendMessageToPC(GetFirstPC(), "After Level");
    int nClass = NWNX_Creature_GetClassByLevel(oCaster, GetLevel(oCaster));
    int nSpellToLearn = GetLocalInt(oCaster, SM_LEARN_ARCANE_COUNT);
    
    if (PrestigeArcaneClass(nClass))
    {
        nSpellToLearn += 2;
        SetLocalInt(oCaster, SM_LEARN_ARCANE_COUNT, nSpellToLearn);
    }
    // Catch if they need to learn spells for some reason again as well
    if (nSpellToLearn > 0)
    {
        NUILearnNewArcaneSpells(oCaster, nSpellToLearn);
    }
}