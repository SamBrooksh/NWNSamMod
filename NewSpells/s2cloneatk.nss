#include "sm_spellfunc"
// Give this to the Clone to identify additional clone 
void main()
{
    object oAttacker = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    object oCaster = GetMaster(oAttacker);
    int voidHatred = GetHasFeat(FEAT_VOID_HATRED, oCaster);
    int chance = 50;    //Change this when more accurate
    int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    if (GetHasFeat(FEAT_VOID_SCORN, oCaster))
    {
        //Add Void Scorn Chance
        if (d100() < chance)
        {
            SpeakString("Void Scorn Applied", 1);
            SMApplyVoidScorned(oTarget, oCaster, 3);
        }
    }
    
    if (GetHasFeat(FEAT_VOID_CONSUMED_BY_VOID, oCaster))
    {
        //Add Consumed by void chance to be applied
        if (d100() < chance)
        {
            SpeakString("Consumed by Void Applied", 1);
            SMApplyVoidConsumed(oTarget, oCaster, 1);
        }
    }
    if (GetHasFeat(FEAT_SAPPING_STRIKE, oCaster))
    {
        SpeakString("Sapping Strikes Applied", 1);
        SMApplySappingStrike(oCaster, oTarget);
        
    }
    if (GetHasFeat(FEAT_VOID_RENEWALL, oCaster))
    {
        SpeakString("Void Renewall Applied", 1);
        //Maybe make this something else?
        effect eTempHit = EffectTemporaryHitpoints(d6(2));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHit, oCaster, RoundsToSeconds(10));
    }

    effect eIntBonus = EffectDamage(nIntMod, DAMAGE_TYPE_VOID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eIntBonus, oTarget);
}