//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 15th, 2008
//:: Added Support for Mounted Archery Feat penalties
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "x3_inc_horse"
#include "sm_cannydef"

void main()
{

    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();
    // -------------------------------------------------------------------------
    // Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC,oItem);
        // prevent players from reequipping their weapon in
        if (IWGetIsInIntelligentWeaponConversation(oPC))
        {
                object oConv =   GetLocalObject(oPC,"X2_O_INTWEAPON_SPIRIT");
                IWEndIntelligentWeaponConversation(oConv, oPC);
        }
        else
        {
            //------------------------------------------------------------------
            // Trigger Drain Health Event
            //------------------------------------------------------------------
            if (GetLocalInt(oPC,"X2_L_ENSERRIC_ASKED_Q3")==1)
            {
                ExecuteScript ("x2_ens_dodrain",oPC);
            }
            else
            {
                IWPlayRandomEquipComment(oPC,oItem);
            }
        }
    }

    // -------------------------------------------------------------------------
    // Mounted benefits control
    // -------------------------------------------------------------------------
    if (GetWeaponRanged(oItem))
    {
        SetLocalInt(oPC,"bX3_M_ARCHERY",TRUE);
        HORSE_SupportAdjustMountedArcheryPenalty(oPC);
    }

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }

    // -------------------------------------------------------------------------
    // Sam Mod Item Equippment needed
    // 
    // -------------------------------------------------------------------------
    if (GetWeaponRanged(oItem) || IPGetIsMeleeWeapon(oItem))
    {
        if (GetHasFeat(FEAT_VOID_STRIKE, oPC))
        {
            int level = GetLevelByClass(CLASS_TYPE_VOID_SCARRED, oPC);
            itemproperty addScriptToWeapon = ItemPropertyOnHitCastSpell(SPELL_CURSED_STRIKE, level);
            addScriptToWeapon = TagItemProperty(addScriptToWeapon, CONST_VOID_STRIKE_ITEM_TAG);
            AddItemProperty(DURATION_TYPE_PERMANENT, addScriptToWeapon, oItem);
        }
    }
}
