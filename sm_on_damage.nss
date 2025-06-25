#include "nwnx_damage"
#include "sm_spellfunc"


int max(int num1, int num2);
//Returns the higher number
struct NWNX_Damage_DamageEventData ApplyEnergyResist(struct NWNX_Damage_DamageEventData data, int nAmount);
//Returns the modified DamageEventData after all resistances have been reduced by nAmount (down to 0)

void main()
{
    struct NWNX_Damage_DamageEventData data;
    data = NWNX_Damage_GetDamageEventData();

    object oDamager = data.oDamager;    //Attacker
    object oTarget = OBJECT_SELF;       //Getting hit
    
    if (GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oTarget))
    {
        //Handle Void Touched
        if (GetHasFeat(FEAT_ONE_WITH_THE_VOID, oTarget) && data.iCustom1 > 1)
        {
            //Apply Half damage before Damage resist
            data.iCustom1 = data.iCustom1 / 2;
        }
        if (GetHasFeat(FEAT_VOID_TOUCHED, oTarget))
        {
            int nDmgRed = 1;
            if (GetHasFeat(FEAT_VOID_STRENGTHEN, oTarget))
                { nDmgRed += VOID_STRENGTHEN_RES_BUFF_AMT; }
            
            PrintString("VOID_TOUCHED - REDUCING VOID DAMAGE");
            data = ApplyEnergyResist(data, nDmgRed);
        }
    }
    NWNX_Damage_SetDamageEventData(data);
}


int max(int num1, int num2)
{
    if (num1 > num2)
        return num1;
    return num2;
}

struct NWNX_Damage_DamageEventData ApplyEnergyResist(struct NWNX_Damage_DamageEventData data, int nAmount)
{
    
    if (data.iAcid > 0)
    {   data.iAcid = max(data.iAcid - nAmount, 0);  }

    if (data.iCold > 0)
    {   data.iCold = max(data.iCold - nAmount, 0);  }

    if (data.iDivine > 0)
    {   data.iDivine = max(data.iDivine - nAmount, 0);  }

    if (data.iElectrical > 0)
    {   data.iElectrical = max(data.iElectrical - nAmount, 0);  }

    if (data.iFire > 0)
    {   data.iFire = max(data.iFire - nAmount, 0); }

    if (data.iNegative > 0)
    {   data.iNegative = max(data.iNegative - nAmount, 0); }

    if (data.iPositive > 0)
    {   data.iPositive = max(data.iPositive - nAmount, 0); }
    
    if (data.iSonic > 0)
    {   data.iSonic = max(data.iSonic - nAmount, 0); }

    if (data.iCustom1 > 0)  //VOID
    {   data.iCustom1 = max(data.iCustom1 - nAmount, 0); }

    /*
    // I won't complete these now but maybe should do it later  
    if (data.iCustom2 > 0)  
    {   data.iCustom2 = max(data.iCustom2 - nAmount, 0); }
    
    if (data.iCustom2 > 0)  
    {   data.iCustom2 = max(data.iCustom2 - nAmount, 0); }
    */
    return data;
}

/*struct NWNX_Damage_DamageEventData ApplyDamageReduction(struct NWNX_Damage_DamageEventData data, int nDRLevel, int nDRAmount)
{
    
    return data;
}
//Maybe Try to apply this - but looks like there isn't a way to get the DRLevel or Power Level
//I may try to rework DR eventually - but probably not now
*/
