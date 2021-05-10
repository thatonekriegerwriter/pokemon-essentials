#==CONFIGURATION================================================================

# OPTION 1: Connected Maps; You get one encounter per map, or map array.ko
# example: (It's an array of arrays, simple as that, just mimic the example)

# 		SUBOPTION 1: Dupes Clause (same species encounter doesn't count)

# 		SUBOPTION 2: Shiny Catch Clause (you can always catch a shiny mon)

# 		SUBOPTION 3: Static (you can always catch an overworld mon)
#
NUZLOCKEMAPS = [
[4],
[5],
[243],
[6,65],
[64],
[15],
[7],
[8],
[9],
[12],
[14],
[1],
[2],
[3],
[10],
[11],
[13],
[15],
[16],
[17],
[18],
[19],
[20],
[21],
[22],
[23],
[24],
[25],
[26],
[27],
[28],
[29],
[30],
[31],
[32],
[33],
[34],
[35],
[36],
[37],
[38],
[39],
[40],
[41],
[42],
[43],
[44],
[45],
[46],
[47],
[48],
[49],
[50],
[51],
[52],
[53],
[54],
[55],
[56],
[57],
[58],
[59],
[60],
[61],
[62],
[63],
[64],
[66],
[67],
[68],
[69],
[70],
[71],
[72],
[73],
[74],
[75],
[76],
[77],
[78],
[79],
[80],
[81],
[82],
[83],
[84],
[85],
[86],
[87],
[88],
[89],
[90],
[91],
[92],
[93],
[94],
[95],
[96],
[97],
[98],
[99],
[100],
[101],
[102],
[103],
[104],
[105],
[106],
[107],
[108],
[109],
[110],
[111],
[112],
[113],
[114],
[115],
[116],
[117],
[118],
[119],
[120],
[121],
[122],
[123],
[124],
[125],
[126],
[127],
[128],
[129],
[130],
[131],
[132],
[133],
[134],
[135],
[136],
[137],
[138],
[139],
[140],
[141],
[142],
[143],
[144],
[145],
[146],
[147],
[148],
[149],
[150],
[151],
[152],
[153],
[154],
[155],
[156],
[157],
[158],
[159],
[160],
[161],
[162],
[163],
[164],
[165],
[166],
[167],
[168],
[169],
[170],
[171],
[172],
[173],
[174],
[175],
[176],
[177],
[178],
[179],
[180],
[181],
[182],
[183],
[184],
[185],
[186],
[187],
[188],
[189],
[190],
[191],
[192],
[193],
[194],
[195],
[196],
[197],
[198],
[199],
[200],
[201],
[202],
[203],
[204],
[205],
[206],
[207],
[208],
[209],
[210],
[211],
[212],
[213],
[214],
[215],
[216],
[217],
[218],
[219],
[220],
[221],
[222],
[223],
[224],
[225],
[226],
[227],
[228],
[229],
[230],
[231],
[232],
[233],
[234],
[235],
[236],
[237],
[238],
[239],
[240],
[241],
[242],
[243],
[244],
[245],
[246],
[247],
[248],
[249],
[250],
[251],
[252],
[253],
[254],
[255],
[256],
[257],
[258],
[259],
[260],
[261],
[262],
[263],
[264],
[265],
[266],
[267],
[268],
[269],
[270],
[271],
[272],
[273],
[274],
[275],
[276],
[277]
]
# OPTION 3: Permadeath (Upon the End of Battle, or Death by Poison in field, the Pokemon is promptly deleted)
# 
#
# OPTION 4: PC Death (Upon the End of Battle, or Death by Poison in field, the Pokemon is automagically put in the PC) 
# 
#
# OPTION 5: Player Controlled Death (The Nuzlocke can function just fine without either of those options, you are just controlling if a pokemon is 'dead')
# 
#
# OPTION 6: No Revives (Upon a Pokemon Fainting, Revival Items do not work on it)
# 
#
# OPTION 7: No Center Healing (Pokemon Centers do not Revive the Pokemon upon usage.)
#
# $PokemonGlobal.nuzlocke  $PokemonGlobal.nuzlockeMaps  $PokemonGlobal.dubiousclause $PokemonGlobal.nuznorevives
# $PokemonGlobal.shinycatchclause $PokemonGlobal.permadeath  $PokemonGlobal.nuzsoft $PokemonGlobal.nuznocenters
#===============================================================================

class PokemonGlobalMetadata
  attr_accessor :nuzlocke 
  attr_accessor :nuzlockeMaps
  attr_accessor :dubiousclause
  attr_accessor :shinycatchclause
  attr_accessor :permadeath
  attr_accessor :nuzsoft
  attr_accessor :nuznorevives
  attr_accessor :nuznocenters

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
  # Stores fainted Pokemon until end of battle (like a "purgatory")
  attr_accessor :faintedlist
  
  
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
	  if $PokemonGlobal.shinycatchclause && isShiny?
        nuzlocke_ThrowPokeBall(idxPokemon,ball,rareness=nil)
        return
	  end
	  if ($PokemonGlobal.dubiousclause && !@battlers[1].owned)
        nuzlocke_ThrowPokeBall(idxPokemon,ball,rareness=nil)
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
        $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,1]) if !$PokemonGlobal.dubiousclause
        $PokemonGlobal.nuzlockeMaps.push([$game_map.map_id,1]) if ($PokemonGlobal.nuzlocke && !@battlers[1].owned)
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

Events.onEndBattle += proc { |_sender,e|
  decision=e[0]
 if $PokemonGlobal.permadeath==true  
     for pindex in 0...$Trainer.party.length
      pbRemoveFaintedPokemonAt(pindex)
     if @pokemon.hasItem?
       # Informs player that fainted's held item was transferred to bag
       @battle.pbDisplayPaused(_INTL("{1} is dead! You picked up its {2}.",
           pbThis, PBItems.getName(@pokemon.item)))
        else
       @battle.pbDisplayPaused(_INTL("{1} is dead!",pbThis))
	  end
 if $PokemonGlobal.nuzsoft==true
   for pindex in 0...$Trainer.party.length
    pbRemoveFaintedPokemonAt(pindex)
      for i in @faintedlist
        storedbox = $PokemonStorage.pbStoreCaught(i)
      end
   if @pokemon.hasItem?
     # Informs player that fainted's held item was transferred to bag
     @battle.pbDisplayPaused(_INTL("{1} is dead! You picked up its {2}.",
         pbThis, PBItems.getName(@pokemon.item)))
      else
     @battle.pbDisplayPaused(_INTL("{1} is dead!",pbThis))
	end
   end
 end
end
end
}

Events.onStepTakenTransferPossible+=proc {
if $PokemonGlobal.permadeath==true
   for pindex in 0...5
    pbRemoveFaintedPokemonAt(pindex)
   if @pokemon.hasItem?
     # Informs player that fainted's held item was transferred to bag
     @battle.pbDisplayPaused(_INTL("{1} is dead! You picked up its {2}.",
         pbThis, PBItems.getName(@pokemon.item)))
      else
     @battle.pbDisplayPaused(_INTL("{1} is dead!",pbThis))
	end
if $PokemonGlobal.nuzsoft==true
   for pindex in 0...$Trainer.party.length
    pbRemoveFaintedPokemonAt(pindex)
      for i in @faintedlist
        storedbox = $PokemonStorage.pbStoreCaught(i)
      end
   if @pokemon.hasItem?
     # Informs player that fainted's held item was transferred to bag
     @battle.pbDisplayPaused(_INTL("{1} is dead! You picked up its {2}.",
         pbThis, PBItems.getName(@pokemon.item)))
      else
     @battle.pbDisplayPaused(_INTL("{1} is dead!",pbThis))
	end
   end
end
end
end
}
  alias nuzlocke_heal heal
  def heal
    return if hp<=0 && $PokemonGlobal.nuznorevives
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
    if $PokemonGlobal.nuznocenters
      if i.hp > 0
        i.heal
      end
    else
    i.heal
    end
  end
end