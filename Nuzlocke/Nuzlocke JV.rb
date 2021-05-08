#===============================================================================
# * Nuzlocke Mode - by JV (Credits if used please)
#===============================================================================
#
# This script is for Pokémon Essentials. It adds support for the famous fan
# created Nuzlocke Mode, where Pokémon are considered dead when fainted and
# the player is only able to capture the first pokémon they spot in each map.
#
# This is script is at the same time an improvement and a simpler version of
# what I did on Pokémon Uranium, for which I'll use this new script as a base
# for the one in my game.
#
# Features included:
#   - Only one encounter per Map
#   - Optional Dubious Clause (same species encounter doesn't count)
#   - Support for connected maps (so you don't get 2 encounters in the same route)
#   - Permadeath (no healing or revive)
#
#
#==INSTRUCTIONS=================================================================
#
# To install this script it's simple, just put it above main. (yes, plug and play)
# Also: Replace lines 327, 340, 1153, 1172 of PokémonItemEffects replace:
#       "   if pokemon.hp>0"
# With:
#       "   if pokemon.hp>0 || $PokemonGlobal.nuzlocke==true" 
#
#==HOW TO USE===================================================================
#
# To use this script simply call in an event: "$PokemonGlobal.nuzlocke = true" 
#
# If you want to turn off the mode just do the same, but with false instead.
#
#==CONFIGURATION================================================================

# OPTION 1: Dubious Clause (same species encounter doesn't count)
DUBIOUSCLAUSE = true

# OPTION 2: Connected Maps (so you don't get 2 encounters in the same route)
# example: (It's an array of arrays, simple as that, just mimic the example)
=begin
NUZLOCKEMAPS = [
[5,21],
[2,7,12]
]
=end
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :nuzlocke
  attr_accessor :nuzlockeMaps
  
  alias nuzlocke_initialize initialize
  def initialize
    @nuzlocke=false
    @nuzlockeMaps=[]
    nuzlocke_initialize
  end
  
  def nuzlockeMapState(mapid)
    if !@nuzlockeMaps
      @nuzlockeMaps=[]
    end
    return 0 if @nuzlockeMaps.length==0
    for i in 0...@nuzlockeMaps.length
      if @nuzlockeMaps[i][0] == mapid
        state = @nuzlockeMaps[i][1]
        echo("(")
        echo(@nuzlockeMaps)
        echo("->")
        echo(state)
        echo(")\n")
        return state
        break
      end
    end
  end
  
  def checkDuplicates(mapid)
    return false if !@nuzlockeMaps
    for i in 0...@nuzlockeMaps.length
      if @nuzlockeMaps[i][0] == mapid
        return true
      end
    end
    return false
  end
end


class PokeBattle_Battle
  
  alias nuzlocke_ThrowPokeBall pbThrowPokeBall
  def pbThrowPokeBall(idxPokemon,ball,rareness=nil)
    if $PokemonGlobal.nuzlocke
      nuzlockeMultipleMaps
      if $PokemonGlobal.nuzlockeMapState($game_map.map_id) == 1
        pbDisplay(_INTL("But {1} already fought a wild pokemon on this area!",self.pbPlayer.name))
        return
      end
      if $PokemonGlobal.nuzlockeMapState($game_map.map_id) == 2
        pbDisplay(_INTL("But {1} already caught a pokemon on this area!",self.pbPlayer.name))
        return
      end
    end
    nuzlocke_ThrowPokeBall(idxPokemon,ball,rareness=nil)
  end
  
  alias nuzlocke_EndOfBattle pbEndOfBattle
  def pbEndOfBattle(canlose=false)
    nuzlocke_EndOfBattle
    if $PokemonGlobal.nuzlocke
      if @decision == 4
        $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,2])
      end
      if !@opponent && $PokemonGlobal.nuzlockeMapState($game_map.map_id) != 2
        $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,1]) if !DUBIOUSCLAUSE 
        $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,1]) if (DUBIOUSCLAUSE && !@battlers[1].owned)
      end
    end
  end
  
  def nuzlockeMultipleMaps
    return if !NUZLOCKEMAPS
    for i in 0...NUZLOCKEMAPS.length
      for j in 0...NUZLOCKEMAPS[i].length
        mapid = NUZLOCKEMAPS[i][j]
        if $PokemonGlobal.nuzlockeMapState(mapid) && $game_map.map_id != mapid && !$PokemonGlobal.checkDuplicates($game_map.map_id)
          if ($PokemonGlobal.nuzlockeMapState(mapid) != 0 && NUZLOCKEMAPS[i].include?($game_map.map_id))
            $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,$PokemonGlobal.nuzlockeMapState(mapid)]) 
          end
        end
      end
    end
  end
end

class PokeBattle_Pokemon  
  alias nuzlocke_heal heal
  def heal
    return if hp<=0 && $PokemonGlobal.nuzlocke
    return if egg?
    healHP
    healStatus
    healPP
  end
end  

alias nuzlocke_pbHealAll pbHealAll
def pbHealAll
  return if !$Trainer
  for i in $Trainer.party
    if $PokemonGlobal.nuzlocke
      if i.hp > 0
        i.heal
      end
    else
    i.heal
    end
  end
end