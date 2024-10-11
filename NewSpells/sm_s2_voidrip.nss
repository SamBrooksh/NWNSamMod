#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage;
    int nReflexDC = 10 + nCasterLvl + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); //Change to be a black and purple effect
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);      //likewise
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    int nUsesLeft = GetLocalInt(oCaster, CONST_USES_VOID_RIP) - 1;
    SetLocalInt(oCaster, CONST_USES_VOID_RIP, nUsesLeft);
    
    if (nUsesLeft > 1)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_RIP);
    }

    while (GetIsObjectValid(oTarget))
    {
        //Need to skip over the clones
        //SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VOID_RIP));  //Maybe should have this
        if (SpellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            nDamage = d6(nCasterLvl);
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nReflexDC);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nReflexDC, SAVING_THROW_TYPE_NONE, oCaster, 0.0))
            {
                
                int dur = 2 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
                SM_Apply_Consumed_By_Void(oTarget, oCaster, dur);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}