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

    nArcSpell = nArcSpell - 1; //Remove the +1 to handle Index 0
    nDivSpell = nDivSpell - 1;
    //Should include label trying to cast
    if (GetHasSpell(nArcSpell, oCaster) < 1)
    {
        SpeakString("Don't have any uses left of Arcane Spell!");
        nError++;
    }
    if (GetHasSpell(nDivSpell, oCaster) < 1)
    {
        SpeakString("Don't have any uses left of Divine Spell!");
        nError++;
    }
 
    if (nError > 0)
    {
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_SPELL_SYNTHESIS);
        return;
    }
    // Need to get Spell Targeting for each spell
    // Use TargetFlags, HostileSetting, TargetType
    // For now going to have to target a creature - then will choose self if it has helps allies in target flags
    // 
    object oTarget = GetSpellTargetObject();
    int nArcTargetType = StringToInt(Get2DAString("spells", "HostileSetting", nArcSpell));
    int nDivTargetType = StringToInt(Get2DAString("spells", "HostileSetting", nDivSpell));

    int nArcOorL = StringToInt(Get2DAString("spells", "TargetType", nArcSpell));
    int nDivOorL = StringToInt(Get2DAString("spells", "TargetType", nDivSpell));
    //Maybe I could add a column and put in a column to specify target if auto casted?
    if (nArcOorL % 2 == 1)  //Not target a creature
    {
        ActionCastSpellAtLocation(nArcSpell, GetLocation(oTarget), METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else 
    {
        if (nArcTargetType == 0) // Not hostile, cast on self? 
        {
            //Cast on self
            ActionCastSpellAtObject(nArcSpell, oCaster, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            ActionCastSpellAtObject(nArcSpell, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }

    if (nDivOorL % 2 == 1)
    {
        ActionCastSpellAtLocation(nDivSpell, GetLocation(oTarget), METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else 
    {
        if (nDivTargetType == 0)
        {
            ActionCastSpellAtObject(nDivSpell, oCaster, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else 
        {
            ActionCastSpellAtObject(nDivSpell, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
}