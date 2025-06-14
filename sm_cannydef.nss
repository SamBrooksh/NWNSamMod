#include "sm_spellfunc"

void SMRemoveCannyDefBonus(object oTarget, int bPrintMesg = TRUE)
{
    if (bPrintMesg)
        SendMessageToPC(oTarget, "Losing Canny Defense Bonus");
    SMRemoveBuff(oTarget, SM_DUELIST_CANNY_DEFENSE);
}

void SMApplyCannyDefBonus(object oTarget)
{
    //PrintString("In Apply Canny Def Bonus");
    int nAmount = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
    if (nAmount > GetLevelByClass(CLASS_TYPE_DUELIST, oTarget))
        nAmount = GetLevelByClass(CLASS_TYPE_DUELIST, oTarget);
    if (nAmount < 1)
        return;

    effect eACBonus = EffectACIncrease(nAmount, AC_DODGE_BONUS);
    effect eTagEffect = TagEffect(eACBonus, SM_DUELIST_CANNY_DEFENSE);
    eTagEffect = UnyieldingEffect(eTagEffect);
    SMRemoveCannyDefBonus(oTarget, FALSE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTagEffect, oTarget);
}

void SMUpdateCannyDef(object oTarget)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    int nItemType = GetBaseItemType(oItem);
    int nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    //PrintString("AC: " + IntToString(nAC));
    if (nItemType == BASE_ITEM_ARMOR && nAC < 4)    //4 Is the first Medium armor
    {
        SMApplyCannyDefBonus(oTarget);
    }
    else 
    {
        SMRemoveCannyDefBonus(oTarget);
    }
}