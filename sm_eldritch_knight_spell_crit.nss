int CAT_HARMFUL_SPELL = 0;
int CAT_BENEFICIAL_SPELL = 1;
int CAT_AOE_SPELL = 4;
int CAT_SELF_SPELL = 1;
int CAT_TARGET_SPELL = 2;

int GetSpellHarmful(int spell_id)
{
    //This should work I think
    int harmful = StringToInt(Get2dAString("spells", "HostileSetting", spell_id));
    return harmful;
}

int GetSpellTargetType(int spell_id)
{
    int target = StringToInt(Get2dAString("spells", "TargetType", spell_id)); 
    return target;
}

void main()
{
    if (! GetIsObjectValid(otarget))
        return;
    int spellID = GetLocalInt(OBJECT_SELF, "ELDRITCHSPELL");
    if (spellID == 0)   //Doesn't have a valid spellID to cast - choose one
    {
        int classUse = GetLastSpellCastClass();     //May want to change this to the highest arcane level class?
        int spellLevel = Random(GetCasterLevel(OBJECT_SELF) - 1) + 1; 
        spellID = GetKnownSpellId(OBJECT_SELF, classUse, spellLevel);
    }
    else
        spellID = spellID - 1;  //Need to add one to it so that Acid Fog is caught and not an error
    
    object otarget = GetAttackTarget(OBJECT_SELF); //Choose target based on spell qualities
    int harmOrBenef = GetSpellHarmful(spellID);
    int target = GetSpellTargetType(spellID);
    if (harmOrBenef == CAT_HARMFUL_SPELL)
    {
        if ((target & CAT_AOE_SPELL) != 0)
        {
            Location lTarget = GetLocation(otarget);
            ActionCastSpellAtLocation(spellID, lTarget, METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else
        {
            ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);    
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
            ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    SpeakString("Spell Critical!", 1);
    //Change the otarget depending on the target of the spell (self, aoe or the like)
    //ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    //May need to change Action Cast Spells to change which classtype to use
}