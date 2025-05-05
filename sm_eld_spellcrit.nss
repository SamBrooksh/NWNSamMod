#include "nwnx_events"
#include "nwnx_damage"

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
Have a lot to do with this
***/
void CastSpell(int spellID)
{
    object oTarget = GetAttackTarget(OBJECT_SELF); //Choose target based on spell qualities
    int harmOrBenef = GetSpellHarmful(spellID);
    int target = GetSpellTargetType(spellID);
    if (! GetIsObjectValid(oTarget))
        return;
    int spellID = GetLocalInt(OBJECT_SELF, "ELDRITCHSPELL");
    if (spellID == 0)   //Doesn't have a valid spellID to cast - choose one
    {
        int classUse = GetLastSpellCastClass();     //May want to change this to the highest arcane level class?
        //There should probably
        int spellLevel = Random(GetCasterLevel(OBJECT_SELF) - 1) + 1;
        spellID = GetKnownSpellId(OBJECT_SELF, classUse, spellLevel, 0);
    }
    else
        spellID = spellID - 1;  //Need to add one to it so that Acid Fog is caught and not an error


    if (harmOrBenef == CAT_HARMFUL_SPELL)
    {
        if ((target & CAT_AOE_SPELL) != 0)
        {
            location lTarget = GetLocation(oTarget);
            ActionCastSpellAtLocation(spellID, lTarget, METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            ActionCastSpellAtObject(spellID, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    else
    {
        if ((target & CAT_SELF_SPELL) != 0)
        {
            ActionCastSpellAtObject(spellID, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            ActionCastSpellAtObject(spellID, oTarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    SpeakString("Spell Critical!", 1);
    //Change the otarget depending on the target of the spell (self, aoe or the like)
    //ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    //May need to change Action Cast Spells to change which classtype to use
}



void main()
{
    struct NWNX_Damage_AttackEventData attack = NWNX_Damage_GetAttackEventData();
    object oAttacker = OBJECT_SELF;

    if (GetIsPC(oAttacker) || GetIsPC(attack.oTarget))
    {
        WriteTimestampedLogEntry("OnAttack: " +
            "Damager -> " + GetName(oAttacker) +
            "Target -> " + GetName(attack.oTarget));
        if (attack.iAttackResult == 3)
        {
            WriteTimestampedLogEntry("Critical!");
        }
    }
}