//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: June 11, 2001

int ApplyPrismaticEffect(int nEffect, object oTarget, int spellReaction = FALSE);

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "sm_spellfunc"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nRandom;
    int nHD;
    int nVisual;
    effect eVisual;
    int bTwoEffects;
    //Set the delay to apply to effects based on the distance to the target
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    //Get first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
    //Adding Eldritch Knight Spell double damage chance
    int spellReaction = FALSE;
    if (GetHasFeat(FEAT_SPELL_REACTION, OBJECT_SELF))
    {
        if (d20(1) == 20)
        {
            SpeakString("Spell Reaction!", 1);
            spellReaction = TRUE;
        }
    }
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            {
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(nCasterLevel));
                }
                //Determine if 1 or 2 effects are going to be applied
                nRandom = d8();
                if(nRandom == 8)
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget, spellReaction);
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget, spellReaction);
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(nRandom, oTarget);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
    }
}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
    of corresponding prismatic cone to the target.  To have any effect the
    reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget, int spellReaction = FALSE)
{
    int nDamage;
    effect ePrism;
    effect eVis;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;
    int nVis;
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case 1://fire
            nDamage = 20;
            if (spellReaction)
            {
                nDamage = FloatToInt(IntToFloat(nDamage) * SPELL_REACTION_MULTIPLIER);
            }
            nVis = VFX_IMP_FLAME_S;
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 2: //Acid
            nDamage = 40;
            if (spellReaction)
            {
                nDamage = FloatToInt(IntToFloat(nDamage) * SPELL_REACTION_MULTIPLIER);
            }
            nVis = VFX_IMP_ACID_L;
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ACID);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 3: //Electricity
            nDamage = 80;
            if (spellReaction)
            {
                nDamage = FloatToInt(IntToFloat(nDamage) * SPELL_REACTION_MULTIPLIER);
            }
            nVis = VFX_IMP_LIGHTNING_S;
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 4: //Poison
            {
                effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
            }
        break;
        case 5: //Paralyze
            {
                effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) == 0)
                {
                    ePrism = EffectParalyze();
                    eLink = EffectLinkEffects(eDur, ePrism);
                    eLink = EffectLinkEffects(eLink, eDur2);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;
        case 6: //Confusion
            {
                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                ePrism = EffectConfused();
                eLink = EffectLinkEffects(eMind, ePrism);
                eLink = EffectLinkEffects(eLink, eDur);

                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    nVis = VFX_IMP_CONFUSION_S;
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;
        case 7: //Death
            {
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    //nVis = VFX_IMP_DEATH;
                    ePrism = EffectDeath();
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                }
            }
        break;
    }
    return nVis;
}
