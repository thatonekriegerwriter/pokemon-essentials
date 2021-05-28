#===============================================================================
#  Modular Pause Menu
#    by Luka S.J.
# ---------------- 
#  Provides only features present in the default version of the Pokedex in
#  Essentials. Mean as a new cosmetic overhaul, adhering to the UI design
#  language of the Elite Battle System: The Next Generation
#
#  Enjoy the script, and make sure to give credit!
#-------------------------------------------------------------------------------
#  load script
#===============================================================================
# set up plugin metadata
if defined?(PluginManager)
  PluginManager.register({
    :name => "Modular Menu",
    :version => "1.3",
    :link => "https://luka-sj.com/res/modmn",
    :dependencies => [
      ["Luka's Scripting Utilities", "3.0"]
    ],
    :credits => ["Luka S.J."]
  })
else
  raise "This script is only compatible with Essentials v18.x!"
end
File.runScript("Data/Plugins/MODMN.rxdata")
#-------------------------------------------------------------------------------
#  Your own entries for the pause menu
#
#  How to use
#
#  MenuHandlers.addEntry(:name,"button text","icon name",proc{|menu|
#    # code you want to run
#    # when the entry in the menu is selected
#  },proc{ # code to check if menu entry is available })
#-------------------------------------------------------------------------------
# PokeDex
MenuHandlers.addEntry(:POKEDEX,_INTL("Pokédex"),"menuPokedex",proc{|menu|
  if USE_CURRENT_REGION_DEX
    pbFadeOutIn(99999){
      scene = PokemonPokedex_Scene.new
      screen = PokemonPokedexScreen.new(scene)
      screen.pbStartScreen
      menu.refresh
    }
  else
    if $PokemonGlobal.pokedexViable.length==1
      $PokemonGlobal.pokedexDex = $PokemonGlobal.pokedexViable[0]
      $PokemonGlobal.pokedexDex = -1 if $PokemonGlobal.pokedexDex==$PokemonGlobal.pokedexUnlocked.length-1
      pbFadeOutIn(99999){
        scene = PokemonPokedex_Scene.new
        screen = PokemonPokedexScreen.new(scene)
        screen.pbStartScreen
        menu.refresh
      }
    else
      pbFadeOutIn(99999){
        scene = PokemonPokedexMenu_Scene.new
        screen = PokemonPokedexMenuScreen.new(scene)
        screen.pbStartScreen
        menu.refresh
      }
    end
  end
},proc{ return $Trainer.pokedex && $PokemonGlobal.pokedexViable.length > 0 })
# Party Screen
MenuHandlers.addEntry(:POKEMON,_INTL("Pokémon"),"menuPokemon",proc{|menu|
  sscene = PokemonParty_Scene.new
  sscreen = PokemonPartyScreen.new(sscene,$Trainer.party)
  hiddenmove = nil
  pbFadeOutIn(99999) { 
    hiddenmove = sscreen.pbPokemonScreen
    if hiddenmove
      menu.pbEndScene
      menu.endscene = false
    end
  }
  if hiddenmove
    Kernel.pbUseHiddenMove(hiddenmove[0],hiddenmove[1])
    menu.close = true
  end
},proc{ return $Trainer.party.length > 0 })
# Crafting Screen
MenuHandlers.addEntry(:CRAFTING,_INTL("Crafting"),"menuCrafting",proc{|menu|
  pbFadeOutIn(99999) { 
    pbCommonEvent(19)
    menu.refresh
  }
},proc{ return true })
# Bag Screen
MenuHandlers.addEntry(:BAG,_INTL("Bag"),"menuBag",proc{|menu|
  item = 0
  scene = PokemonBag_Scene.new
  screen = PokemonBagScreen.new(scene,$PokemonBag)
  pbFadeOutIn(99999) { 
  item = screen.pbStartScreen 
  if item > 0
    menu.pbEndScene
    menu.endscene = false
  end
  }
  if item > 0
    Kernel.pbUseKeyItemInField(item)
    menu.close = true
  end
},proc{ return true })
# Save Screen
MenuHandlers.addEntry(:SAVE,_INTL("Save"),"menuSave",proc{|menu|
  scene = PokemonSave_Scene.new
  screen = PokemonSaveScreen.new(scene)
  menu.pbEndScene
  menu.endscene = false
  if screen.pbSaveScreen
    menu.close = true
  else
    menu.pbStartScene
    menu.pbShowMenu
    menu.close = false
  end
},proc{ return !$game_system || !$game_system.save_disabled && !(pbInSafari? || pbInBugContest?)})
# Trainer Card
MenuHandlers.addEntry(:TRAINER,_INTL("\\pn"),"menuTrainer",proc{|menu|
  scene = PokemonTrainerCard_Scene.new
  screen = PokemonTrainerCardScreen.new(scene)
  pbFadeOutIn(99999) { 
    screen.pbStartScreen
  }
},proc{ return true })
# Quit Safari-Zone
MenuHandlers.addEntry(:QUIT,_INTL("\\contest"),"menuQuit",proc{|menu|
  if pbInSafari?
    if Kernel.pbConfirmMessage(_INTL("Would you like to leave the Safari Game right now?"))
      menu.pbEndScene
      menu.endscene = false
      menu.close = true
      pbSafariState.decision=1
      pbSafariState.pbGoToStart
    end
  else
    if Kernel.pbConfirmMessage(_INTL("Would you like to end the Contest now?"))
      menu.pbEndScene
      menu.endscene = false
      menu.close = true
      pbBugContestState.pbStartJudging
      return
    end
  end
},proc{ return pbInSafari? || pbInBugContest? })
# Achievements
MenuHandlers.addEntry(:ACHIEVEMENTS,_INTL("Achievements"),"menuAchievements",proc{|menu|
  scene = PokemonAchievements_Scene.new
  screen = PokemonAchievements.new(scene)
  pbFadeOutIn(99999) { 
    screen.pbStartScreen
  }
},proc{ return true })
# Quest Menü
MenuHandlers.addEntry(:QUESTS,_INTL("Quests"),"menuQuests",proc{|menu|
    scene = QuestScene.new
    screen = QuestScreen.new(scene)
    pbFadeOutIn(99999) { 
      screen.pbStartScreen
  }
},proc{ return true })
# Options Screen
MenuHandlers.addEntry(:OPTIONS,_INTL("Options"),"menuOptions",proc{|menu|
  scene = PokemonOption_Scene.new
  screen = PokemonOptionScreen.new(scene)
  pbFadeOutIn(99999) {
    screen.pbStartScreen
    pbUpdateSceneMap
  }
},proc{ return true })
# Debug Menu
MenuHandlers.addEntry(:DEBUG,_INTL("Debug"),"menuDebug",proc{|menu|
  pbFadeOutIn(99999) { 
    pbDebugMenu
    menu.refresh
  }
},proc{ return $DEBUG })
# Backup Screen
MenuHandlers.addEntry(:BACKUP,_INTL("Backup"),"menuBack",proc{|menu|
  pbFadeOutIn(99999) { 
    pbHardSave
    pbMessage(_INTL("\\se[]{1} backed up the game.\\me[GUI save game]\\wtnp[30]",$Trainer.name))
    menu.refresh
  }
},proc{ return true })
# End Screen
MenuHandlers.addEntry(:EXIT,_INTL("Exit"),"exitOptions",proc{|menu|
  pbFadeOutIn(99999) {
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
  }
},proc{ return true })