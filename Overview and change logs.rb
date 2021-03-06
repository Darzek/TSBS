# =============================================================================
# Theolized Sideview Battle System
# Current Version 1.3c
# =============================================================================
# Script info :
# -----------------------------------------------------------------------------
# Known Compatibility :
# >> YEA - Core Engine
# >> YEA - Battle Engine (Recommended!)
# >> YEA - Lunatic Object
# >> YEA - Lunatic Target
# >> YEA - Target Manager
# >> YEA - Area of Effect
# >> MOG Battle HUD
# >> MOG Active Time Battle
# >> Sabakan - Ao no Kiseki
# >> Fomar ATB
# >> EST - Ring System
# >> Szyu - Timed States (With a note : http://goo.gl/5lwhN5)
# -----------------------------------------------------------------------------
# Known Incompatibility :
# >> MOG Breathing script
# >> Luna Engine (It's paid script. Ask them to make compatibility)
# =============================================================================
=begin

  TSBS - Overview
  These informations are aimed for scripter to ensure compatibility without
  reading too many lines.
  
  Compatibility notes :
  > I greatly changed the damage flow from scene battle by overwriting def
    use_item in Scene_Battle. So, if there is any script that also using that 
    method, it's highly will NOT compatible with this script. Also, I don't
    use invoke_item, instead I make my own invoke item method by adding
    tsbs_invoke_item. So, nobody will mess with it
  
  > I haven't touch menu or battle HUD. So, if you planned to make your own
    battle HUD, I'm sure it will be compatible. As long as it doesn't mess
    around wih Game_Actor screen position (screen_x, screen_y)
  
  > I also haven't touch turn order yet. So far, it's compatible with Yanfly 
    Free turn, Sabakan - Ao no Kiseki battle system, and Fomar ATB, AEA
    Charge Turn Battle
    
  > If you plan to add galv's timed button attack, I'm afraid it will not
    compatible. Since I greatly changed the damage flow.
    
  > I recommend you to use YEA - Battle Engine. If you refuse it, then if you 
    want to make your own damage popup, just make it yourself. I don't want to 
    make one. Instead, I provide built-in damage counter.
    
  > I don't want to hear any complaint about compatibility issues. Since I
    make this script for my personal use at the first time. But, you can
    modify or even make derivate of my works. If only you're capable
  
  Planned added features :
  >> Shot projectile from specific coordinate
  >> Shot projectile to specific coordinate
  >> Projectile coordinat adjustment
  >> Extended timed-hit features (dodge hit, or something like that)
  >> Combo hit
  >> Grid Battle System?
  >> Subtitue / Cover support
  >> Class change battler graphics
  >> Folder for battler for easier organize
  >> Clone battler for action sequence animation
  >> Camera effect?
  
  Special Thanks :
  >> RPGMakerID
  >> TDS for basic movement module in RMRK
  >> Mithran for Graphical global object ref
  >> Eremidia: Dungeon! and Tankentai VX for basic inspirations
  >> Estriole
  >> Ryuz Andhika 
  >> Skourpy 
  >> CielScarlet 
  >> Komozaku Kazeko 
  >> Nethernal 
  
  ----------------------------------------------------------------------------
  Overwritten Methods (Total: 18)
  *) Sound            - play_evasion
                      - play_enemy_collapse
  *) BattleManager    - process_escape
  *) Game_Battler     - item_effect_remove_state
  *) Game_Actor       - use_sprite?
                      - perform_damage_effect
                      - perform_collapse_effect
  *) Game_Enemy       - screen_z
                      - perform_damage_effect
  *) Game_Party       - max_battle_members
  *) Sprite_Battler   - update_origin
                      - init_visibility
                      - revert_to_normal
                      - afterimage (Basic Module - Afterimage)
                      - animation_set_sprites
                      - init_visibility
  *) Spriteset_Battle - create_actors
  *) Scene_Battle     - use_item
  
  ----------------------------------------------------------------------------
  Aliased Methods (Total: 41)
  *) DataManager        - load_database
  *) BattleManager      - battle_start
                        - process_victory
                        - judge_win_loss
  *) Game_Temp          - initialize
  *) Game_Action        - targets_for_opponents
  *) Game_ActionResult  - clear
  *) Game_Battler       - initialize
                        - on_battle_start
                        - make_base_result (Basic Module - Core Result)
                        - on_turn_end
                        - on_action_end
                        - item_cnt
                        - item_mrf
                        - item_eva
                        - item_hit
  *) Game_Actor         - on_battle_start
                        - attack_skill_id
                        - guard_skill_id
  *) Game_Enemy         - initialize
                        - screen_x
                        - screen_y
                        - on_battle_start
                        - battler_name
                        - perform_collapse_effect
  *) Sprite_Base        - update_animation
  *) Sprite_Battler     - initialize
                        - start_animation
                        - bitmap=
                        - update
                        - opacity=
                        - update_boss_collapse
                        - dispose
                        - flash
  *) Spriteset_Battle   - initialize
                        - create_viewports
                        - update
  *) Scene_Battle       - start
                        - post_start
                        - update_basic
                        - terminate
                        
  ----------------------------------------------------------------------------
  New Modules and Classes (Total: 13)
  *) Game_BattleEvent
  *) Sprite_Screen < Sprite (Basic Module - Basic Function)
  *) Sprite_AnimGuard < Sprite_Base
  *) Sprite_AnimState < Sprite_Base
  *) Sprite_BattlerShadow < Sprite
  *) Sprite_BattlerIcon < Sprite
  *) Sprite_Projectile < Sprite_Base
  *) Sprite_BattleCutin < Sprite
  *) Battle_Plane < Plane
  *) DamageResult < Sprite
  *) DamageResults
  *) TSBS
  *) TSBS_AnimRewrite

=end
# -----------------------------------------------------------------------------
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.08.27 - Added shadow y formula
#            - Added screen_x and screen_y formula for Battler Icon
# 2014.08.25 - Fixed shadow glitch in the beginning of battle start
#            - Change shadow Z value to 3
# 2014.08.24 - Added one animation display for projectile area attack
# 2014.08.22 - Added common event call during action sequence
# 2014.08.21 - Change script header. Moved $imported from config 1 to 
#              implementation part
# 2014.08.20 - Compatibility with YEA Lunatic Object (at least, it should)
#            - Divide show_action_sequence method into parts for future use
#            - Fixed :anim_top error
#            - Added one animation display for area attack
#            - Added projectile damage rescale
# 2014.08.19 - Add default value for @ori_x and @ori_y to prevent error when
#              adding non battle members
# 2014.08.18 - Fixed bug where battler icon didn't follow battler opacity
# 2014.07.20 - Added [:timestop]
# 2014.07.19 - Prevent counterattack being counterattacked (lolwhut?)
#            - Added slow motion effect
# 2014.07.16 - Bugfix. Crashes when collapse sequence trying to damage opposite
#              unit in slip damage death
# 2014.07.15 - Added max opacity to [:plane_add,] command
# 2014.07.14 - Added <no shadow> tag for both actor and enemy
#            - Added custom collapse sound for enemy
#            - Added force always hit command sequence
#            - Bugfix. Y coordinate for [:move_to_target] doesn't work
# 2014.07.13 - Added icon movement (to support spear animation)
#            - Added default target (the attacker) for collapse sequence. In
#              case if you want to damage the attacker using collapse sequence
#            - Added function to check target range (for future use)
#            - Added function to reset damage counter
# 2014.07.12 - Bugfix. Fatal error in collapse sequence when you want to damage 
#              the opposite units using [:target_damage]
#            - Change actor fiber reference ID
#            - Correct animation state opacity rate reference
#            - Correct animation guard opacity rate reference
# 2014.07.11 - Victory sequence now is just optional
# 2014.07.10 - Reverted back "raise" method to "msgbox"
#            - Added icon error recognition
#            - Added sequence initial setup error recognition
# 2014.07.09 - Bugfix, move to target for area attack ignores inputted 
#              parameters
#            - Disable subtitue / cover function. Since it's not functional
#              in TSBS at now
#            - Added animation behind for state animation
#            - Added ability to define sequence directly inside [:loop]
# 2014.06.29 - Bugfix, random repel target the dead battler
#            - Revamp error handling for [:action]
# 2014.06.28 - Added built-in change basic skill (attack and defend) for actor,
#              weapon, class, and states
#            - Magical skill doesn't reflect for self targeting
# 2014.06.25 - Improved conditional branch [:if] and [:case]. Now support 
#              nested array instead of only action key.
#            - Revamp [:add_state] execution. Now supports state rate from
#              built-in features or even ignore it. 
#            - Revamp [:rem_state] execution.
#            - Change "def chance" to evaluate float instead of integer as
#              chance
# 2014.06.23 - [:cast] default animation now same as skill animation
# 2014.06.21 - Added <flip> tag for battler. To determine default flip
#            - Added state transformation
#            - Fix setup_cast flip animation in Game_Battler
#            - Added change skill
#            - Bugfix, adding non battle members causing fatal errors
#            - Simplify setup_action. Now use "each" instead of "insert". Save
#              memory usage more
#            - [:move_to_target] and [:sm_target] now move action battler to
#              the middle of targets if the target is area
# 2014.06.20 - Added animation following battler
#            - Remove invoke method from $game_temp
#            - Remove collapsed glitch and visibility
#            - Glitch fix. Anim state animation sprite not reseted when loop
# 2014.06.19 - Screen animation now support :anim_bottom
#            - Area attack move to target now moves in the middle of area
#            - Added random magic reflection
# 2014.06.16 - Added custom error notice for script call
# 2014.06.15 - Bugfix, throws an error if actor has no intro sequence
#            - Added instant reset
# 2014.06.06 - Added :forced battle phase
#            - Support show animation behind battler
#            - Bugfix, show projectile throws error when not followed by YEA
#              Battle Engine
# 2014.05.14 - Prevent :counter battle phase of being replaced by :hurt
# 2014.05.05 - Added [:loop] sequence command
#            - Added [:while] sequence command
#            - Change how [:if] sequence is handled
# 2014.05.01 - Added smooth movement
#            - Glitch fix on intro sequence where sprite is not updated on
#              first time
#            - Bugfix. Skill guard applied to friendly unit
# 2014.04.30 - Added function to control afterimages
# 2014.04.25 - Added collapse sequence
#            - Added control on message log
#            - Every counter attack has performed, it will reset damage counter
# 2014.04.18 - Bugfix. Changed formation doesn't affect battler position
# 2014.04.16 - Added function to plays anim guard and regular aninmation
#              simultaneously by <parallel anim> tag
#            - Renamed Sprite_AnimAid as Sprite_AnimState
#            - Renamed @ary instance variable as @acts in Game_Battler
#            - Added new class Sprite_AnimGuard
# 2014.04.14 - Show balloon icon for battler
#            - Projectile icon now can evaluate String/text as script as long 
#              as the return is a number
# 2014.04.13 - Added show cutin graphic
#            - Added show plane object (image looping / parallax / fog)
#            - Added boomerang sequence. Repel back projectile to user
#            - Automatically reset all battler position each action has 
#              performed
#            - Added projectile afterimage
#            - Icon index now can use script eval if filled by String/Text
# 2014.04.11 - Compatibility with Galv's script (I forget which one)
#            - Added animation top flag to allow you to play animation on top
#            - Added global freeze sequence. Allow you to stop all movement
#            - Added show cutin graphic
#            - Added return sequence key for each skill
#            - Added dual wield show icon support
#            - Reduce lag for too many animated battlers
# 2014.03.23 - Animation projectile now loops
#            - Chance in add or remove state sequence now is optional (default
#              is 100% if ommited)
# 2014.01.19 - Bugfix. Now counter and evade phase will executed until finished
# 2014.01.18 - Add counter attack and magic reflect text notifications
#            - Bugfix. Sound play evasion 
# 2014.01.16 - Bugfix, dead actor won't disappear when use focus sequence
# 2014.01.15 - Counter attack now works
#            - Smart targeting. Dead battler won't be attacked by random targets
# 2014.01.14 - Fixed screen z formula
#            - Added shadow for battler sprites
# 2014.01.13 - Fixed animation display. Animation now will not overlap sprite
# 2014.01.11 - Projectile now can be reflected
#            - Magic reflection reworked
#            - Added state animation for battler
# 2013.12.29 - Added state sequence
#            - Added state color
# 2013.12.28 - Store Constant in TSBS Module
#            - Change the way how proj_setup is handled
# 2013.12.26 - Move the enemy even it doesn't have spriteset
#            - Skill / item recovery animation won't replaced by anim guard
#            - Added damage counter font size controler
# 2013.12.25 - Fixed bug at show weapon icon
#            - Fixed collapse effect with extended targeting
# 2013.12.24 - Added copy object function in Kernel module (def copy)
#            - Set the origin of projectile to center
# 2013.12.23 - Cleaning up some messy codes
#            - Extends targeting. Ability to change target during sequences
#            - Added function to add state by chance
#            - Added function to remove state by chance
#            - Added show picture function
#            - Added target move to change target coordinate
#            - Added target slide to change target coordinate
#            - Added blend function for battler
#            - Added focus functions
# 2013.12.22 - Projectile now support show icon along side animation
# 2013.12.21 - clear_tsbs now called in Scene_Battle terminate
#            - Added escape sequence pose
#            - Added victory sequence pose
#            - Added intro sequence for battle start
#            - [:target_damage] now support rescale damage using Float number
# 2013.12.20 - Store Fiber in $game_temp in order to raise compatibility
#            - Store invoke_method in $game_temp in order to raise compatibility
#            - Added if else action sequence. Not supported nested if yet
#            - Added timed hit function
#            - Added change tone function
#            - Added screen shake function
#            - Added flash screen function
#            - Change the way item_in_use is handled
# 2013.12.18 - Support show weapon icon (For kaduki battler)
# 2013.12.17 - Ability to lock Z coordinate using [:lock_z]
# 2013.12.16 - Damage counter now fixed and works
#            - Projectile now support area attack
#            - States now may change battler opacity using <opacity: n> tag
#            - Add user damage to damage the user / subject
#            - [:target_damage] now support custom formula
#            - [:target_damage] now support change to specific skill
# 2013.12.12 - Dead pose now works
#            - Added enemy default flip
# 2013.12.11 - Now support change hue for enemy
# 2013.12.07 - Now support projectile (but doesn't support area attack yet)
# 2013.12.05 - Some skill now can disable the return move using <no return>
#            - Area skill now works
#            - States now has its own tone
# 2013.12.04 - Slide command now has inverted coordinate if flipped
#            - Now support return movement after performed action
#            - Now support prepare / cast sequence before action
#            - Disable dead pose (at least, for now)
#            - Fixed flipped animation in :show_anim
# 2013.12.03 - Show animation for normal attack
#            - Added evade sequence
#            - Added [:action] command to call pre-defined action sequence
# 2013.11.28 - Finished version 0.5 (Released at : 28 November 2013)
#            - Support action sequences
#            - Bugfix : Collapse effect wont show if not followed by ABE
#            - Now redraw status menu when getting hit
# 2013.05.07 - Started to learn how to make original battle engine
#            - Finished version 0.2
# =============================================================================
