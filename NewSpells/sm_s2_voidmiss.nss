//::///////////////////////////////////////////////
//:: Void Missile
//:: sm_s2_voidmiss
//:://////////////////////////////////////////////
/*
// Cause all Clones and User to Cast Void missile 
// with feats
*/
//:://////////////////////////////////////////////
//:: Created By: Sam Brooks
//:: Created On: Oct 10, 2024
//:://////////////////////////////////////////////
//:: Last Updated By: Sam Brooks, On: Oct 15, 2024

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "sm_consts"
//#include "sm_spellfunc"

void castMissile(object oCaster, object oTarget, int RESISTED, int nCasterLevel, int NULL_MISSILE = FALSE, int CRACKLING = FALSE);

void main()
{
    //SpeakString("Started", 1);
    object oTarget = GetSpellTargetObject();
    //if (!GetIsObjectValid(oTarget))
    //{ //Debug testing
    //    oTarget = StringToObject("0x2");
    //}
    object oCaster = OBJECT_SELF;
    int nDamage = 0;
    int voidLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    int cloneCast = GetHasFeat(FEAT_VOID_CLONE_MISSILE_COPY, oCaster);
    int cracklingCast = GetHasFeat(FEAT_VOID_CRACKLING_MISSILE, oCaster);
    int nullCast = GetHasFeat(FEAT_VOID_NULL_MISSILE, oCaster);
    float fDelay = 0.0;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        //Probably will need to change this to Void Missile 
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VOID_MISSLE));
        //Make a Touch attack
        int resist = MyResistSpell(OBJECT_SELF, oTarget, fDelay);
        //Apply the MIRV and damage effect
        AssignCommand(oCaster, castMissile(oCaster, oTarget, resist, voidLevel, nullCast, cracklingCast));
        if (cloneCast)
        {   
            int nClone = 1;
            object oClone = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, nClone);
            //Probably should check that it is a clone somehow as well
            while (GetIsObjectValid(oClone))
            {
                //if (CLONEVALID)   //As in is a clone not just a summon
                AssignCommand(oClone, castMissile(oCaster, oTarget, resist, voidLevel, nullCast, cracklingCast));
                nClone += 1;
                oClone = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, nClone);
            }
        }
    }
}

//Apply Damage and effects to target for each missile being casted from the "casters"
void castMissile(object oCaster, object oTarget, int RESISTED, int nCasterLevel, int NULL_MISSILE = FALSE, int CRACKLING = FALSE)
{
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_VOID);    //Change
    effect eVis = EffectVisualEffect(VFX_MIRV_VOID_IMPACT);     //Change
    float fDist = GetDistanceBetween(oCaster, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    int nMissiles = nCasterLevel / 3;
    if (nMissiles > 3)
    {
        nMissiles = 3;
    }
    int nCnt;
    if (!RESISTED)
    {
        for (nCnt = 1; nCnt <= nMissiles; nCnt++)
        {
            //Roll damage
            int nDam = d4(1);

            //Set damage effect
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_VOID);
            if (NULL_MISSILE)
            {
                //Have them try to resist - with delay I assume
                DelayCommand(fTime, SMApplyVoidScorned(oTarget, oCaster));
            }
            if (CRACKLING)
            {
                //Have them try to resist - with delay I assume
                DelayCommand(fTime, SMApplyFadingDebuff(oTarget, oCaster));
            }
            fTime = fDelay;
            fDelay2 += 0.1;
            fTime += fDelay2;
            //Apply the MIRV and damage effect
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        }
    }
    else
    {
        for (nCnt = 1; nCnt <= nMissiles; nCnt++)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        }
    }
}