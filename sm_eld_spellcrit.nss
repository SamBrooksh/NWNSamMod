#include "nwnx_damage"
#include "nwnx_creature"
#include "sm_consts"

/*
This needs a whole lot of reworking and the likes
*/

int CAT_HARMFUL_SPELL = 1;
int CAT_BENEFICIAL_SPELL = 0;
int CAT_AOE_SPELL = 4;
int CAT_SELF_SPELL = 1;
int CAT_TARGET_SPELL = 2;

int GetSpellHarmful(int nSpell)
{
    //This should work I think
    int harmful = StringToInt(Get2DAString("spells", "HostileSetting", nSpell));
    return harmful;
}

int GetSpellTargetType(int nSpell)
{
    int target = StringToInt(Get2DAString("spells", "TargetType", nSpell));
    return target;
}

/***
This should probably just choose the point for where the spell should be cast
***/
void CastSpell(int nSpellID)
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetAttackTarget(oCaster); //Choose target based on spell qualities
    int harmOrBenef = GetSpellHarmful(nSpellID);
    int nSpellTargetType = GetSpellTargetType(nSpellID);
    //SpeakString("nSpellTargetType mod 4: " + IntToString(nSpellTargetType & CAT_AOE_SPELL));
    if (!GetIsObjectValid(oTarget))
        return;
    
    int bResult = FALSE;
    int nAddFirst = TRUE;
    float fDelay = 0.0;
    string bProjectile = Get2DAString("spells", "HasProjectile", nSpellID);
    int nCasterLevel = GetCasterLevel(oCaster);
    //SpeakString("Projectile: " + bProjectile);
    if (bProjectile == "1")
    {
        float nDistance = GetDistanceToObject(oCaster, oTarget);
        fDelay = nDistance / 25; 
    }
    //Probably should check if there is a projectile with the spell (and do 0 if so) 
    //Need to change the targeting and remove a spell use - May want to try and have it confirm that
    DecrementRemainingSpellUses(oCaster, nSpellID);
    // Tried again to use the AddCastSpellActions - it seems to have problems if the person
    // has multiple attacks (sorta) so I'm going to just use doitemcastspell
    // Should change this logic for if it's placed on enemy or self
    if (harmOrBenef == CAT_HARMFUL_SPELL)
    {
        if ((nSpellTargetType & CAT_AOE_SPELL) != 0)
        {
            //SpeakString("In 1");
            NWNX_Creature_DoItemCastSpell(oCaster, OBJECT_INVALID, GetLocation(oTarget), nSpellID, nCasterLevel, fDelay);
        }
        else
        {
            //SpeakString("In 2");
            NWNX_Creature_DoItemCastSpell(oCaster, oTarget, GetLocation(oTarget), nSpellID, nCasterLevel, fDelay);
        }
    }
    else
    {
        if ((nSpellTargetType & CAT_SELF_SPELL) != 0)
        {
            //SpeakString("In 3");
            NWNX_Creature_DoItemCastSpell(oCaster, oCaster, GetLocation(oCaster), nSpellID, nCasterLevel, fDelay);
        }
        else
        {
            //SpeakString("In 4");
            NWNX_Creature_DoItemCastSpell(oCaster, oCaster, GetLocation(oCaster), nSpellID, nCasterLevel, fDelay);
        }
    }
    SpeakString("Spell Critical!");
    
}

float CharToRange(string cha)
{
    if (cha == "P")
        return 0.0;
    if (cha == "T")
        return 2.5;
    if (cha == "S")
        return 8.0;
    if (cha == "M")
        return 20.0;
    if (cha == "L")
        return 40.0;
    return 0.0;
}

/*
Needs the spell in oPC regardless - will return -1 as a default
if all three are unusable or detrimental
Currently checks that target is in range, target doesn't have effect, and caster has use
*/
int RateSpell(int nSpell, object oPC, object oTarget)
{
    // Probably need to have dispel magic specifically checked
    // Since it can be beneficial to cast on either self or enemy depending on situation...
    if (!GetHasSpell(nSpell, oPC))
    {  
        PrintString("Eldritch Knight Spell Critical: No use of Spell " + IntToString(nSpell));
        return -1;
    }
    
    // If a buff that player already has (or debuff that target already has)
    // This needs extensive testing! I think it should work though?
    object oAffected = oPC;
    if (GetSpellHarmful(nSpell) == CAT_HARMFUL_SPELL)
        oAffected = oTarget;
    if (GetHasSpellEffect(nSpell, oAffected))
    {
        PrintString("Eldritch Knight Spell Critical: Affected has Spell effect already! " + IntToString(nSpell));
        return -1;
    }
    //If targets enemy and they are out of range, than should be bad
    string sRange = Get2DAString("spells", "Range", nSpell);
    float nRange = CharToRange(sRange); 
    float nDistance = GetDistanceToObject(oPC, oAffected);
    if (nDistance > nRange)
    {
        PrintString("Eldritch Knight Spell Critical: Target to Far for " + IntToString(nSpell));
        return -1;
    }
    return 1;
}

int BestSpell(int s1, int s2, int s3, object oPC, object oTarget)
{
    int rS1, rS2, rS3;
    rS1 = RateSpell(s1, oPC, oTarget) * 3;   //May not be necessary, but useful if I make it "smarter"
    rS2 = RateSpell(s2, oPC, oTarget) * 2;
    rS3 = RateSpell(s3, oPC, oTarget);

    if (rS1 >= rS2 && rS1 >= rS3 && rS1 > -1)
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
    //SpeakString("In ELD SPELL CRIT");
    if (GetHasFeat(FEAT_SPELL_CRITICAL, oAttacker))
    {
        //Need to decrement what it was so that it reflects the actual spell instead of the modified one - -1 means no spell was there
        int nSpell1 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL_CONST) - 1;
        int nSpell2 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL2_CONST) - 1;
        int nSpell3 = GetLocalInt(oAttacker, SM_SPELL_CRITICAL3_CONST) - 1;
        nSpell1 = BestSpell(nSpell1, nSpell2, nSpell3, oAttacker, attack.oTarget);

        if (nSpell1 != -1)
        {
            CastSpell(nSpell1);
        }
        else
        {
            //Deal some bonus damage instead?
            SpeakString("No Applicable Spell selected for Spell Critical!", TALKVOLUME_WHISPER);
        }
    }
}