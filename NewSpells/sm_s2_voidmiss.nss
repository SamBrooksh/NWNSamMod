//::///////////////////////////////////////////////
//:: Void Missile
//:: sm_s2_voidmiss
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "sm_spellfunc"

void main()
{
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nDamage = 0;
    int voidLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oCaster);
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV); //Change
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);  //Change
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
	if(!GetIsReactionTypeFriendly(oTarget))
	{
        //Fire cast spell at event for the specified target
        //Probably will need to change this to Void Missile 
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VOID_MISSLE));
        //Make a Touch attack

      	if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
	    {
            //Apply a single damage hit for each missile instead of as a single mass
            
                //Roll damage
                int nDam = d4(1) + 1;

                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
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
         //Remove a use properly
         
     }
}
