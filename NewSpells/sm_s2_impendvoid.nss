#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int bFading = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_FADING_DEBUFF) > 0;
    int bScorned = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_SCORNED_DEBUFF) > 0;
    int bVConsumed = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_CONSUMED_DEBUFF) > 0;
    int bCursedStrikes = SMHasVoidDebuff(oTarget, oCaster, CONST_VOID_CURSED_S_DEBUFF) > 0;  
    int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage; 
    effect eDamage;
    effect eVis;
    int nMultipler = bFading + bVConsumed + bScorned + bCursedStrikes;
    if (TouchAttackMelee(oTarget, TRUE, oCaster))
    {
        if ( bFading || bVConsumed || bScorned)
        {
            //nDamage = d6(nLevel);   //Maybe make it so that it increases the dice for each (but probably would need to make them d4's instead)
            // looking at it, there seems to be an interesting choice between d6(level) + level * multiplier and d4(level * multiplier)
            //d4 has a higher spike with all 3 debuffs, and lower otherwise, while d6 is more consistent
            //I think I'll go for d4 for now
            
            nDamage = d4(nLevel * nMultipler);
            int nDC = 10 + nLevel / 2 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
            if (FortitudeSave(oTarget, nDC))
                nDamage = nDamage / 2;
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
            //eVis ;    //Figure out the visual
            eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else 
        {
            SpeakString("Target doesn't have appropriate Void Scarred Debuffs", 1);
            IncrementRemainingFeatUses(oCaster, FEAT_IMPENDING_VOID);
            return;
            //Reset, specify that target doesn't have 
        }
    }
    return;
}