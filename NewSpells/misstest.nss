#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void castMissile(object oCaster, object oTarget, int RESISTED, int nCasterLevel);

void main()
{
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int voidLevel = 10;


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        //Probably will need to change this to Void Missile
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        //Make a Touch attack
        int resist = MyResistSpell(OBJECT_SELF, oTarget, 0.0);
        //Apply the MIRV and damage effect
        AssignCommand(oCaster, castMissile(oCaster, oTarget, resist, voidLevel));

        int nClone = 1;
        object oClone = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, nClone);
        //Probably should check that it is a clone somehow as well
        while (GetIsObjectValid(oClone))
        {
            //if (CLONEVALID)
            AssignCommand(oClone, castMissile(oCaster, oTarget, resist, voidLevel));
            nClone += 1;
            oClone = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, nClone);
        }

    }
}

void castMissile(object oCaster, object oTarget, int RESISTED, int nCasterLevel)
{
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV); //Change
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);  //Change
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
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
            int nDam = 0;

            //Set damage effect
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
            //Apply the MIRV and damage effect
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
            fTime = fDelay;
            fDelay2 += 0.1;
            fTime += fDelay2;

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