class PokemonGlobalMetadata
  attr_accessor :foreignEncounter
  attr_accessor :foreignPokemon
  attr_writer   :foreignPokemonCaught

  def foreignPokemonCaught
    return @foreignPokemonCaught || []
  end
end

# 0-5 are about encountering the Pokémon
#0-Species, 1-lvl, 2-switch, 3-encounter type, 4-battle BGM, 5-map ID
#Encounter types are the same as for Roaming Pokémon

#6-8 affect cosmetic info
#6-shiny (true/false), 7-gender (0M, 1F), 8- Nickname

#9-12 affect OT info
#9-name, 10-gender (0M,1F,2N), 11-ID#, 12-language
#The trainer ID# can be anywhere from 1 to 55555
#You can go higher, but it won't come out how you write it.
#(For example, 555555 doesn't display as "55555", but instead 31267)

#13-18 affect battle properties
#13-form, 14-nature, 15-IVs (an array of six numbers or one number),
#16-EVs (has to be six numbers), 17-moves (as an array), 18-ability#

#19 is currently reserved for items, but items sadly don't work yet.
#If you're using Pokémon Memories, you can uncomment part of the code
#and use 20 to set memory.

#[:SPECIES,LEVEL,SWITCH,ENCOUNTER,BGM,MAP,SHINY,GENDER,NICKNAME,OT,OT Gender,OT ID NUMBER,OT LANGUAGE,FORM,NATURE,
#IV,EV, [:MOVES, :MOVES], ABILITY],
foreignSpecies = [
[:RATTATA, 20, 16, 1, nil, 5, nil, 0, "Top Percentage", "Joey", 0, 55468, 2, 1, :HASTY,
[31], [31,31,31,31,31,31], [:HYPERFANG], 0],
[:PONYTA, 30, 180, 1, nil, 17, nil, 1, "Pinkie", "Julia", 1, 55464, 2, 1, :HASTY,
[31], [31,31,31,31,31,31], [:HYPNOSIS], 0]
]

#===============================================================================
# Encountering a foreign Pokémon in a wild battle.
#===============================================================================
class PokemonTemp
  attr_accessor :foreignIndex   # Index of foreign Pokémon to encounter next
end



# Returns whether the given category of encounter contains the actual encounter
# method that will occur in the player's current position.
def pbForeignMethodAllowed(encType)
  encounter = $PokemonEncounters.pbEncounterType
  case encType
  when 0   # Any encounter method (except triggered ones and Bug Contest)
    return true if encounter==EncounterTypes::Land ||
                   encounter==EncounterTypes::LandMorning ||
                   encounter==EncounterTypes::LandDay ||
                   encounter==EncounterTypes::LandNight ||
                   encounter==EncounterTypes::Water ||
                   encounter==EncounterTypes::Cave
  when 1   # Grass (except Bug Contest)/walking in caves only
    return true if encounter==EncounterTypes::Land ||
                   encounter==EncounterTypes::LandMorning ||
                   encounter==EncounterTypes::LandDay ||
                   encounter==EncounterTypes::LandNight ||
                   encounter==EncounterTypes::Cave
  when 2   # Surfing only
    return true if encounter==EncounterTypes::Water
  when 3   # Fishing only
    return true if encounter==EncounterTypes::OldRod ||
                   encounter==EncounterTypes::GoodRod ||
                   encounter==EncounterTypes::SuperRod
  when 4   # Water-based only
    return true if encounter==EncounterTypes::Water ||
                   encounter==EncounterTypes::OldRod ||
                   encounter==EncounterTypes::GoodRod ||
                   encounter==EncounterTypes::SuperRod
  end
  return false
end

EncounterModifier.register(proc { |encounter|
  $PokemonTemp.foreignIndex = nil
  next nil if !encounter
  # Give the regular encounter if encountering a foreign Pokémon isn't possible
  next encounter if $PokemonGlobal.partner
  next encounter if $PokemonTemp.pokeradar
  next encounter if rand(100)<50   # 50% chance of encountering a foreign Pokémon
  # Look at each foreign Pokémon in turn and decide whether it's possible to
  # encounter it
  $PokemonGlobal.foreignPokemon = [] if !$PokemonGlobal.foreignPokemon
  foreignChoices = []
  for i in 0...foreignSpecies.length
    # [species symbol, level, Game Switch, encounter type, battle BGM, area maps hash]
    foreignData = foreignSpecies[i]
    next if $PokemonGlobal.foreignPokemon[i]==true   # Foreign Pokémon has been caught
    # Ensure species is a number rather than a string/symbol
    species = getID(PBSpecies,foreignData[0])
    next if !species || species<=0
    # Makes sure the relevant switch is on
    switch=foreignData[2]
    next if $game_switches[switch]==false
    # Get the foreign Pokémon's map
    foreignMap=foreignData[5]
    # Check if foreign Pokémon is on the current map. If not, check if foreign
    # Pokémon is on a map with the same name as the current map and both maps
    # are in the same region
    if foreignMap!=$game_map.map_id
      currentRegion = pbGetCurrentRegion
      next if pbGetMetadata(foreignMap,MetadataMapPosition)[0]!=currentRegion
      currentMapName = pbGetMessage(MessageTypes::MapNames,$game_map.map_id)
      next if pbGetMessage(MessageTypes::MapNames,foreignMap)!=currentMapName
    end
    # Check whether the roaming Pokémon's category of encounter is currently possible
    next if !pbForeignMethodAllowed(foreignData[3])
    # Add this foreign Pokémon to the list of possible foreign Pokémon to encounter
    foreignChoices.push([i,species,foreignData[1],foreignData[4],0,0,
    foreignData[6],foreignData[7],foreignData[8],foreignData[9],foreignData[10],
    foreignData[11],foreignData[12],foreignData[13],foreignData[14],foreignData[15],
    foreignData[16],foreignData[17],foreignData[18],foreignData[19]#,foreignData[20]
    ])
  end
  # No encounterable roaming Pokémon were found, just have the regular encounter
  next encounter if foreignChoices.length==0
  # Pick a roaming Pokémon to encounter out of those available
  chosenForeign = foreignChoices[rand(foreignChoices.length)]
  $PokemonGlobal.foreignEncounter = chosenForeign
  $PokemonTemp.foreignIndex     = chosenForeign[0]   # Foreign Pokémon's index
  if chosenForeign[3] && chosenForeign[3]!=""
    $PokemonGlobal.nextBattleBGM = chosenForeign[3]
  end
  $PokemonTemp.forceSingleBattle = true
  next [chosenForeign[1],chosenForeign[2]]   # Species, level
})


Events.onWildBattleOverride += proc { |_sender,e|
  species = e[0]
  level   = e[1]
  handled = e[2]
  next if handled[0]!=nil
  next if !$PokemonGlobal.foreignEncounter
  next if $PokemonTemp.foreignIndex==nil
  handled[0] = pbForeignPokemonBattle(species,level)
}


def pbForeignPokemonBattle(species, level)
  # Get the foreign Pokémon to encounter; generate it based on the species and
  # level if it doesn't already exist
  idxForeign = $PokemonTemp.foreignIndex
  if !$PokemonGlobal.foreignPokemon[idxForeign] ||
     !$PokemonGlobal.foreignPokemon[idxForeign].is_a?(PokeBattle_Pokemon)
    $PokemonGlobal.foreignPokemon[idxForeign] = pbGenerateWildPokemon(species,level,false)
  end
      #Edits to Pokemon
  chosenForeign=$PokemonGlobal.foreignEncounter
  pokemon=$PokemonGlobal.foreignPokemon[idxForeign]
  #Cosmetics
    #shiny
    case chosenForeign[6]
    when true
      pokemon.makeShiny
    when false
      pokemon.makeNotShiny
  end
    #gender
    case chosenForeign[7]
     when 0
      pokemon.makeMale
      when 1
      pokemon.makeFemale
    end
      #name
    if chosenForeign[8] && chosenForeign[8]!=""
     pokemon.name=chosenForeign[8]
    end
   #OT protperties
     #name
   if chosenForeign[9] && chosenForeign[9]!=""
      pokemon.ot=chosenForeign[9]
    end
      #gender
    if chosenForeign[10] && chosenForeign[10]!=""
      pokemon.otgender=chosenForeign[10]
    end
      #ID
    if chosenForeign[11] && chosenForeign[11]!=""
      pokemon.trainerID=chosenForeign[11]
    end
      #language
    if chosenForeign[12] && chosenForeign[12]!=""
      pokemon.language=chosenForeign[12]
    end
    #battle properties
      #form
   if chosenForeign[13] && chosenForeign[13]!=""
      pokemon.form=chosenForeign[13]
    end
    #nature
    if chosenForeign[14] && chosenForeign[14]!=""
        pokemon.setNature(chosenForeign[14])
      end
      #ivs
    if chosenForeign[15] && chosenForeign[15]!=""
      newIVs=chosenForeign[15]
      case newIVs.length
        when 1
          newIV=newIVs[0]
          pokemon.iv[PBStats::HP]=newIV
          pokemon.iv[PBStats::ATTACK]=newIV
          pokemon.iv[PBStats::DEFENSE]=newIV
          pokemon.iv[PBStats::SPATK]=newIV
          pokemon.iv[PBStats::SPDEF]=newIV
          pokemon.iv[PBStats::SPEED]=newIV
      when 6
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::HP]=newIVs[0]
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::ATTACK]=newIVs[1]
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::DEFENSE]=newIVs[2]
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::SPATK]=newIVs[3]
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::SPDEF]=newIVs[4]
          $PokemonGlobal.foreignPokemon[idxForeign].iv[PBStats::SPEED]=newIVs[5]
      end
    end
    if chosenForeign[16] && chosenForeign[16]!=""
      newEVs=chosenForeign[16]
      pokemon.ev[PBStats::HP]=newEVs[0]
      pokemon.ev[PBStats::ATTACK]=newEVs[1]
      pokemon.ev[PBStats::DEFENSE]=newEVs[2]
      pokemon.ev[PBStats::SPATK]=newEVs[3]
      pokemon.ev[PBStats::SPDEF]=newEVs[4]
      pokemon.ev[PBStats::SPEED]=newEVs[5]
    end
    if chosenForeign[17] && chosenForeign[17]!=""
      newMoves=chosenForeign[17]
      for i in 0...newMoves.length
        move=newMoves[i]
        pokemon.pbLearnMove(move)
      end
    end
   if chosenForeign[18] && chosenForeign[18]!=""
     pokemon.setAbility(chosenForeign[18])
    end
  #memories
  # if chosenForeign[20] && chosenForeign[20]!=""
     # $PokemonGlobal.foreignPokemon[idxForeign].memory=chosenForeign[20]
  # end
  $PokemonGlobal.foreignPokemon[idxForeign]=pokemon
  # Set some battle rules
  setBattleRule("single")
  # Perform the battle
  decision = pbWildBattleCore($PokemonGlobal.foreignPokemon[idxForeign])
  # Update Foreign Pokémon data based on result of battle
  if decision==1 || decision==4   # Defeated or caught
    $PokemonGlobal.foreignPokemon[idxForeign]       = true
    $PokemonGlobal.foreignPokemonCaught[idxForeign] = (decision==4)
  end
  $PokemonGlobal.foreignEncounter = nil
  # Used by the Poké Radar to update/break the chain
  Events.onWildBattleEnd.trigger(nil,species,level,decision)
  # Return false if the player lost or drew the battle, and true if any other result
  return (decision!=2 && decision!=5)
end

EncounterModifier.registerEncounterEnd(proc {
  $PokemonTemp.foreignIndex = nil
})