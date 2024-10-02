const int CLASS_MAX = 8;
const int FEAT_SPELL_REACTION = 1149;

//Return TRUE if is an arcane class 
int SM_isArcane(int class)
{
    switch(class)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
        
        //Add the additional classes here
        //case CLASS_PRES_PALE_MASTER:
        //case CLASS_TYPE_MYSTIC_THEURGE:
        //case CLASS_TYPE_ELDRITCH_KNIGHT:
            return TRUE;
        default:
            return FALSE;
    }
}

//Return TRUE if is divine class
int SM_isDivine(int class)
{
    switch(class)
    {
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:

        //Add the additional classes here
            return TRUE;
        default:
            return FALSE;
    }
}

//Returns the modified level for spells
//class should be 0 for Arcane, and 1 for Divine I think
int SM_GetCasterLevel(object oCaster, int arcaneDivine)
{
    const int ARCANE = 0;
    const int DIVINE = 1;
    int total = 0;
    //Only doing if more than one class
    if (GetClassByPosition(oCaster, 2) != CLASS_TYPE_INVALID)
    {
        for (int i = 0; i < CLASS_MAX; i += 1)  //May change if 
        {
            //Go through and add the various levels of arcane if class is arcane, and divine if divine
            int pClass = GetClassByPosition(i, oCaster);
            if (pClass != CLASS_TYPE_INVALID)
            {
                //Arcane Spellcaster
                if (SM_isArcane(pClass) && arcaneDivine == ARCANE)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                //Divine Spellcaster
                else if (SM_isDivine(pClass) && arcaneDivine == DIVINE)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
                //Check for Prestige Classes Modifications
                else 
                {
                    if (arcaneDivine == ARCANE)
                    {
                        string ArcaneSpellMod = Get2DAString("classes", "ArcSpellLvlMod", pClass);
                        int ArcBonus = StringToInt(ArcaneSpellMod);
                        if (ArcaneSpellMod != "" && ArcBonus > 0)
                        {
                            total += (GetLevelByClass(pClass, oCaster) + ArcBonus - 1) / ArcBonus;
                        }
                    }
                    else
                    {
                        string DivineSpellMod = Get2DAString("classes", "DivSpellLvlMod", PClass);
                        int DivBonus = StringToInt(DivineSpellMod);
                        if (DivineSpellMod != "" && DivBonus > 0)
                        {
                            total += (GetLevelByClass(pClass, oCaster) + DivBonus - 1) / DivBonus;
                        }
                    }
                    
                }
            }
            else    //Break out a little early
                return total;
        }
    }
    return total;
}

// Returns the updated damage if the caster used Maximize or Empower
//Needs max in case of Maximize - otherwise just assumes 6 arbitraily
int SM_Maximize_Or_Empower(object oCaster, int feat, int damage, int max = 6)
{
    if (feat == METAMAGIC_MAXIMIZE)
        return max;
    if (feat == METAMAGIC_EMPOWER)
        return damage * 1.5;
    return 0;
}

//Returns the Extended amount of a spell if the extended feat
//Should be able to call regardless
int SM_Extended(object oCaster, int feat, int duration)
{
    if (feat == METAMAGIC_EXTEND)
        return duration * 2.0;
    return duration;
}