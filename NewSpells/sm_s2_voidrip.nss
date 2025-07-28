#include "sm_spellfunc"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int nDamage;
    int nReflexDC = 10 + nCasterLvl + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    location lTarget = GetSpellTargetLocation();
    float fDist = GetDistanceBetweenLocations(lTarget, GetLocation(oCaster));
    //float fRayDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay = 0.0;
    effect eExplode = EffectVisualEffect(VFX_VOID_RIP); //Change to be a black and purple effect
    effect eVis = EffectVisualEffect(VFX_MIRV_VOID_IMPACT);      //likewise
    effect eDam;

    //effect eRay = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);   //Looks like can't do IMP to locations
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eRay, lTarget);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    
    int nUses = GetLocalInt(oCaster, CONST_USES_VOID_RIP);
    if (nUses > 0)
    {
        IncrementRemainingFeatUses(oCaster, FEAT_VOID_RIP);
    }
    SetLocalInt(oCaster, CONST_USES_VOID_RIP, nUses - 1);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (GetTag(oTarget) == VOID_CLONE_TAG || GetTag(oTarget) == VOID_CLONE_TAG_2)
        {
            //Don't do anything to the clones
        }
        else
        {
            //Need to skip over the clones
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VOID_RIP));  //Maybe should have this
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                nDamage = d6(nCasterLvl);
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nReflexDC);
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_VOID);
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nReflexDC, SAVING_THROW_TYPE_NONE, oCaster, 0.0))
                {
                    int dur = 2 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
                    DelayCommand(fDelay, SMApplyVoidConsumed(oTarget, oCaster, dur));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}