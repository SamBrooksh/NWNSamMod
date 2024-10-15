#include "sm_spell_func"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int bFading = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF);
    int bScorned = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_SCORNED_DEBUFF);
    int bVConsumed = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF);
    int bCursedStrikes = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_CURSED_S_DEBUFF);  
    int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage; 
    effect eDamage;
    effect eVis;
    int nMultipler = bFading + bVConsumed + bScorned + bCursedStrikes;
    if ( bFading || bVConsumed || bScorned)
    {
        //nDamage = d6(nLevel);   //Maybe make it so that it increases the dice for each (but probably would need to make them d4's instead)
        // looking at it, there seems to be an interesting choice between d6(level) + level * multiplier and d4(level * multiplier)
        //d4 has a higher spike with all 3 debuffs, and lower otherwise, while d6 is more consistent
        //I think I'll go for d4 for now
        nDamage = d4(nLevel * nMultipler);
        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
        //eVis ;    //Figure out the visual
        eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else 
    {
        SpeakString("Target doesn't have appropriate Void Scarred Debuffs", 1);
        IncrementRemainingFeatUses(OCaster, FEAT_IMPENDING_VOID);
        return;
        
        //Reset, specify that target doesn't have 
    }
}