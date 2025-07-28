#include "nwnx_damage"
#include "nwnx_chat"
#include "sm_spellfunc"

const int ATTACK_HIT_VALUE = 1;
const int ATTACK_AUTOMATIC_HIT_VALUE = 7;
const int ATTACK_DEVASTATING_CRIT_VALUE = 10;
const int ATTACK_CRITICAL_HIT_VALUE = 3; //Just hardcoded numbers

void DeleteAttackInt(string uses, string onAttack, object oDamager, string display) 
{
    DeleteLocalInt(oDamager, onAttack);
    int nUses = GetCampaignInt(SM_DB_NAME, uses, oDamager);
    SpeakString(IntToString(nUses - 1) + " " + display + " Uses left", TALKVOLUME_WHISPER);
    if (nUses > 0)
    {
        SetCampaignInt(SM_DB_NAME, uses, nUses - 1, oDamager);
    }
}

void main()
{
    struct NWNX_Damage_AttackEventData data = NWNX_Damage_GetAttackEventData();
    int nAtkRes = data.iAttackResult;
    object oDamager = OBJECT_SELF;
    
    //Hits
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
                ExecuteScript("sm_eld_spellcrit", OBJECT_SELF);
            }
        }
        if (GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oDamager) > 0)
        {
            if (GetHasFeat(FEAT_VOID_STRIKE, oDamager))
            {
                //PrintString("Moved this here now");
                data.iCustom1 += SMVoidStrike(oDamager, data.oTarget);
            }

            if (GetLocalInt(oDamager, CONST_VOID_SCORN_NEXT_ATTACK) > 0)
            {
                int nRounds = d6(2);
                //SpeakString("Applying Void Scorned for " + IntToString(nRounds) + " Rounds");
                SMApplyVoidScorned(data.oTarget, oDamager, nRounds);
                DeleteAttackInt(CONST_USES_VOID_SCORN, CONST_VOID_SCORN_NEXT_ATTACK, oDamager, "Void Scorn");
            }

            if (GetLocalInt(oDamager, CONST_VOID_CONSUME_NEXT_ATTACK) > 0)
            {
                int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oDamager);
                // Should give the target a chance to save from this
                //SpeakString("Applying Void Consumed for " + IntToString(nLevel) + " Rounds");
                SMApplyVoidConsumed(data.oTarget, oDamager, nLevel);
                DeleteAttackInt(CONST_USES_VOID_CONSUMED, CONST_VOID_CONSUME_NEXT_ATTACK, oDamager, "Void Consume");
            }

            if (GetLocalInt(oDamager, CONST_CURSED_STRIKE_NEXT_ATTACK) > 0)
            {
                int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oDamager);
                int nDC = 10 + GetAbilityModifier(ABILITY_INTELLIGENCE, oDamager) + GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oDamager) / 2;
                if (!MySavingThrow(SAVING_THROW_FORT, data.oTarget, nDC, SAVING_THROW_TYPE_NONE, oDamager, 0.0))
                {
                    SMApplyCursedStrikes(data.oTarget, oDamager);
                }
                DeleteAttackInt(CONST_USES_CURSED_STRIKE, CONST_CURSED_STRIKE_NEXT_ATTACK, oDamager, "Cursed Strike");
            }

            if (GetLocalInt(oDamager, CONST_SAP_STRIKE_NEXT_ATTACK) > 0)
            {
                int nLevel = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oDamager);
                // Should give the target a chance to save from this
                //SpeakString("Applying Void Consumed for " + IntToString(nLevel) + " Rounds");
                SMApplySappingStrike(oDamager, data.oTarget);
                DeleteAttackInt(CONST_USES_SAPPING_STRIKE, CONST_SAP_STRIKE_NEXT_ATTACK, oDamager, "Sapping Strike");
            }

            //If attacker is a clone - handle on hit
            if (GetTag(oDamager) == VOID_CLONE_TAG || GetTag(oDamager) == VOID_CLONE_TAG_2)
            {
                //PrintString("Clone is attacking/and hit");
                object oMaster = GetMaster(oDamager);
                SMCloneAttack(oDamager, data.oTarget, oMaster);
            }

        }
        if (GetLevelByClass(CLASS_TYPE_DUELIST, oDamager) > 0)
        {
            // Handle Precise Strike
            // Check if light 1 handed... Somehow
            // Should prevent if damager is immune to crits
            //SpeakString("In on attack");
            object iHeld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager);
            object iOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDamager);

            int nBaseItem = GetBaseItemType(iHeld);
            int nOffhand = GetBaseItemType(iOffhand);
            //SpeakString(IntToString(nBaseItem) + " : " + IntToString(nOffhand));
            if (nBaseItem != BASE_ITEM_INVALID && nOffhand == BASE_ITEM_INVALID)
            {
                //SpeakString("Second");
                int nWeaponType = StringToInt(Get2DAString("baseitems", "WeaponType", nBaseItem));
                //SpeakString(IntToString(nWeaponType) + ": Weapon Type");
                if ((nWeaponType == 1 || nWeaponType == 4) && Get2DAString("baseitems", "WeaponWield", nBaseItem) != "0" && StringToInt(Get2DAString("baseitems", "RangedWeapon", nBaseItem)) < 1)
                {
                    int nExtraDamage = GetLevelByClass(CLASS_TYPE_DUELIST, oDamager);
                    data.iPierce += nExtraDamage;
                    //May also specify That this is happening somehow
                    //May need to check Damage Resistances somehow? Needs testing
                    //SpeakString("Duelist Extra Damage Worked! " + IntToString(nExtraDamage));
                }
            }

            if (nAtkRes == ATTACK_CRITICAL_HIT_VALUE && GetHasFeat(FEAT_CRIPPLING_CRITICAL, oDamager))
            {
                //Handle Crippling Critical
                effect eCrit;
                int nCripChoice = GetLocalInt(oDamager, CRIPPLING_CRITICAL_LOCAL_NAME);
                nCripChoice = d6();
                // I think I'll just make this random?
                switch (nCripChoice)
                {
                    case CRIPPLING_CRITICAL_AC_PENALTY:
                        eCrit = EffectACDecrease(4);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        PrintString("CRIPPLING_CRITICAL HIT WITH AC DAMAGE");
                        break;
                    case CRIPPLING_CRITICAL_BLEED_DMG:
                        PrintString("CRIPPLING_CRITICAL HIT WITH BLEED DAMAGE");
                        //eCrit = Bleed
                        //implement complicated reoccuring bleed check - and hook in before turn maybe to check if healed?
                        //NWNX_ON_START_COMBAT_ROUND_BEFORE should be the event I think
                        //Wound
                        //For now just treat as Dex Damage
                        //break;
                    case CRIPPLING_CRITICAL_DEX_DAMAGE:
                        eCrit = EffectAbilityDecrease(ABILITY_DEXTERITY, d4());
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        PrintString("CRIPPLING_CRITICAL HIT WITH DEX DAMAGE");
                        break;
                    case CRIPPLING_CRITICAL_STR_DAMAGE:
                        eCrit = EffectAbilityDecrease(ABILITY_STRENGTH, d4());
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        PrintString("CRIPPLING_CRITICAL HIT WITH STR DAMAGE");
                        break;
                    case CRIPPLING_CRITICAL_SPEED_PENALTY:
                        eCrit = EffectMovementSpeedDecrease(75);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        PrintString("CRIPPLING_CRITICAL HIT WITH MOVEMENT DAMAGE");
                        break;
                    case CRIPPLING_CRITICAL_SV_THROW_PENALTY:
                        eCrit = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrit, OBJECT_SELF, RoundsToSeconds(10));
                        PrintString("CRIPPLING_CRITICAL HIT WITH SAVE DAMAGE");
                        break;
                    default:
                        PrintString("CRIPPLING_CRITICAL Hit and used, but no VALUE"+IntToString(nCripChoice));
                        break;
                }
            }
        }
    }
    else    // Missed attacks 
    {
        //Void Consume
        if (GetLocalInt(oDamager, CONST_VOID_CONSUME_NEXT_ATTACK) > 0)
        {
            SpeakString("Void Consumed Missed!");            
            DeleteAttackInt(CONST_USES_VOID_CONSUMED, CONST_VOID_CONSUME_NEXT_ATTACK, oDamager, "Void Consume");
        }
        //Sapping Strike
        if (GetLocalInt(oDamager, CONST_SAP_STRIKE_NEXT_ATTACK) > 0)
        {
            SpeakString("Sapping Strike Missed!");            
            DeleteAttackInt(CONST_USES_SAPPING_STRIKE, CONST_SAP_STRIKE_NEXT_ATTACK, oDamager, "Sapping Strike");
        }
        //Cursed Strikes
        if (GetLocalInt(oDamager, CONST_CURSED_STRIKE_NEXT_ATTACK) > 0)
        {
            SpeakString("Cursed Strikes Missed!");            
            DeleteAttackInt(CONST_USES_CURSED_STRIKE, CONST_CURSED_STRIKE_NEXT_ATTACK, oDamager, "Cursed Strikes");
        }
        //Void Scorn
        if (GetLocalInt(oDamager, CONST_VOID_SCORN_NEXT_ATTACK) > 0)
        {
            SpeakString("Void Scorn Missed!");            
            DeleteAttackInt(CONST_USES_VOID_SCORN, CONST_VOID_SCORN_NEXT_ATTACK, oDamager, "Void Scorn");
        }
    }
    NWNX_Damage_SetAttackEventData(data);
}