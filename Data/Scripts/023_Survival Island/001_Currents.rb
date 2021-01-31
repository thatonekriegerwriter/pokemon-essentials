# You can find and add the different, if you don't know, just add above main
module PBTerrain
  CurrentLeft = 35
  CurrentUp = 34
  CurrentRight = 33
  CurrentDown = 32

  def self.isJustWater?(tag)
    return tag==PBTerrain::Water ||
           tag==PBTerrain::StillWater ||
           tag==PBTerrain::DeepWater ||
           tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end

  def PBTerrain.isLeft?(tag)
    return tag==PBTerrain::CurrentLeft
  end

  def PBTerrain.isRight?(tag)
    return tag==PBTerrain::CurrentRight
  end

  def PBTerrain.isUp?(tag)
    return tag==PBTerrain::CurrentUp
  end

  def PBTerrain.isDown?(tag)
    return tag==PBTerrain::CurrentDown
  end

  def PBTerrain.isWaterCurrent?(tag)
    return tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end
end
#-------------------------------------------------------------------------------
# You can find and add the different, if you don't know, just add above main
class PokemonEncounters
  def isEncounterPossibleHere?
    if $PokemonGlobal.surfing
      if PBTerrain.isWaterCurrent?($game_map.terrain_tag($game_player.x,$game_player.y))
        return false
      else
        return true
      end
    elsif PBTerrain.isIce?(pbGetTerrainTag($game_player))
      return false
    elsif self.isCave?
      return true
    elsif self.isGrass?
      return PBTerrain.isGrass?($game_map.terrain_tag($game_player.x,$game_player.y))
    end
    return false
  end
end
#-------------------------------------------------------------------------------
# Add below lines above Main
class Scene_Map
  alias old_update_wct update
  def update
    old_update_wct
    # Water current
    pbWaterCurrent
  end
end

def pbWaterCurrent
  if !pbMapInterpreterRunning?
    if $PokemonGlobal.surfing && !$game_player.moving?
      terrain = $game_map.terrain_tag($game_player.x,$game_player.y)
      if PBTerrain.isLeft?(terrain)
        pbUpdateSceneMap
        $game_player.move_left
      elsif PBTerrain.isRight?(terrain)
        pbUpdateSceneMap
        $game_player.move_right
      elsif PBTerrain.isUp?(terrain)
        pbUpdateSceneMap
        $game_player.move_up
      elsif PBTerrain.isDown?(terrain)
        pbUpdateSceneMap
        $game_player.move_down
      end
    end
  end
end