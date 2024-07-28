const int CLASS_MAX = 8;

//Return TRUE if is an arcane class 
int SM_isArcane(int class)
{
    //TODO:
    return TRUE;
}

//Return TRUE if is divine class
int SM_isDivine(int class)
{
    //TODO:
    return TRUE;
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
                else if (SM_isDivine(pClass) && arcaneDivine == DIVINE)
                {
                    total += GetLevelByClass(pClass, oCaster);
                }
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