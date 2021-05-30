#===============================================================================
# Pokémon Outbreaks - By Vendily [v17/v18] - v2.1
#===============================================================================
# This script adds in the Mass outbreak of pokemon that appear on a random map.
# It uses the Gen 4 version of the mechanics, so when the save is loaded, if
#  there is no active outbreak and the switch is active, will pick one outbreak
#  at random and spawn them at a 40% encounter rate. Feel free to change that of
#  course.
#===============================================================================
# This script includes some utility functions, such as the ability to 
#  randomly set a new outbreak at will with pbGenerateOutbreak, and get the
#  location and species of an outbreak, pbOutbreakInformation (which can save in 
#  two variables,  for species and map in that order). The variables contain
#  strings for names, or -1 if there is no outbreak. It will also return the map
#  id and species index for your scripting uses.
#===============================================================================
# * The length of time that an encounter will last in hours. (Default 24)
# * The percent chance an outbroken pokemon will spawn in place of
#    a regular one. (Default 40)
# * The switch used to enable outbreaks. (Default 100)
# * A set of arrays each containing details of a wild encounter that can only
#      occur via Pokemon Outbreaks. The information within is as follows:
#      - Map ID on which this encounter can occur.
#      - Species.
#      - Minimum possible level.
#      - Maximum possible level.
#      - Allowed encounter types.
#===============================================================================
begin
PluginManager.register({
  :name    => "Pokémon Outbreaks",
  :version => "2.1",
  :link    => "https://reliccastle.com/resources/266/",
  :credits => "Vendily"
})
rescue
  # not v18
end

OUTBREAK_TIME    = 24
OUTBREAK_CHANCE  = 40
OUTBREAK_SWITCH  = 491
OUTBREAK_SPECIES = [
    [4,:MONFERNO,28,28,[EncounterTypes::Land]],
    [13,:MILTANK,28,29,[EncounterTypes::Land,EncounterTypes::LandDay]],
    [16,:SNORLAX,28,29,[EncounterTypes::Land]],
    [200,:SCOLIPEDE,28,29,[EncounterTypes::Cave]],
    [201,:SCOLIPEDE,28,29,[EncounterTypes::Cave]],
    [5,:SURSKIT,28,29,[EncounterTypes::Water]]
    ]
class PokemonGlobalMetadata
  attr_accessor :currentOutbreak
end

EncounterModifier.register(proc {|encounter|
   return encounter if !encounter
   return encounter if !$game_switches[OUTBREAK_SWITCH]
   if !$PokemonGlobal.currentOutbreak ||
     $PokemonGlobal.currentOutbreak[0]<=-1 ||
     ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
     $PokemonGlobal.currentOutbreak=[-1,nil]
   end
   if $PokemonGlobal.currentOutbreak[0]>-1
     newenc=OUTBREAK_SPECIES[$PokemonGlobal.currentOutbreak[0]]
     return encounter if $game_map && $game_map.map_id!=newenc[0]
     return encouter if !newenc[4].include?($PokemonEncounters.pbEncounterType)
     if rand(100)<OUTBREAK_CHANCE
       level=rand(newenc[3]-newenc[2])+newenc[2]
       return [getID(PBSpecies,newenc[1]),level]
     end
   end
   return encounter
})

Events.onMapUpdate+=proc {|sender,e|
  next if !$game_switches[OUTBREAK_SWITCH]
  if !$PokemonGlobal.currentOutbreak ||
     $PokemonGlobal.currentOutbreak[0]<=-1 ||
     ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
     pbGenerateOutbreak
  end
}

def pbGenerateOutbreak
  index=rand(OUTBREAK_SPECIES.length)
  $PokemonGlobal.currentOutbreak=[index,pbGetTimeNow]
end

def pbOutbreakInformation(speciesvar,mapvar)
  if !$PokemonGlobal.currentOutbreak ||
    $PokemonGlobal.currentOutbreak[0]<=-1 ||
    ((pbGetTimeNow-$PokemonGlobal.currentOutbreak[1])>OUTBREAK_TIME*60*60)
      $PokemonGlobal.currentOutbreak=[-1,nil]
      $game_variables[speciesvar]=-1 if speciesvar>0
      $game_variables[mapvar]=-1 if mapvar>0
      return [-1,-1]
  end
  newenc=OUTBREAK_SPECIES[$PokemonGlobal.currentOutbreak[0]]
  species=getID(PBSpecies,newenc[1])
  $game_variables[speciesvar]=PBSpecies.getName(species) if speciesvar>0
  $game_variables[mapvar]=pbGetMessage(MessageTypes::MapNames,newenc[0]) if mapvar>0
  return [newenc[0],species]
end