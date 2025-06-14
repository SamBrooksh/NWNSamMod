List of how to do things:


# VOID SCARRED
Void Clone attack - make weapon with tag s2cloneatk - hook all scripts into that

DR/1 Energy Resist 1 (Void Touched) - Make handle damage script - check for local variables (VOID_RESIST/DR 1) subtract that damage off the result I think

Debuffs should mostly be the same with how
Void Shadowed, Void Cloak, Void haste should be very easy (essentially same scripts but cast from feat - Then handle how many uses they have with local ints)

One with the Void - in the damage script have ONE_WITH_THE_VOID occur before the Void touched, but same concept

Void Perfection should be easy

Change Targeting on clone to just execute the spell(effect) instead of target

## HARDEST TO DO - void clone attack and properly handling damage script

# Eldritch Knight

Get the custom spells to be used instead of default

- [x] Have Arcane spellcaster learn spells when levelling

- [x] Spell Critical - SetAttackEventScript - (Same script concept - should use different and have multiple  as the One with the Void to trigger the various things) will need quite a bit of logic to identify which target to do

Make sure the spells use the updated Spellcaster level

# Mystic Theruge

Check to see if I can limit class chosen with NWNX (requiring 2nd level divine and arcane spellcasting)

Combined Spells seems like more of a pain than worth for now...
Scripts for Spell Synthesis (I think I have a base idea - I don't think that I need NWNX for this)

# Duelist

Change how Precise Strike functions - In the damage script (Same as Spell critical and the like) check to see if 
Duelist, with 1 hand 