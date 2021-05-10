################################################################################
############# PLACE THIS IN A NEW SCRIPT SECTION RIGHT ABOVE MAIN! #############
################################################################################

###################################
############# REQUIRED ############
###################################
Events.onMapUpdate+=proc{|sender,e|
  if !$achievementmessagequeue.nil?
    $achievementmessagequeue.each_with_index{|m,i|
      $achievementmessagequeue.delete_at(i)
      Kernel.pbMessage(m)
    }
  end
}

###################################
########### END REQUIRED ##########
###################################
Events.onStepTaken+=proc{|sender,e|
  if !$PokemonGlobal.stepcount.nil?
    Achievements.setProgress("STEPS",$PokemonGlobal.stepcount)
  end
}

Events.onEndBattle+=proc {|sender,e|
  decision = e[0]
  if decision==4
    Achievements.incrementProgress("POKEMON_CAUGHT",1)
  end
  if decision==1
    Achievements.incrementProgress("POKEMON_KOED",1)
  end
}

class PokeBattle_Battler
  alias achieve_pbFaint pbFaint
  def pbFaint(*args)
    achieve_pbFaint(*args)
    Achievements.incrementProgress("FAINTED_POKEMON",1) if @battle.pbOwnedByPlayer?(self.index)
  end
  
  alias achieve_pbUseMove pbUseMove
  def pbUseMove(*args)
    achieve_pbUseMove(*args)
    Achievements.incrementProgress("MOVES_USED",1) if @battle.pbOwnedByPlayer?(self.index) 
  end
end

class PokeBattle_Battle
  alias achieve_pbMegaEvolve pbMegaEvolve
  def pbMegaEvolve(index)
    achieve_pbMegaEvolve(index)
    return if !pbOwnedByPlayer?(index)
    if @battlers[index].isMega?
      Achievements.incrementProgress("MEGA_EVOLUTIONS",1)
    end
  end
  
  alias achieve_pbPrimalReversion pbPrimalReversion
  def pbPrimalReversion(index)
    achieve_pbPrimalReversion(index)
    return if !pbOwnedByPlayer?(index)
    if @battlers[index].isPrimal?
      Achievements.incrementProgress("PRIMAL_REVERSIONS",1)
    end
  end
  alias achieve_pbUseItemOnPokemon pbUseItemOnPokemon
  def pbUseItemOnPokemon(item,pkmnIndex,userPkmn,scene)
    ret=achieve_pbUseItemOnPokemon(item,pkmnIndex,userPkmn,scene)
    if pbOwnedByPlayer?(userPkmn.index) && ret
      Achievements.incrementProgress("ITEMS_USED",1)
      Achievements.incrementProgress("ITEMS_USED_IN_BATTLE",1)
    end
  end
  
  alias achieve_pbUseItemOnBattler pbUseItemOnBattler
  def pbUseItemOnBattler(item,index,userPkmn,scene)
    ret=achieve_pbUseItemOnBattler(item,index,userPkmn,scene)
    if pbOwnedByPlayer?(userPkmn.index) && ret
      Achievements.incrementProgress("ITEMS_USED",1)
      Achievements.incrementProgress("ITEMS_USED_IN_BATTLE",1)
    end
  end
end

alias achieve_pbUseItem pbUseItem
def pbUseItem(*args)
  ret=achieve_pbUseItem(*args)
  if ret==1 || ret==3
    Achievements.incrementProgress("ITEMS_USED",1)
  end
end

alias achieve_pbUseItemOnPokemon pbUseItemOnPokemon
def pbUseItemOnPokemon(*args)
  ret=achieve_pbUseItemOnPokemon(*args)
  if ret
    Achievements.incrementProgress("ITEMS_USED",1)
  end
end


module Kernel
  class << self
    alias achieve_pbItemBall pbItemBall
    def pbItemBall(*args)
      ret=achieve_pbItemBall(*args)
      Achievements.incrementProgress("ITEM_BALL_ITEMS",1) if ret
      return ret
    end
  end
end