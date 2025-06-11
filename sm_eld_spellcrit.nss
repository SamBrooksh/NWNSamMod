#include "nwnx_damage"
#include "nwnx_creature"
#include "sm_consts"

/*
This needs a whole lot of reworking and the likes
*/

int CAT_HARMFUL_SPELL = 0;
int CAT_BENEFICIAL_SPELL = 1;
int CAT_AOE_SPELL = 4;
int CAT_SELF_SPELL = 1;
int CAT_TARGET_SPELL = 2;

int GetSpellHarmful(int spell_id)
{
    //This should work I think
    int harmful = StringToInt(Get2DAString("spells", "HostileSetting", spell_id));
    return harmful;
}

int GetSpellTargetType(int spell_id)
{
    int target = StringToInt(Get2DAString("spells", "TargetType", spell_id));
    return target;
}

/***
This should probably just choose the point for where the spell should be cast
***/
void CastSpell(int spellID)
{
    object oTarget = GetAttackTarget(OBJECT_SELF); //Choose target based on spell qualities
    int harmOrBenef = GetSpellHarmful(spellID);
    int target = GetSpellTargetType(spellID);
    if (! GetIsObjectValid(oTarget))
        return;
    /* For now, should probably just leave if an error
    if (spellID == 0)   //Doesn't have a valid spellID to cast - choose one
    {
        int classUse = GetLastSpellCastClass();     //May want to change this to the highest arcane level class?
        //There should probably
        int spellLevel = Random(GetCasterLevel(OBJECT_SELF) - 1) + 1;
        spellID = GetKnownSpellId(OBJECT_SELF, classUse, spellLevel, 0);
    }
    else
    */
    int bResult = FALSE;
    int nClassCasterPosition = 0;   //Need to update this
    int nAddFirst = TRUE;
    //Need to change the targeting and remove a spell use
    DecrementRemainingSpellUses(OBJECT_SELF, spellID);
    if (harmOrBenef == CAT_HARMFUL_SPELL)
    {
        if ((target & CAT_AOE_SPELL) != 0)
        {
            //bResult = NWNX_Creature_AddCastSpellActions(OBJECT_SELF, oTarget, GetTargetingModeSelectedPosition(), spellID, nClassCasterPosition, METAMAGIC_NONE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE, FALSE, nAddFirst);
            NWNX_Creature_DoItemCastSpell(OBJECT_SELF, OBJECT_INVALID, GetLocation(oTarget), spellID, GetCasterLevel(OBJECT_SELF), 0.0);
            //ActionCastSpellAtLocation(spellID, lTarget, METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            //bResult = NWNX_Creature_AddCastSpellActions(OBJECT_SELF, oTarget, GetTargetingModeSelectedPosition(), spellID, nClassCasterPosition, METAMAGIC_NONE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE, FALSE, nAddFirst);
            NWNX_Creature_DoItemCastSpell(OBJECT_SELF, oTarget, GetLocation(oTarget), spellID, GetCasterLevel(OBJECT_SELF), 0.0);
            //ActionCastSpellAtObject(spellID, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    else
    {
        if ((target & CAT_SELF_SPELL) != 0)
        {
            //bResult = NWNX_Creature_AddCastSpellActions(OBJECT_SELF, OBJECT_SELF, GetTargetingModeSelectedPosition(), spellID, nClassCasterPosition, METAMAGIC_NONE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE, FALSE, nAddFirst);
            NWNX_Creature_DoItemCastSpell(OBJECT_SELF, OBJECT_SELF, GetLocation(OBJECT_SELF), spellID, GetCasterLevel(OBJECT_SELF), 0.0);
            //ActionCastSpellAtObject(spellID, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            //bResult = NWNX_Creature_AddCastSpellActions(OBJECT_SELF, OBJECT_SELF, GetTargetingModeSelectedPosition(), spellID, nClassCasterPosition, METAMAGIC_NONE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE, FALSE, nAddFirst);
            NWNX_Creature_DoItemCastSpell(OBJECT_SELF, OBJECT_SELF, GetLocation(OBJECT_SELF), spellID, GetCasterLevel(OBJECT_SELF), 0.0);
            //ActionCastSpellAtObject(spellID, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    SpeakString("Spell Critical! Casted " + IntToString(spellID) + " RESULT: " + IntToString(bResult));
    //Change the otarget depending on the target of the spell (self, aoe or the like)
    //ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    //May need to change Action Cast Spells to change which classtype to use
}

/*
Have some way to rate which one to use? - Prioritze s1 > s2 > s3
Needs the spell in oPC regardless - will return 0 as a default
if all three are unusable or detrimental
*/
int RateSpell(int nSpell, object oPC)
{
    if (!GetHasSpell(nSpell, oPC))
        return -1;

    return 1;
}

int BestSpell(int s1, int s2, int s3, object oPC)
{
    int rS1, rS2, rS3;
    rS1 = RateSpell(s1, oPC) * 3;   //May not be necessary
    rS2 = RateSpell(s2, oPC) * 2;
    rS3 = RateSpell(s3, oPC);

    if (rS1 >= rS2 && rS1 > rS3 && rS1 > -1)
        return s1;
    if (rS2 >= rS3 && rS2 > -1)
        return s2;
    if (rS3 > -1)
        return s3;
    return -1;
}


void main()
{
    struct NWNX_Damage_AttackEventData attack = NWNX_Damage_GetAttackEventData();
    object oAttacker = OBJECT_SELF;
    SpeakString("In ELD SPELL CRIT");
    if (GetHasFeat(FEAT_SPELL_CRITICAL, oAttacker))
    {
        //Need to decrement what it was so that it reflects the actual spell instead of the modified one - -1 means no spell was there
        int nSpell1 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL_CONST) - 1;
        int nSpell2 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL2_CONST) - 1;
        int nSpell3 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL3_CONST) - 1;
        nSpell1 = BestSpell(nSpell1, nSpell2, nSpell3, oAttacker);
        //If
        if (nSpell1 != -1)
        {
            CastSpell(nSpell1);
        }
        else
        {
            //Deal some bonus damage instead?
            SpeakString("No Spell selected for Spell Critical!");
        }
    }

}