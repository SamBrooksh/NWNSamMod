//::///////////////////////////////////////////////
//:: Isaacs Greater Missile Storm
//:: x0_s0_MissStorm2
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 20 missiles, each doing 3d6 damage to each
 target in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "sm_spellfunc"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    
    int spellReaction = FALSE;
    if (GetHasFeat(FEAT_SPELL_REACTION, OBJECT_SELF))
    {
        if (d20(1) == 20)
        {
            SpeakString("Spell Reaction!", 1);
            spellReaction = TRUE;
        }
    }

    DoMissileStorm(2, 20, SPELL_ISAACS_GREATER_MISSILE_STORM, VFX_IMP_MIRV, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, FALSE, FALSE, spellReaction);
}


