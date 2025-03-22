#include "sm_spellfunc"
#include "nwnx_chat"

void SMSummonClone(object oCaster, location lLocation);
//TODO: Add Death Script to clone to remove penalty - maybe unsummon script
//      Graphics
//      Feat modifications
void main()
{
    object oCaster = OBJECT_SELF;
    location lClone = GetSpellTargetLocation();

    SMSummonClone(oCaster, lClone);
}

// User takes a large penalty
// Then creates a shadow version, with no items and reduced health
//
void SMSummonClone(object oCaster, location lLocation)
{
    int nDuration = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);    //10 minutes per level I think
    int chaPen = 3;
    int strPen = 4;
    int refPen = 2;
    int willPen = 2;
    int fortPen = 2;
    if (GetHasFeat(FEAT_VOID_ASSIMILATION, oCaster))
    {
        chaPen = chaPen - 2;
        strPen = strPen - 2;
        refPen = refPen - 1;
        willPen = willPen - 1;
        fortPen = fortPen - 1;
        //Reduce penalties
    }

    effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, chaPen);
    effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, strPen);
    effect eRef = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, refPen);
    effect eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, willPen);
    effect eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, fortPen);
    effect eCombined = EffectLinkEffects(eCha, eStr);
    eCombined = EffectLinkEffects(eRef, eCombined);
    eCombined = EffectLinkEffects(eWill, eCombined);
    eCombined = EffectLinkEffects(eFort, eCombined);
    eCombined = HideEffectIcon(eCombined);
    eCombined = EffectLinkEffects(eCombined, EffectIcon(EFFECT_ICON_CLONE_PENALTY)); //Make new icon name/picture
    eCombined = EffectLinkEffects(eCombined, EffectRunScript());
    eCombined = SupernaturalEffect(eCombined);
    eCombined = TagEffect(eCombined, CONST_VOID_SUMMON_DEBUFF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCombined, oCaster);

    object oSummon2;
    object oSummon = CopyObject(oCaster, lLocation, OBJECT_INVALID, VOID_CLONE_TAG);
    int bVoidPerf = GetHasFeat(FEAT_VOID_PERFECTION, oCaster);
    SMNoDrops(oSummon);     //This may do what I want exactly
    ForceRefreshObjectUUID(oSummon);
    NWNX_Creature_AddAssociate(oCaster, oSummon, ASSOCIATE_TYPE_SUMMONED);
    SMSetHenchmanScripts(oSummon);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCombined, oSummon);

    SetLocalObject(oCaster, VOID_CLONE_HEX_NUM, oSummon);
    //These should be all the Feat modifications
    //Set Max HP to 75%, -2 to all Base Stats I think - will leave stats alone for now, unless Void Perfection
    //Need to make On death script for clone - and probably apply colored effects/Summoning in
    //Need to remove held items - and give clone a weapon with the onhit cast sm_s2_cloneatk script I think
    if (bVoidPerf)
    {
        oSummon2 = CopyObject(oCaster, lLocation, OBJECT_INVALID, VOID_CLONE_TAG_2);
        SMNoDrops(oSummon2); //This may do what I want exactly
        ForceRefreshObjectUUID(oSummon2);
        NWNX_Creature_AddAssociate(oCaster, oSummon2, ASSOCIATE_TYPE_SUMMONED);
        SMSetHenchmanScripts(oSummon2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCombined, oSummon2);
        SetLocalObject(oCaster, VOID_CLONE_HEX_NUM2, oSummon2);
    }
    else
    {
        int nClonePenalty = 2;
        effect eCloneCha = EffectAbilityDecrease(ABILITY_CHARISMA, nClonePenalty);
        effect eCloneStr = EffectAbilityDecrease(ABILITY_STRENGTH, nClonePenalty);
        effect eCloneDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nClonePenalty);
        effect eCloneCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, nClonePenalty);
        effect eCloneInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nClonePenalty);
        effect eCloneWis = EffectAbilityDecrease(ABILITY_WISDOM, nClonePenalty);
        effect eCloneCombine = EffectLinkEffects(eCloneCha, eCloneStr);
        eCloneCombine = EffectLinkEffects(eCloneCombine, eCloneDex);
        eCloneCombine = EffectLinkEffects(eCloneCombine, eCloneCon);
        eCloneCombine = EffectLinkEffects(eCloneCombine, eCloneInt);
        eCloneCombine = EffectLinkEffects(eCloneCombine, eCloneWis);
        eCloneCombine = SupernaturalEffect(eCloneCombine);

        int nSummonHealth = NWNX_Object_GetCurrentHitPoints(oSummon);
        nSummonHealth = nSummonHealth * 3 / 4;
        int nSummonHealthMax = GetMaxHitPoints(oSummon);
        int nLevel = SMGetLevel(oCaster);
        int nConMod = GetAbilityModifier(ABILITY_CONSTITUTION, oSummon);
        nSummonHealthMax = nSummonHealthMax * 3 / 4 - (nLevel * nConMod);
        NWNX_Object_SetMaxHitPoints(oSummon, nSummonHealthMax);
        NWNX_Object_SetCurrentHitPoints(oSummon, nSummonHealth);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCloneCombine, oSummon);
    }
    //Need to modify weapon on hit modifier, and potentially scripts attached to the creature?
    //Probably just add the one - I think I need to add a script to the weapon

}