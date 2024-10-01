#include "nwnx_events"

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