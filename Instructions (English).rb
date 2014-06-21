# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (English Documentation)
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5
# >> Basic Functions 
# >> Movement    
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# =============================================================================
# Script info :
# -----------------------------------------------------------------------------
# Known Compatibility :
# >> YEA - Core Engine
# >> YEA - Battle Engine (RECOMMENDED!)
# >> MOG Battle HUD
# >> Sabakan - Ao no Kiseki
# >> Fomar ATB
# >> EST - Ring System
# -----------------------------------------------------------------------------
# Known Incompatibility :
# >> YEA - Lunatic Object
# >> Maybe, most of battle related scripts (ATB, or such...)
# >> MOG Breathing script
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit me, TheoAllen. You are free to edit this script by your own. As long
# as you don't claim it yours. For commercial purpose, don't forget to give me
# a free copy of the game.
# =============================================================================
=begin  
  --------------------------------------------------------------------------
  * ) Opening :
  --------------------------------------------------------------------------
  
  Okay, at first I only wanted to use this script as personal use. As a 
  objection why it was so hard to understand other's Battle Engine. I just 
  don't get the way they works. So, I decided to learn how to script my own 
  battle engine
  
  My hope is, when I finish this script, so I can make my own Sideview
  Battle system's sequence without learn other's scripts. In other means that
  if I feel that something is missing, I can add them by myself without asking
  people which may going to be unanswered. And I'm suck at English
  anyway ....
  
  So, how about you as script user? Well, I may accept any comments or 
  bug reports. But I'm not guaranteed about compatibility patch with other
  scripts. Do not give my any homeworks by learning someone else's script 
  just to make compatibility patch. Unless, I'm interested
  
  Well, sorry if I can't explain this TSBS well and if is so tedious to use. 
  Let just get started then
  
  --------------------------------------------------------------------------
  * ) How to install :
  --------------------------------------------------------------------------
  Make sure that you take these script list in your editor :
  >> Config 1 - General
  >> Config 2 - Sequence
  >> Implementation
  
  Put the Theo - Basic Modules v1.5 all above custom script. If you're using
  YEA - Core or Battle Engine, put that above this script. This script also
  need to be placed above main as well.
  
  --------------------------------------------------------------------------
  * ) Spriteset Rules :
  --------------------------------------------------------------------------
  
  Spriteset files must be inside Graphics/Battler. And the file name must
  begin with battler's name (actor / enemy) and ended with number. For
  examples :
  
  - Eric_1.png
  - Eric_2.png
  - Slime_1.png
  - Slime_2.png
  
  The number is for sequence setup. You will find it out later.
  If you wonder how the spriteset should be, find that out in "Config 1"
  
  --------------------------------------------------------------------------
  * ) ACTOR NOTETAGS :
  --------------------------------------------------------------------------
  Use these tags in actor notebox :
  
  <sideview>
  idle : key
  critical : key
  hurt : key
  dead : key
  intro : key
  victory : key
  escape : key
  return : key
  counter : key
  <sideview>
  
  Replace the 'key' with a hash key that you have set it up in action 
  sequences (config 2 - sequence). These options are :
  
  idle      >> Sequence for idle pose
  critical  >> Sequence if the HP is in critical condition
  hurt      >> Sequence if the battler get hit
  dead      >> Sequence if the battler is knockout (dead is too xtreme)
  intro     >> Sequence for battle intro
  victory   >> Sequence for victory pose
  escape    >> Sequence for escape
  return    >> Sequence for returning back to original position
  counter   >> Sequence for counter attack
  
  For examples :
  
  <sideview>
  idle : Eric_IDLE
  critical : Eric_CRI
  </sideview>
  
  -----------------------
  Notetag for counterattack
  <counter skill: id>
  
  By default, actor's counter skill is 1. You can replace it by insert this 
  notetag
  
  <counter skill: 4>
  
  -----------------------
  Notetag for magic reflection
  <reflect anim: id>
  
  An animation that will be played during magic reflection on magic victim.
  
  --------------------------------------------------------------------------
  * ) ENEMY NOTETAGS :
  --------------------------------------------------------------------------
  
  Use these notetags to enemy notebox if you want the enemy also use spriteset
  as actor did. If you don't use these notetags, the enemy will be static. That 
  is up to you
  
  <sideview: battlername>
  idle : key
  critical : key
  hurt : key
  evade : key
  return : key
  counter : key
  collapse : key
  </sideview>
  
  The explanation is same as actor notetags. But, you have to replace the
  'battlername' with the file name that you're going to use it as enemy's 
  spriteset
  
  For example, you can write it like this :
  <sideview: slime>

  So, it will use these image file names :
  slime_1, slime_2, slime_3 etc ...
  
 -----------------------
  Notetag for counterattack
  <counter skill: id>
  
  By default, enemy's counter skill is 1. You can replace it by insert this 
  notetag
  
  <counter skill: 4>
  
  -----------------------
  Notetag for magic reflection
  <reflect anim: id>
  
  An animation that will be played during magic reflection on magic victim.
  
  --------------------------------------------------------------------------
  * ) SKILL / ITEM NOTETAGS :
  --------------------------------------------------------------------------
  Use this tag to set preparation sequence before the skill is executed
  \preparation : key_sequence
  
  Use this tag to set action sequence
  \sequence : key_sequence
  
  Use this tag to set return sequence after performing action
  \return : key_sequence
  
  If you're using three times \sequence in skill/item notebox with different key
  sequence, the result will be randomized. In other means, that you could have 
  three  different sequence on skill/item
  
  ----------------------------
  AREA DAMAGE :
  
  <area>
  By default, if the target number is two or higher (such as 3 random enemies), 
  the skill sequence will be executed as many as the target number. By adding
  <area> tag in skill/item notebox, the action sequence will be executed one 
  time.
  
  ----------------------------
  NO RETURN SEQUENCE :
  
  <no return>
  By default, each skill/item sequence was finished, the return key sequence
  will be called. But, for some case, calling return sequence is not
  necessary. So, you can add <no return> tag to your skill/item notebox to
  prevent calling return sequence.
  
  ----------------------------
  ABSOLUTE TARGETING :
  
  <abs-target>
  Sometimes, a random targeting causes target the same enemy. If you want
  two random target is really absolute, which mean that the targeted enemy
  won't be attacked twice, you can add <abs-target> tag in skill/item notebox
  
  ----------------------------
  MAGIC REFLECT ANIMATION :
  
  By default, an animation that will be played to magic caster during magic
  reflection is same as it's skill animation. If you want to change it to
  another animation, you can use this tag
  <reflect anim: id>
  
  ----------------------------
  PARALLEL ANIMATION :
  
  By default, animation that will be played on target when the target has 
  animation guard, then the regular animation will be replaced by anim guard.
  in order to play both in parallel, input this tag
  <parallel anim>
  
  ----------------------------
  RANDOM TARGET REFLECTION :
  
  By default, target of the magic reflection is the magic attacker itself. If
  you want to make magic reflection target to be randomized. You can use this
  tag in skill/item notebox
  <random reflect>
  
  ----------------------------------------------------------------------------
  These are some special tags for skill
  <always hit>    || The skill won't be missed
  <anti counter>  || The skill can not be counterattacked
  <anti reflect>  || The skill can not be reflected
  
  <ignore skill guard>  || The skill will be ignore target's skill guard
  <ignore anim guard>   || The skill animation will be ignore target's animation
  guard
  
  What is skill guard and animation guard anyway?
  Read it below
  
  --------------------------------------------------------------------------
  * ) STATE NOTETAGS :
  --------------------------------------------------------------------------
  State Tone & Color :
  -------------------------
  You can also define the color or tone alteration of the battler if the battler 
  is inflicted a certain state by inserting these notetag. There are two modes.
  Tone and Color.
  
  <tone: red,green,blue,gray>
  <color: red,green,blue,alpha>
  
  Replace RGB with any number you want. It should be around 0 - 255. You can
  set minus operand if you want to reduce some color composition. Note that 
  minus ONLY works for tone. Tone is same as tint screen in event
  
  Example :
  <tone: -30,80,-60,0>
  <color: 0,0,0,150>
  
  -----------------------------------------------------------------------------
  Animation Guard :
  -------------------------
  Anim guard is an animation that will be played if the target is being 
  attacked and is currently under influence a certain state. For example, the 
  battler is currently under protection of magic barrier. So, if the battler is 
  being attacked, it will be play barrier protection. (see Lunar's Spellshield
  in my sample game)
  
  Use this notetag :
  <anim guard: n>
  Replace n with a number that represent animation ID
  
  -----------------------------------------------------------------------------
  Skill Guard :
  -------------------------
  Skill guard is a counter skill that will be applied to attacker. Not a 
  literally counter though. For example, if the battler is under 'poison skin' 
  state, anyone who attack him will be infected by poison state or such.
  (see Flay's Corrosive skin OR Soleil's flamecloak in my sample game)
  
  Use this notetag :
  <skill guard: n>
  Replace n with a number that represent skill ID
  
  -----------------------------------------------------------------------------
  State Opacity :
  -------------------------
  In case that if you want the battler to be transparent, you can use this
  feature. For example, the 'hide' state will prevent enemy to target. The 
  battler will be in displayed in half transparent
  
  Use this tag :
  <opacity: n>
  Replace n with a number value that should go around 0 - 255
  
  -----------------------------------------------------------------------------
  State Sequence :
  -------------------------
  You can also define custom idle sequence when the battler is under influence
  of a certain state. For example, if battler is being stuned, so the battler 
  will be down or such. Use this tag
  
  \sequence : key_sequence
  
  It is similar as skill sequence tag.
  To be noted that state sequence is considered as idle sequence
  
  -----------------------------------------------------------------------------
  State Animation :
  -------------------------
  It is similar as YEA - State Animation. But I'm going to make my own. If
  the battler is under influence of a certain state, you can play a repeated
  animation by adding this tag to state notebox.
  
  <animation: id>
  
  -----------------------------------------------------------------------------
  * ) Terms of use :
  -----------------------------------------------------------------------------
  Credit me, TheoAllen. You are free to edit this script by your own. As long
  as you don't claim it yours. For commercial purpose, don't forget to give me
  a free copy of the game.

  This script also licensed as General Public License. It means that you can
  also modify, make derivation based on my script. As long as you give me
  a proper credit and do not sell the script.
  
  The means of "do not sell" the script is you took any monetary gain by 
  editing my script. Such as making addon. Even a person willing to pay you
  
=end
