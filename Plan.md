# Classes
Duelist
Mystic Theurge
Eldritch Knight
Updating Arcane Archer to increase Arcane Spell usage - Also get new spells (should be able to add that to all when done)

Then I will make my own with custom stuff completely
# Other Changes
Add more poisons (or just poisons in general)

# GENERAL TODO
Create Packages from classes
Add TLK Table entries
Saving Throw As well
Find more Icons

Modify nwscript.nss so that I can make it do getcasterlevel properly
It may be better to create a new function for getcasterlevel(which) so it can get total of Divine or Arcane (or any other is I were to make it, or both for overlapping spells) - I think doing this will be smarter
This would allow for the modification of all the other spells rather easily - looks like may need to account for level loss as well?
Should also add a metamagic function (one that applies all metamagic stuff) - would actually be a couple - one for each effect change I believe

# Duelist
## TODO
Fill in stat file, make scripts for Precise Strike, and Canny Defense
Design Enhanced Mobility, Add Parry Bonus Feat
### Prerequisites
#### BAB 
+6
#### Skills
Tumble 5 ranks, Preform 5 Ranks
#### Feats
Dodge, Mobility, Weapon Finesse
### Class Skills
4 + INT
Tumble, Bluff, Listen, Spot, Search, Perform, Lore, Move Silently, Discipline
### BAB Rate
Fast
### Abilities

#### 1st Level
Precise Strike - While using a light 1 handed weapon and no shield, add duelist level to damage (Unless immune to crits) - looks like the easiest will probably the hacky way of on-hit scripts - just using NWNX actually
Canny Defense - When wearing light or no armor, add INT to AC (up to max of Duelist Level)
#### 2nd Level
Expert Parry - Bonus to Parry at Level 2 - Skill Focus?
#### 3rd Level
Enhanced Mobility - Gain bonus to AoO (check to see if possible - if not, may rework)
#### 4th Level
Grace - Gain +2 to Reflex - Gain Lightning Reflex instead - maybe make Grace do something else and can be taken as bonus feat?
#### 5th Level
Riposte - Should make AoO after parrying... do more research into if this is possible or what - if not change what it does - Improved Parry For now
#### 6th Level
Acrobatic Charge - Bonus to Tumble? Should be bonus against difficult terrain so maybe get freedom?
#### 7th Level
Bonus To Parry and AC I think
Should be Elaborate Defense (which is sorta lame)
#### 8th Level

#### 9th Level
Deflect Arrows - Requires a light or one handed piercing weapon (Check to see if can add deflect arrows to be able to do that - Looks like can just give deflect arrows)
No Retreat - Maybe an Additional BAB increase? (Should be force enemies to provoke an attack... Seems doubtful to be able to occur)
#### 10th Level
Crippling Critical - Able to deal a penalty to target on crit (reduce speed to 10ft, 1d4 STR or DEX dmg, -4 to saving throws, -4 penalty to AC, or 2d6 bleed dmg - last 1 minute) - Probably should use some radial option to choose which one to be used in general. Should be able to with NWNX
Looks like speed reduction is percent based - so I'll make it 75% for now (about the same against 30ft move - albeit a bit better, worse against faster, but shouldn't be too big of a deal)

### Bonus Feats
8th Level only I think

### Stats
Gain Intelligence Every other level (I believe that I had been doing this with a feat - should be able just with a Table)
Improved Reaction - Gain +1 To dex every third level (can't do bonus to initiative)

## Scripts Needed
OnHit changed - deal damamge, handle crippling critical


# Mystic Theruge
# TODO
Add all necessary files (Skill list, bonus feat list, Package list, prereqs), TLK Entries (feat/description)
Design Abilities - Maybe make the divine/arcane spells manually at a higher level and make it so that the class gets access to them? 

### Prerequisites
Able to cast 2nd level divine and arcane spells - May need to change, sounds like you can't do the divine spell requirement easily, and probably won't be able to do it 
Will be Level 2 Arcane caster, and then Cleric, Druid, and able to cast level 3 spells - so technically could be lvl5 wiz, lvl1 cleric
Can't get it any closer though - And add Lore 8 just to make sure they are at least level 5

#### Alignment
Any

#### Skills
Lore 8 Ranks

### Class Skills
2 + INT
Lore, Spellcraft, Heal, Concentration, Appraise, Crafts (ADD MORE)

### BAB Rate
Slow

### Abilities
May give bonus feats every other level instead of combined spells?
Also will want to a on level up script that starts a dialog with the player that lets them learn a spell for their arcane classes I think...
#### 1st Level
Combined Spells - Allow spells to learn from other?
#### 2nd Level
#### 3rd Level
Bonus Feat
#### 4th Level
+1 Wis
#### 5th Level
#### 6th Level
+1 Int/Cha
#### 7th Level
Bonus Feat
#### 8th Level
#### 9th Level
#### 10th Level
Spell Synthesis - Somehow need to let creation of putting two spells into one? (And then make it so it can go up a level every other level)
May need to do as ability, then choose two spells somehow as well - I think I should be able to do this one using the castactionspell with instant spell on - probably will need a dummy feat or two? - this will probably be a hassle to do fast...
### Bonus Feats
Probably do at like 4 and 8 - something to help at least - Doing 3rd and 7th

### Stats
Maybe bonuses to INT/CHA/WIS? - Adding +1 Wis at 4th, and +1 Int/Cha at 6th

# Eldritch Knight
# TODO
- [x] Create Menu for Spell Critical - Should be done - needs testing
- [x] Create NWNX effects to let Sorcerer and Wizard learn spells when leveling up - Should be done
Should be completely functional 

### Prerequisites
#### Alignment
Any
#### Skills
Cast 3rd level arcane
Martial Proficiency
### Class Skills
Lore, Ride, Spellcraft, Concentration, Discipline, Parry, Craft Armor, Craft Weapon
2 + INT
### BAB
1
### Abilities
#### 1st Level
Diverse Training - May not be possible - Looks like just not needed I think, So something to replace this (Maybe just another feat)
Bonus Feat 
#### 2nd Level
INT/CHA UP
#### 3rd Level
STR/DEX UP
#### 4th Level
Gain DR 1?
#### 5th Level
Bonus Feat
#### 6th Level
INT/CHA
#### 7th Level
STR/DEX UP
#### 8th Level
Bonus Feat
#### 9th Level
Spell's can deal critical damage (double damage) -Maybe- Calling it Spell Reaction for now
#### 10th Level
Spell Critical - Looks Like should be possible with spell hooks... maybe - Should be quite doable with NWNX, but also needs to manage the spells that create other spells appropriately - That may harder to manage (so start with just getting magic missile to work, then delayed fireball - and that should be enough I think? -Maybe not needed actually)
### Bonus Feats
At 1st, 5th and 8th (So that 9th gets Spell critical instead)
### Stats
I think increases to str/dex and int/cha both by 1, just twice
## Scripts Needed
Technically spell critical is on making a critical, cast a spell - so I may make a level 9 do the potential double damage, and then a script on level 10 try to cast a predefined spell on a critical
So - Feat that allows for choosing a spell to cast on crits (beneficials will be on self, bad on enemy) - choosing the feat in the radial menu will start a dialog asking what type spell to choose (with the list of known possible spells)
First need to test if there is an instant cast of spell scripts - closeish, should be effective enough I think

# Void Scarred
Useful icons ir_gengaze ir_genaura ir_genbolt ir_dcaster ir_elefire
ife_exturn ife_fpersuade ife_unpossess ife_x1adabj ife_x1hailarr
ife_x1sevade ife_x1precise ife_x2dethmast ife_x2udshp ife_x3_pdkwrath
is_magvest is_enedrain is_x1onelan
All flavor text/names still pending of course
#### Alignment
Any Chaotic

### Class Skills
Disable Trap, Heal, Hide, Listen, Lore, Move Silently, Open Lock, Search, Set Trap, Use Magic Device, Tumble, Craft Trap, Bluff, Intimidate, Craft Armor, Craft Weapon
I'm thinking 6 + INT - Changing to 4 since INT should help with the others
### BAB
3/4 - Rogue speed

### HD
D4 I think - but may need to may it D6 if they are too squishy
### Abilities
#### 1st Level
Weapon Finesse
#### 2nd Level
Void Clone - Suffer a penalty to summon a clone that does less dmg and a debuff - It gets bonus damage from player INT (Debuff is -4 STR, -3 CON, -2 REF/WILL/FORT, -3 CHA, until Clone is unsummoned - may too big of a debuff - maybe have it deal 1 void dmg to player every couple of rounds - that seems a bit extreme)- Once per day, lasts until unsummoned I think

Relogging causes Clone to unsummon

Clone has 1/2 hp(Currently at 75% for the moment), and does 1d4+INT dmg - Same AC
#### 3rd Level
Void Strike - After hitting an enemy with melee weapon, deal 1/3 Void Scarred Level in void damamge - if they are fading, deal Level instead
Currently does with all weapons... not just melee weapons - should probably make it roll for damage depending on level (like 1/3 level d2, then make the deft damage give int bonus and up it to d3 or d4 (depending on situation))
#### 4th Level
Evasion
#### 5th Level
Void Swap - Swap positions with Void clone - May drop this, and replace with a temporary boost to clone and personal stats 
#### 6th Level
Gain DR/1 and Energy Resist 1 - Void Touched
###### I am not sure if I want to apply it through an effect or with NWNX - Have both setup
###### Going to stick with NWNX for now except for Damage Resistance 
#### 7th Level
Ability to cast Invisibility 2 + INT times/day - Void Hidden
#### 8th Level
Ability to cast Haste 1 + INT times/day - Void Haste
#### 9th Level
Void Shadowed - Ability to cast Incorporeal 1 + INT times/day
- Need to figure out what to do - can really only do miss chance
Currently have it 40%

#### 10th Level
Void Renewall - Clone grants temp HP to player on it dealing damage - For now going to try doing it with effects and just be 2d6 temp hit points for 1 minute
#### 11st Level
Void Assimilation - Reduce the Penalty of summoning a clone - -1 REF/WILL/FORT -2 STR -1 CHA?
#### 12nd Level
Curse (Consumed by Void) - Clone attempts to Void Curse on hit (lower DC), player can activate it 3+INT number of times
Lasts for 1 round per Void Scarred level - Currently using it the same way as Void Scorn - Click to apply on next attack - should probably make it an attempt (should probably also allow the target a save)
Referred to as Void Consumed
#### 13rd Level
Void Hop = Short Range Teleport (Essentially Spell - with small penalty) 1 + INT times - May rework - Currently haven't implemented
Void Scorn - Target Debuff for a while (Clone has small chance to try and apply) 1 + INT times per day (handled completely behind the scenes) - Consumes a use when applied
#### 14th Level
Reinvigorate - Remove Fading from target to get buffs
+4 DEX + STR - 2*LVL temp HP +2 Fort/Will/Ref for 2*lvl rnds
Heal To Full as well? (For now)
#### 15th Level
Sapping Strkes - Clone's on hit attempts to apply a Fort reduction debuff, Player can attempt as well currently just 1+INT I think uses
DC 10 + VoidScarred Level + INT mod for now - Duration 1/round per level
#### 16th Level
Impending Void - Player can deal massive dmg (1d6 per level) to target with Curse, Fading and Void Scorn other debuff VOID damage
This gives the Void Scarred the ability to deal massive damage to Target with Curse, FADING, and Void Scorn VOID damage. The damage is a number of 1d4 equal to the Void Scarred Level * number of debuffs applied.
#### 17th Level
One with the Void - Take half damage from Void Sources
#### 18th Level
Void Rip - AoE Fireball like spell that does Void and applies Curse - Clones Immune 1 + INT/2 times
#### 19th Level
Deft Damage - Void Strike empowered - 1/2 level, 3/2*level - both increased by INT
#### 20th Level
Can Summon 2 Clones (Maybe?) - they get full HP, Full Stats, instead of decreased stats - Void Perfection
### Bonus Feats Options
Cursed Strikes - After Delay, deal massive damage - also increases Impending Void dmg to be 1d6+1d4 (Min Level 16) - DC should probably be 1/4 level + 2*Int? or just half level + int. Also will probably have it act the same way as the other on hit attacks
Gain more DR/Energy Resist (Min Level 10) - Void Strengthen
Empower Void Clone - Gives Flat HP bonus per time taken? LVL 3
Extra Haste, Incorporeal, Invis (Maybe all in one) - 2 Extra? LVL 11
Void Resist - Reduce Debuff from Void Clone LVL 3 - Make it so that it buffs them if has Void Perfection
Void Missile - 1+INT uses like Magic Missle but void LVL 3
Extra Void Missle - Gain 3 Charges LVL 5 - currently doing it just in 2da, may need to change it so it doesn't change name
Crackling Missiles - Void Missle applies Fading Debuff LVL 7
Clone Copy - Clones cast Void missle (with all feats) as well LVL 13
Null Missile - Void Missile applies Void Scorn LVL 13 1 round per missile that failed saves
Fade Out - After getting hit, gain AC Bonus for a short time (1 round) LVL 7    - Maybe a different colored mage armor
Improved Fade Out - Larger Bonus, Longer time (INT MOD rounds) LVL 11
Void's Hatred - Increases the chance that Clones try to apply Void Scorn LVL 13
Ravaging Swap - Deal Void Damage to creatures between Clone and Player - 1d10 + INT per 3 levels LVL 9?
Empowering Swap - Gain Buff (Clone and Player) After Swapping for short time (+2 Atk Bonus, +10 temp HP, +10% to random modifiers - like clone applying debuffs?, +LVL to Void Damage for INT MOD turns) LVL 5

Other Possible feats:
When casting the Haste, Incorporeal, invis - it also effects the void clones?
Ways to buff the Void Renewall buff? Maybe heal and gain hp? Way to give more defense to clones?


Fading DC 10 + INT + 1/4 lvl (maybe 1/2) target suffers HD void dmg max HD amount/2 turns (possible only 2)
Consumed By Void - DC 10 + Reapply Fading every so often (no save)
Void Scorned Debuff -2 Will, AC, STR, DEX, Reflex
### Scripts Needed
Pretty much a script for all the abilities
Modify On hit to check if Attacker is Void Scarred or Clone

### Other modifications
Add Void Energy type

Currently no way to apply fading straight debuff... Should do something about that (Maybe on crit it applies at some point)
Has to have consumed by void apply it the fading as is (which is only 2 turns or so of it) - I may do it that they get it all back after combat... but that does mean there would be some exploits... - I think I have it working well now

Some thoughts: Shouldn't have void hop - and we will see how effective void swap or viable it is. May be too unwieldy (and may not be worth it unless, the ravaging swap is built in)
Probably should move around some of the feats - Like the miss chance to later, and one of the damaging to earlier

### Stats



# OUTLINE
### Prerequisites
#### Alignment

#### Skills

### Class Skills

### BAB

### Abilities
#### 1st Level

#### 2nd Level
#### 3rd Level
#### 4th Level
#### 5th Level
#### 6th Level
#### 7th Level
#### 8th Level
#### 9th Level
#### 10th Level

### Bonus Feats


### Stats



# 5/25/2025 Todo List To "Completion"

- [x] Make Spell Radial Menu for Spell Synthesis
Note that I have a spell synthesis feat that is unused right now
    - [x] Test as well - execution by using it
    - [ ] Needs more conclusive testing - Healing Spells need a check for sure
- [ ] Spell Menu Feat for Spell Critical (Able to choose)
    - [ ] Test - Needs lots of testing
- [x] Figure out Spell Reaction (Nat 20 rolls) for dealing bonus damage - May need to double check that the spells are written correct and the like
    - [ ] May want to rewrite using nwnx for damage for all of them
- [ ] Check and Fine Tune Duelist
- [ ] Fill out TLK fields
- [x] Figure out Void Scarred debuffs - rewrite them with nwnx
    - [x] Would probably be smart to make only one (void scorn or void curse) be able to be applied at one time (On next attack) - or that it can only do one
    - [x] Void Scorn (And test)
    - [x] Void Curse (Consumed by Void) Needs testing - I think it works? Needs better graphics though
    - [x] Cursed Strikes 
    - [x] Void Fading - probably should make it work if the creator dies or the like... I think it should be fine for now... also should see if it works with xp
- [ ] Get Learning Spell working, change where database is and persist between

## Prettifying/Polishing touches
- [ ] Prettify Learn Spells - scrollbars, proper size, prevent window close?
- [ ] Prettify Spell Synthesis Gui (Auto detect size)
- [ ] Make Gui to show duration of a debuff? This may be a pain to do though...
- [ ] Rest of Void Scarred Feat/Abilities
- [ ] Color Void clones to dim purple
- [ ] Void Scarred Ability visual/sound effects
    - [ ] Each ability should have a row here
- [ ] TLK formatting look nice etc
- [ ] Packages for all the classes, and a couple for Void Scarred
- [ ] Saving Location/Entering Exit is handled like a normal save game
    - [ ] Same location, enemies/characters dead etc
