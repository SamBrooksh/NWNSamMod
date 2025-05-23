#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    int nArcSpell = GetLocalInt(oCaster, SM_SPELLSYNTHESIS_ARCANE);
    int nDivSpell = GetLocalInt(oCaster, SM_SPELLSYNTHESIS_DIVINE);
    int nError = 0;
    if (nArcSpell == 0)
    {
        SpeakString("NO ARCANE SPELL SELECTED");
        nError++;
    } 
    if (nDivSpell == 0)
    {
        SpeakString("NO DIVINE SPELL SELECTED");
        nError++;
    }
    if (nError > 0)
    {
        return;
    }
    

}