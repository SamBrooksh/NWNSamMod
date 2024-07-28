#include "sm_constants"

void PreciseStrikeBonus(object oPlayer)
{
    object oTarget = GetAttemptedAttackTarget();
    //SendMessageToPC(GetFirstPC(), "Attacking: "+GetName(oTarget));
    //SendMessageToPC(GetFirstPC(), "Is attacking: "+GetName(oPlayer));


    object withWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPlayer);
    //int baseItem = GetBaseItemType(withWeapon);
    //GetHasFeat GetItemHasItemProperty-maybe GetClassByPosition
    //1 is Piercing
    if (GetHasFeat(FEAT_PRECISE_STRIKE, oPlayer) > 0 &&
        WeaponType(withWeapon) == 1 && GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) == 0)
    {
        int nDamage1 = GetLevelByClass(CLASS_TYPE_DUELIST); //Duelist
        effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_PIERCING);
        eDamage1 = SupernaturalEffect(eDamage1);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage1, oPlayer);
    }
}