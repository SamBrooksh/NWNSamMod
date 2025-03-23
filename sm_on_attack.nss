#include "nwnx_damage"
#include "nwnx_chat"
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
        if (GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oDamager) > 0)
        {
            
            if (nAtkRes == ATTACK_CRITICAL_HIT_VALUE)  
            {
                //Handle Spell Critical    
            }
        }

        if (GetLevelByClass(CLASS_TYPE_DUELIST, oDamager) > 0)
        {
            // Handle Precise Strike
            // Check if light 1 handed... Somehow
            
            item iHeld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager);
            item iOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDamager);
            
            int nBaseItem = GetBaseItemType(iHeld);
            int nOffhand = GetBaseItemType(iOffhand);
            if (nBaseItem != BASE_ITEM_INVALID && nOffhand == BASE_ITEM_INVALID)
            {
                int nWeaponType = StringToInt(Get2DAString("baseitem", "WeaponType", iHeld));
                if ((nWeaponType == 1 || nWeaponType == 4) && Get2DAString("baseitem", "WeaponWield", nBaseItem) != "0")
                {
                    data.iPierce += GetLevelByClass(CLASS_TYPE_DUELIST, oDamager);
                    //May also specify That this is happening somehow
                    //May need to check Damage Resistances somehow? Needs testing

                }   
            }

            if (nAtkRes == ATTACK_CRITICAL_HIT_VALUE && GetHasFeat(FEAT_CRIPPLING_CRITICAL, oDamager))  
            {
                //Handle Crippling Critical
                effect eCrit;
                int nCripChoice = GetLocalInt(oDamager, CRIPPLING_CRITICAL_LOCAL_NAME); 
                switch (nCripChoice)
                {
                    case CRIPPLING_CRITICAL_AC_PENALTY:
                        eCrit = EffectACDecrease(4);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        break;
                    case CRIPPLING_CRITICAL_BLEED_DMG:
                        //eCrit = Bleed
                        //implement complicated reoccuring bleed check - and hook in before turn maybe to check if healed?
                        //NWNX_ON_START_COMBAT_ROUND_BEFORE should be the event I think 
                        //Wound
                        //For now just treat as Dex Damage
                        //break;
                    case CRIPPLING_CRITICAL_DEX_DAMAGE:
                        eCrit = EffectAbilityDecrease(ABILITY_DEXTERITY, d4());
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        break;
                    case CRIPPLING_CRITICAL_STR_DAMAGE:
                        eCrit = EffectAbilityDecrease(ABILITY_STRENGTH, d4());
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        break;
                    case CRIPPLING_CRITICAL_SPEED_PENALTY:
                        eCrit = EffectMovementSpeedDecrease(75);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        break;
                    case CRIPPLING_CRITICAL_SV_THROW_PENALTY
                        eCrit = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        break;
                    default:
                        break; 
                }                
            }
        }

    }
    NWNX_SetAttackEventData(data);
}