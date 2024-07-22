//Move to Mod global stuff or own script
void Check_Quick_Cast(object oplayer)
{
    if (d20(1) == 20)
    {
        ExecuteScript("sm_eldritch_knight_spell_crit", oplayer);
    }
}
int CAT_HARMFUL_SPELL = 1;
int CAT_BENEFICIAL_SPELL = 2;
int CAT_AOE_SPELL = 1;
int CAT_SELF_SPELL = 2;
int CAT_TARGET_SPELL = 3;
// TODO:
//    Finish listing Harmful spells and Beneficial Spells
int GetSpellHarmful(int spell_id)
{
    switch (spell_id)
    {
        //Arcane
        case SPELL_ACID_SPLASH:
        case SPELL_DAZE:
        case SPELL_ELECTRIC_JOLT:
        case SPELL_FLARE:
        case SPELL_RAY_OF_FROST:
        //Level 1
        case SPELL_BURNING_HANDS:
        case SPELL_CHARM_PERSON:
        case SPELL_COLOR_SPRAY:
        case SPELL_GREASE:
        case SPELL_HORIZIKAULS_BOOM:
        case SPELL_ICE_DAGGER:
        case SPELL_MAGIC_MISSILE:
        case SPELL_NEGATIVE_ENERGY_RAY:
        case SPELL_RAY_OF_ENFEEBLEMENT:
        case SPELL_SCARE:
        case SPELL_SLEEP:
        //Level 2
        case SPELL_BLINDNESS_AND_DEAFNESS:
        case SPELL_CLOUD_OF_BEWILDERMENT:
        case SPELL_COMBUST:
        case SPELL_DARKNESS:
        case SPELL_GEDLEES_ELECTRIC_LOOP:
        case SPELL_GHOUL_TOUCH:
        case SPELL_MELFS_ACID_ARROW:
        case SPELL_TASHAS_HIDEOUS_LAUGHTER:
        case SPELL_WEB:
        //Level 3
        case SPELL_DISPEL_MAGIC://Assuming this is negative by default
        case SPELL_FIREBALL:
        case SPELL_FLAME_ARROW:
        case SPELL_GUST_OF_WIND:
        case SPELL_HOLD_PERSON:
        case SPELL_LIGHTNING_BOLT:
        case SPELL_MESTILS_ACID_BREATH:
        case SPELL_NEGATIVE_ENERGY_BURST:
        case SPELL_SCINTILLATING_SPHERE:
        case SPELL_SLOW:
        case SPELL_STINKING_CLOUD:
        case SPELL_VAMPIRIC_TOUCH:
        // Level 4
        case SPELL_BESTOW_CURSE:
        case SPELL_CHARM_MONSTER:
        case SPELL_CONFUSION:
        case SPELL_CONTAGION:
        case SPELL_ENERVATION:
        case SPELL_EVARDS_BLACK_TENTACLES:
        case SPELL_FEAR:
        case SPELL_ICE_STORM:
        case SPELL_ISAACS_LESSER_MISSILE_STORM:
        case SPELL_LESSER_SPELL_BREACH:
        case SPELL_PHANTASMAL_KILLER:
        case SPELL_WALL_OF_FIRE:
        // Level 5
        case SPELL_BALL_LIGHTNING:
        case SPELL_BIGBYS_INTERPOSING_HAND:
        case SPELL_CLOUDKILL:
        case SPELL_CONE_OF_COLD:
        case SPELL_DISMISSAL:
        case SPELL_DOMINATE_PERSON:
        case SPELL_FEEBLEMIND:
        case SPELL_FIREBRAND:
        case SPELL_HOLD_MONSTER:
        case SPELL_MIND_FOG:
        // Level 6
        case SPELL_ACID_FOG:
        case SPELL_BIGBYS_FORCEFUL_HAND:
        case SPELL_CHAIN_LIGHTNING:
        case SPELL_CIRCLE_OF_DEATH:
        case SPELL_FLESH_TO_STONE:
        case SPELL_GREATER_DISPELLING:
        case SPELL_GREATER_SPELL_BREACH:
        case SPELL_ISAACS_GREATER_MISSILE_STORM:
        case SPELL_SHADES_CONE_OF_COLD:
        case SPELL_SHADES_FIREBALL:
        case SPELL_SHADES_WALL_OF_FIRE:
        case SPELL_UNDEATH_TO_DEATH:
        // Level 7
        case SPELL_BANISHMENT:
        case SPELL_BIGBYS_GRASPING_HAND:
        case SPELL_CONTROL_UNDEAD:
        case SPELL_DELAYED_BLAST_FIREBALL:
        case SPELL_FINGER_OF_DEATH:
        case SPELL_GREAT_THUNDERCLAP:
        case SPELL_POWER_WORD_STUN:
        case SPELL_PRISMATIC_SPRAY:
        // Level 8
        case SPELL_BIGBYS_CLENCHED_FIST:
        case SPELL_HORRID_WILTING:
        case SPELL_INCENDIARY_CLOUD:
        case SPELL_MASS_BLINDNESS_AND_DEAFNESS:
        case SPELL_MASS_CHARM:
        case SPELL_SUNBURST:
        // Level 9
        case SPELL_BIGBYS_CRUSHING_HAND:
        case SPELL_DOMINATE_MONSTER:
        case SPELL_ENERGY_DRAIN:
        case SPELL_METEOR_SWARM:
        case SPELL_MORDENKAINENS_DISJUNCTION:
        case SPELL_POWER_WORD_KILL:
        case SPELL_WAIL_OF_THE_BANSHEE:
        case SPELL_WEIRD:
        //Epic Level
        case SPELL_EPIC_RUIN:
        case SPELL_EPIC_HELLBALL:
        case SPELL_EPIC_MUMMY_DUST:
        //Divine
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
            return CAT_SPELL_HARMFUL;
        //Arcane
        //Level 0
        case SPELL_RESISTANCE:
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level

        //Divine
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
            return CAT_SPELL_BENEFICIAL;
        default:    //Assume any new spells are generally harmful
            return CAT_SPELL_HARMFUL;
    }
}

int GetSpellTargetOrLocation(int spell_id)
{
    switch (spell_id)
    {
        //Arcane
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
        //Divine
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
            return CAT_SPELL_AOE;
        //Arcane
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level

        //Divine
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
            return CAT_SPELL_SELF;
        //Arcane
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level

        //Divine
        //Level 0
        //Level 1
        //Level 2
        //Level 3
        //Level 4
        //Level 5
        //Level 6
        //Level 7
        //Level 8
        //Level 9
        //Epic Level
            return CAT_SPELL_TARGET;
        default:    //Unknown     
            return -1;
}


void main()
{
    object otarget = GetAttackTarget(OBJECT_SELF);
    if (! GetIsObjectValid(otarget))
        return;
    int spellID = GetLocalInt(OBJECT_SELF, "ELDRITCHSPELL");
    if (spellID == 0)   //Errored out
    {
        int classUse = GetLastSpellCastClass();
        int spellLevel = Random(GetCasterLevel(OBJECT_SELF) - 1) + 1; 
        spellID = GetKnownSpellId(OBJECT_SELF, classUse, spellLevel);
    }
    else
        spellID = spellID - 1;  //Need to add one to it so that Acid Fog is caught and not an error
    SpeakString("Spell Critical!");
    ActionCastSpellAtObject(spellID, otarget, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE, -1)
    //Add SpeakString or Message Send
}