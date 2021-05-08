###---EDIT---###
Events.onEndBattle+=proc {|sender,e|
  decision=e[0]
  if $game_switches[54]==true
    for pindex in 0...$Trainer.party.length
      pbRemoveFaintedPokemonAt(pindex)
    end
  end
  if decision!=2 && decision!=5 # not a loss or a draw
    if $PokemonTemp.evolutionLevels
      pbEvolutionCheck($PokemonTemp.evolutionLevels)
      $PokemonTemp.evolutionLevels=nil
    end
  end
  if decision==1
    if $game_switches[100]==false
      $game_switches[100]=true
      pbAchievementGet(0)
    end
    for pkmn in $Trainer.party
      Kernel.pbPickup(pkmn)
      if isConst?(pkmn.ability,PBAbilities,:HONEYGATHER) && !pkmn.egg? && pkmn.item==0
        if hasConst?(PBItems,:HONEY)
          chance = 5 + ((pkmn.level-1)/10)*5
          pkmn.item=getConst(PBItems,:HONEY) if rand(100)<chance
        end
      end
    end
  end
}
###---EDIT END---###


#These were both field class


###---EDIT---###
# Poison event on each step taken
Events.onStepTakenTransferPossible+=proc {|sender,e|
  handled=e[0]

  if $game_switches[54]==true
    for pindex in 0...5
      pbRemoveFaintedPokemonAt(pindex)
    end
  end
  next if handled[0]
  if $PokemonGlobal.stepcount % 4 == 0 && POISONINFIELD
    flashed=false
    for i in $Trainer.party
      if i.status==PBStatuses::POISON && i.hp>0 && !i.egg? &&
         !isConst?(i.ability,PBAbilities,:POISONHEAL)
        if !flashed
          $game_screen.start_flash(Color.new(255,0,0,128), 4)
          flashed=true
        end
        if i.hp==1 && !POISONFAINTINFIELD
          i.status=0
          Kernel.pbMessage(_INTL("{1} survived the poisoning.\\nThe poison faded away!\\1",i.name))
          next
        end
        i.hp-=1
        if i.hp==1 && !POISONFAINTINFIELD
          i.status=0
          Kernel.pbMessage(_INTL("{1} survived the poisoning.\\nThe poison faded away!\\1",i.name))
        end
        if i.hp==0
          i.changeHappiness("faint")
          i.status=0
          if $game_switches[54]!=true
            Kernel.pbMessage(_INTL("{1} fainted...\\1",i.name))
          end
        end
        handled[0]=true if pbAllFainted
        pbCheckAllFainted()
      end
    end
  end
}
###---EDIT END---###


