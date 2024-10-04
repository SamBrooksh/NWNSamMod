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

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nDamage = 0;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV); //Change
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);  //Change
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
	if(!GetIsReactionTypeFriendly(oTarget))
	{
        //Fire cast spell at event for the specified target
        //Probably will need to change this
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        //Make SR Check
        //Make a Touch attack
      	if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
	    {
            //Apply a single damage hit for each missile instead of as a single mass
            
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                //Roll damage
                int nDam = d4(1) + 1;
     	        //Enter Metamagic conditions
    	        if (nMetaMagic == METAMAGIC_MAXIMIZE)
    	        {
    		          nDam = 5;//Damage is at max
    	        }
    	        if (nMetaMagic == METAMAGIC_EMPOWER)
    	        {
    		          nDam = nDam + nDam/2; //Damage/Healing is +50%
    	        }
                if (spellReaction)
                {
                    nDam = FloatToInt(IntToFloat(nDam) * SPELL_REACTION_MULTIPLIER);
                }
                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

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
     }
}
