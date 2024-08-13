#Extend Metamagic
# if (nMetaMagic == METAMAGIC_EXTEND)
# {
#       nDuration = nDuration * 2; //sometimes no spaces
# }
#
#Maximize 
# if (nMetaMagic == METAMAGIC_MAXIMIZE)
# {
#   nDamage = nLevel * 6;//This depends, typically level * the die roll I think
# }
#Extend
#if (nMetaMagic == METAMAGIC_EXTEND)
#{
#   nDuration = nDuration * 2;// or fDuration
#}
#Empower
#if (nMetaMagic == METAMAGIC_EMPOWER)
#{
#   nInt = nInt + (nInt / 2);// or nDamage, or returns an int? catgrace example - that shouldn't need to be that way
#}
# Update nw_s0_awaken to have maximize work?
# Also need to replace int nCasterLevel = GetCasterLevel(OBJECT_SELF);
# with int nCasterLevel - SM_GetCasterLevel(OBJECT_SELF);