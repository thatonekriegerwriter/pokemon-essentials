#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                            Battle-Worn Opponents                             #
#                                    v1.0                                      #
#                             By Ulithium_Dragon                               #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#  Randomly reduces the health an opponent's Pokemon as if they had recently   #
#   been in battle. Also includes options for Status Ailments and Fainting.    #
#                                                                              #
#------------------------------------------------------------------------------#
#   **Place this script somewhere above Main and below PokeBattle_Scene.       #
#==============================================================================#
#------------------------------------------------------------------------------#
#        :::::This script is compatible with both PE v16 and v17+:::::         #
#------------------------------------------------------------------------------#
#                                                                              #
#==============================================================================#
#                                 OPTIONS                                      #
#==============================================================================#
#------#
# The Global Switch used to easily disable this system (i.e. like in Events).
#  *NOTE: Make sure this switch is not used by anything else!
SWITCH_DISABLE_BATTLEWORN = 325

#------#
# Whether an opponent's Pokemon has a chance to have missing HP.
ENABLE_OPPONENT_HPLOSS  =  true   #Default: true
# The chance for an opponent Pokemon to have missing HP.
CHANCE_OPPONENT_HPLOSS  =  30     #Default: 30
# Maximum percentage of HP that can be missing.
MAX_OPPONENT_HPLOSS     =  25     #Default: 25
# Minimum percentage of HP that can be missing.
MIN_OPPONENT_HPLOSS     =  10     #Default: 10

#------#
# Whether an opponent's Pokemon has a chance to have a Status Ailment.
ENABLE_OPPONENT_STATUS  =  true   #Default: true
# The chance for an opponent Pokemon to have a Status Ailment.
CHANCE_OPPONENT_STATUS  =  15     #Default: 15
# If enabled, Electric-type Pokemon can't by Paralyzed.
USE_LATERGEN_RULES      =  true   #Default: true

#------#
# Whether an opponent's Pokemon can already have Fainted before the battle.
ENABLE_OPPONENT_FAINT   =  false   #Default: true
# The chance for an opponent Pokemon to have already Fainted.
CHANCE_OPPONENT_FAINT   =  10     #Default: 10
#==============================================================================#
#//////////////////////////////////////////////////////////////////////////////#
#==============================================================================#


Events.onTrainerPartyLoad+=proc {|sender,e|
   if !$game_switches[SWITCH_DISABLE_BATTLEWORN]
     if e[0] # Trainer data should exist to be loaded, but may not exist somehow.
       trainer=e[0][0] # A PokeBattle_Trainer object of the loaded trainer.
       items=e[0][1]   # An array of the trainer's items they can use.
       party=e[0][2]   # An array of the trainer's Pokémon.
       $counterBW = 0
       $numFaintedBW = 0
       for i in 0...party.length
         pbBattlewornOpponents(party,party[i])
         party[i].calcStats
       end
     end
   end
}

def pbBattlewornOpponents(party,opponent)
  #Run through each module, starting with fainting.
  pbOpponentsPriorFainted(party,opponent)
  pbOpponentsPriorHPLoss(party,opponent)
  pbOpponentsPriorStatus(party,opponent)
end


def pbOpponentsPriorHPLoss(party,opponent)
  if ENABLE_OPPONENT_HPLOSS && !$game_switches[SWITCH_DISABLE_BATTLEWORN] &&
            opponent.hp>0 && !opponent.isEgg?
    case rand(100)
    when 0..CHANCE_OPPONENT_HPLOSS
      #Convert the percentage into a float that can be multiplied by the HP value.
      hpRandomPercent = rand(MAX_OPPONENT_HPLOSS.to_f - MIN_OPPONENT_HPLOSS.to_f)
      hpDamagePercent = MAX_OPPONENT_HPLOSS.to_f - hpRandomPercent.to_f
      #Decrease the opponent Pokemon's HP by a random amount.
      opponent.hp = opponent.totalhp - opponent.hp*(hpDamagePercent/100)
      opponent.hp = opponent.hp.ceil
    end
  end
end


def pbOpponentsPriorStatus(party,opponent)
  if ENABLE_OPPONENT_STATUS && !$game_switches[SWITCH_DISABLE_BATTLEWORN] &&
            opponent.hp>0 && !opponent.isEgg?
    case rand(100)
    when 0..CHANCE_OPPONENT_STATUS
      loop do
        case rand(5)
        when 1  #Sleeping
          if !opponent.hasAbility?(:VITALSPIRIT) &&
                     !opponent.hasAbility?(:INSOMNIA) &&
                     !opponent.hasAbility?(:SWEETVEIL) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=PBStatuses::SLEEP
            break
          end
        when 2  #Poisoned
          if !opponent.hasType?(:POISON) &&
                     !opponent.hasType?(:STEEL) &&
                     !opponent.hasAbility?(:IMMUNITY) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=PBStatuses::POISON
            break
          end
        when 3  #Burned
          if !opponent.hasType?(:FIRE) &&
                     !opponent.hasAbility?(:WATERVEIL) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=PBStatuses::BURN
            break
          end
        when 4  #Paralysed
          if USE_LATERGEN_RULES
            if !opponent.hasType?(:ELECTRIC) &&
                     !opponent.hasAbility?(:LIMBER) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
              opponent.status=PBStatuses::PARALYSIS
              break
            end
          else
            if !opponent.hasAbility?(:LIMBER) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
              opponent.status=PBStatuses::PARALYSIS
              break
            end
          end
        when 5  #Frozen
          if !opponent.hasType?(:ICE) &&
                    !opponent.hasAbility?(:MAGMAARMOR) &&
                    (!opponent.hasAbility?(:FLOWERVEIL) && !opponent.hasType?(:GRASS)) &&
                    (!opponent.hasAbility?(:LEAFGUARD) && ($game_screen.weather_type!=PBFieldWeather::Sun)) &&
                    (!opponent.hasAbility?(:SHIELDSDOWN) && opponent.hp!=opponent.hp>(opponent.totalhp/2).floor)
            opponent.status=PBStatuses::FROZEN
            break
          end
        end
      end
    end
  end
end


  def ablePokemonCount
    ret=0
    for i in 0...@party.length
      ret+=1 if @party[i] && !@party[i].isEgg? && @party[i].hp>0
    end
    return ret
  end

def pbOpponentsPriorFainted(party,opponent)
  #Make sure they have at least 2 Pokemon first!
  if ENABLE_OPPONENT_FAINT && party.length > 1 &&
            !$game_switches[SWITCH_DISABLE_BATTLEWORN] && opponent.hp>0 &&
            !opponent.isEgg?
    $counterBW += 1
    if $counterBW < party.length
      #Make sure not all their Pokemon have fainted!
      if $numFaintedBW != party.length
      #if $counterBW != party.length && $numFaintedBW != party.length
        case rand(100)
        when 0..CHANCE_OPPONENT_FAINT
          opponent.hp = 0
          $numFaintedBW += 1
        end
      end
    end
  end
end