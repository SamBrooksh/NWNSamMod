#include "sm_consts"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); 
    int oClone1 = GetLocalInt(oCaster, VOID_CLONE_HEX_NUM);
    int oClone2 = GetLocalInt(oCaster, VOID_CLONE_HEX_NUM2);
    int target = ObjectToString(oTarget);
    if (target != oClone1 && target != oClone2)
    {
        //TODO//Increment useage - specify target and return
        return;
    }
    Location lCaster = GetLocation(oCaster);
    Location lTarget = GetLocation(oTarget);    
    int ravage = GetHasFeat(FEAT_VOID_RAVAGING_SWAP, oCaster);
    int empower = GetHasFeat(FEAT_VOID_EMPOWERING_SWAP, oCaster);
    float size = 30.0;
    object inBetween = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, size, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    while (GetIsObjectValid(inBetween)) 
    {
        //Exclude caster and target
        if (inBetween != oCaster && inBetween != oTarget)
        {
            //Don't hurt friends
            if (spellIsTarget(inBetween, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                //Do the Ravage feat
            }
        }
        GetNextObjectInShape(SHAPE_SPELLCYLINDER, size, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    }
    
}