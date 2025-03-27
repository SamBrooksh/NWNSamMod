#include "sm_spellfunc"


// Void Swap
// Target one of the player's clones (saved by id on the oCaster)
// Change places, and if have additional feats, apply them
void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); 
    object oClone1 = GetLocalObject(oCaster, VOID_CLONE_HEX_NUM);
    object oClone2 = GetLocalObject(oCaster, VOID_CLONE_HEX_NUM2);
    if (oTarget != oClone1 && oTarget != oClone2)
    {
        //TODO//Increment useage - specify target and return
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_SWAP);
        SpeakString("Can only swap with a clone!", 1);
        return;
    }
    location lCaster = GetLocation(oCaster);
    location lTarget = GetLocation(oTarget);    
    int ravage = GetHasFeat(FEAT_VOID_RAVAGING_SWAP, oCaster);
    int empower = GetHasFeat(FEAT_VOID_EMPOWERING_SWAP, oCaster);
    float size = 30.0;
    int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    object inBetween = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, size, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
    
    if (ravage)
    {
        while (GetIsObjectValid(inBetween)) 
        {
            //Exclude caster and target
            if (inBetween != oCaster && inBetween != oTarget)
            {
                //Don't hurt friends
                if (spellsIsTarget(inBetween, SPELL_TARGET_STANDARDHOSTILE, oCaster))
                {
                    //Do the Ravage feat
                    int nDmg = d10(nLevel / 3) + (nLevel / 3);
                    effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_VOID);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, inBetween);
                }
            }
            inBetween = GetNextObjectInShape(SHAPE_SPELLCYLINDER, size, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCaster));
        }
    }

    if (empower)
    {
        //Gain Buff (Clone and Player) After Swapping for short time 
        //(+2 Atk Bonus, +10 temp HP, +10% to random modifiers - like clone applying debuffs?, +LVL to Void Damage for INT MOD turns) LVL 5
        //Need to set up local int for the void damage and random modifier
        int nTempHp = GetMaxHitPoints(oCaster) / 10;
        int nAttackBonus = 2; 
        effect eBuff = EffectAttackIncrease(2);
        effect eTemp = EffectTemporaryHitpoints(nTempHp);
        int nDuration = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster) + 1;
        eBuff = EffectLinkEffects(eBuff, eTemp);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oCaster, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, RoundsToSeconds(nDuration));
    }
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, ActionJumpToLocation(lCaster));
    AssignCommand(oCaster, ActionJumpToLocation(lTarget));
}