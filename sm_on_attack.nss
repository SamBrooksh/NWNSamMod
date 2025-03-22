#include "nwnx_damage"
#include "sm_spellfunc"

const int ATTACK_HIT_VALUE = 1;
const int ATTACK_AUTOMATIC_HIT_VALUE = 7;
const int ATTACK_DEVASTATING_CRIT_VALUE = 10;
const int ATTACK_CRITICAL_HIT_VALUE = 3; //Just a hardcoded number

void main()
{
    struct NWNX_Damage_AttackEventData data = NWNX_Damage_GetAttackEventData();
    int nAtkRes = data.iAttackResult; 
    if (nAtkRes == ATTACK_HIT_VALUE 
    || nAtkRes == ATTACK_AUTOMATIC_HIT_VALUE 
    || nAtkRes == ATTACK_DEVASTATING_CRIT_VALUE 
    || nAtkRes == ATTACK_CRITICAL_HIT_VALUE)
    {
        if (GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oDamager))
        {
            //Handle Spell Critical
            if (nAtkRes == ATTACK_CRITICAL_HIT_VALUE)  
            {

            }
        }

    }
}