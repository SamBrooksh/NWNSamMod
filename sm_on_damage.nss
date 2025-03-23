#include "nwnx_damage"
#include "sm_spellfunc"


void main()
{
    struct NWNX_Damage_DamageEventData data;
    data = NWNX_Damage_GetDamageEventData();

    object oDamager = data.oDamager;    //Attacker
    object oTarget = OBJECT_SELF;       //Getting hit

    
    if (GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oTarget))
    {
        //Handle Void Touched
        if (GetHasFeat(FEAT_VOID_TOUCHED, oTarget))
        {
            if (data.iCustom1)  //VOID
        }
    }

    NWNX_Damage_SetDamageEventData(data);
}