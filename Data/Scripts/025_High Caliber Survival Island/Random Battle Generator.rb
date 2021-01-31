################################################################################
# Random Trainer/Pokemon Generator
# Original By Rei
# Port by PDM20
# Credits Required
################################################################################
# A Module with some handy Generation tools for Trainers and Wild Pokemon
################################################################################

module BattleGenerator
 
  # The maximum level for each difficulty
  EasyPokemon = 25
  MediumPokemon = 40
  HardPokemon = 60
  ExtremePokemon = 100
 
  # Pokemon that cannot, no matter what be generated.
  BLACK_LIST = [
    PBSpecies::MEWTWO,
    PBSpecies::MEW,
    PBSpecies::HOOH,
    PBSpecies::LUGIA,
    PBSpecies::CELEBI,
    PBSpecies::KYOGRE,
    PBSpecies::GROUDON,
    PBSpecies::RAYQUAZA,
    PBSpecies::DEOXYS,
    PBSpecies::JIRACHI,
    PBSpecies::DIALGA,
    PBSpecies::PALKIA,
    PBSpecies::GIRATINA,
    PBSpecies::HEATRAN,
    PBSpecies::DARKRAI,
    PBSpecies::SHAYMIN,
    PBSpecies::ARCEUS,
    PBSpecies::ZEKROM,
    PBSpecies::RESHIRAM,
    PBSpecies::KYUREM,
    PBSpecies::LANDORUS,
    PBSpecies::MELOETTA,
    PBSpecies::KELDEO,
    PBSpecies::GENESECT
  ]
 
  # Calculates the difficulty based on your party pokemon's level
  def self.calcDifficulty
    lv = [EasyPokemon, MediumPokemon, HardPokemon, ExtremePokemon]
     pparty = pbBalancedLevel($Trainer.party)
     for i in 0...lv.length
       if pparty <= lv[i]
         break
       end
     end
     return i
   end
  
   # calculates the maximum level via difficulty
   def self.calcMaxLevel(difficulty)
     maxl = 100
    if difficulty < 1
      maxl = EasyPokemon
    elsif difficulty == 1
      maxl = MediumPokemon
    elsif difficulty == 2
      maxl = HardPokemon
    elsif difficulty >= 3
      maxl = ExtremePokemon
    end
    return maxl
   end
 
  # Sets an event's graphic to the generated trainer's graphic
  def self.setTrainerGraphic(trainer, eventID)
    name = ""
    name += "0" if trainer[0].trainertype < 10
    name += "0" if trainer[0].trainertype < 100
    name += trainer[0].trainertype.to_s
    $game_map.events[eventID].character_name = "trchar" + name
  end
 
  def self.getTrainerTypeGender(trainertype)
    ret=2   # 2 = gender unknown
    pbRgssOpen("Data/trainer_types.dat","rb"){|f|
       trainertypes=Marshal.load(f)
       if !trainertypes[trainertype]
         ret=2
       else
         ret=trainertypes[trainertype][7]
         ret=2 if !ret
       end
    }
    return ret
  end
 
  #### Generates amount amount of trainers into random trainers!
  #### You can also set difficulty and party size
  def self.generateMapTrainers(vsT, vsO, amount, difficulty, min_size = 3, max_size = -1)
    max_size = min_size if max_size < min_size
    available_events = $game_map.events.clone
    for key in available_events.keys
      if !available_events[key].name.include?("Trainer(")
        available_events.delete(key)
      end
    end
    amount = available_events.keys.length if amount > available_events.keys.length
    if defined?(PCV)
     if vsT >=3 || vsO >=3
      $PokemonSystem.activebattle=true
     end
    end
    for i in 0...amount
      key = available_events.keys[rand(available_events.keys.length)]
      event = available_events[key]
      trainer = generateTrainer(difficulty, rand(max_size - min_size - 1) + min_size)
      setTrainerGraphic(trainer, key)
      event.trainer = trainer
      event.setTriggerToEvent
      pbPushBranch(event.list, "$game_map.events[#{key}].tsOn?('battle')")
      pbPushText(event.list, trainer[2], 1)
      pbPushExit(event.list,1)
      pbPushBranchEnd(event.list)
      pbPushScript(event.list, "pbTrainerIntro(:FISHERMAN)")
      pbPushScript(event.list, "Kernel.pbNoticePlayer(get_character(0))")
      if vsT==1
       if vsO==1
        pbPushBranch(event.list, "setBattleRule('1v1')")
       elsif vsO==2
        pbPushBranch(event.list, "setBattleRule('1v2')")
       elsif vsO==3
        pbPushBranch(event.list, "setBattleRule('1v3')")
       elsif vsO==4 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('1v4')")
       elsif vsO==5 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('1v5')")
       end
      elsif vsT==2
       if vsO==1
        pbPushBranch(event.list, "setBattleRule('2v1')")
       elsif vsO==2
        pbPushBranch(event.list, "setBattleRule('2v2')")
       elsif vsO==3
        pbPushBranch(event.list, "setBattleRule('2v3')")
       elsif vsO==4 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('2v4')")
       elsif vsO==5 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('2v5')")
       end
      elsif vsT==3
       if vsO==1
        pbPushBranch(event.list, "setBattleRule('3v1')")
       elsif vsO==2
        pbPushBranch(event.list, "setBattleRule('3v2')")
       elsif vsO==3
        pbPushBranch(event.list, "setBattleRule('3v3')")
       elsif vsO==4 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('3v4')")
       elsif vsO==5 && defined?(PCV)
        pbPushBranch(event.list, "setBattleRule('3v5')")
       end
      elsif vsT==4 && defined?(PCV)
       if vsO==1
        pbPushBranch(event.list, "setBattleRule('4v1')")
       elsif vsO==2
        pbPushBranch(event.list, "setBattleRule('4v2')")
       elsif vsO==3
        pbPushBranch(event.list, "setBattleRule('4v3')")
       elsif vsO==4
        pbPushBranch(event.list, "setBattleRule('4v4')")
       elsif vsO==5
        pbPushBranch(event.list, "setBattleRule('4v5')")
       end
      elsif vsT==5 && defined?(PCV)
       if vsO==1
        pbPushBranch(event.list, "setBattleRule('5v1')")
       elsif vsO==2
        pbPushBranch(event.list, "setBattleRule('5v2')")
       elsif vsO==3
        pbPushBranch(event.list, "setBattleRule('5v3')")
       elsif vsO==4
        pbPushBranch(event.list, "setBattleRule('5v4')")
       elsif vsO==5
        pbPushBranch(event.list, "setBattleRule('5v5')")
       end
      end
      pbPushBranch(event.list, "BattleGenerator.generateBattle($game_map.events[#{key}].trainer) == 1")
      pbPushScript(event.list, "$game_map.events[#{key}].setTempSwitchOn('battle')", 1)
      pbPushScript(event.list, "$game_map.events[#{key}].setTriggerToAction", 1)
      pbPushBranchEnd(event.list)
      pbPushScript(event.list, "pbTrainerEnd")
    end
  end
 
  # Generates a battle, the parameter difficulty can be trainer data
  # if you already generated a trainer
  def self.generateBattle(difficulty)
    trainer = difficulty
    trainer = generateTrainer(difficulty) if !difficulty.is_a?(Array)
    Kernel.pbMessage(_INTL(trainer[1]))
    scene=pbNewBattleScene
    battle=PokeBattle_Battle.new(scene,$Trainer.party,
    trainer[0].party,$Trainer,trainer[0])
    trainerbgm=pbGetTrainerBattleBGM(trainer[0])
    pbPrepareBattle(battle)

    restorebgm=true
    decision=0
    pbMEFade
    pbBattleAnimation(trainerbgm,trainer[0].trainertype,trainer[0].name) {
    if defined?(PCV)
     if $PokemonSystem.activebattle==true
      newWindowSize
      Win32API.restoreScreen
     end
    end
    pbSceneStandby {
        decision=battle.pbStartBattle
     }
    }
    if defined?(PCV)
     if $PokemonSystem.activebattle==true
        $PokemonSystem.activebattle=false
      newWindowSize
      Win32API.restoreScreen
     end
    end
   return decision
  end
 
  # Generates a trainer based on difficulty (-1 means it will calculate difficulty
  # based on your party's level)
  def self.generateTrainer(difficulty, size = 3, forcedTypes = nil)
    if difficulty < 0
       difficulty = calcDifficulty
    end
    trainers = pbGetBTTrainers(0) # only normal battle tower trainers
    trainer = trainers[rand(trainers.length)]
    gender = getTrainerTypeGender(trainer[0])
    # Get a new random trainer type
    if forcedTypes
      while (forcedTypes.length > 0)
        type = forcedTypes[rand(forcedTypes.length)]
        cgender = getTrainerTypeGender(type)
        if gender == cgender
          trainer[0] = type
          break
        end
      end
    end
    
    tr = PokeBattle_Trainer.new(trainer[1], trainer[0])
    tr.party = generateParty(difficulty, size)
    
    return [tr, trainer[2], trainer[4]]
  end
 
  # Generates a party of size pokemon
  def self.generateParty(difficulty, size = 3)
    maxl = calcMaxLevel(difficulty)
    party = []
    for i in 0...size
      # Base the level off the trainer party but keep it within bounds
      l = pbBalancedLevel($Trainer.party)
      if difficulty == 0
        l -= 3
      else
        l -= 4 + rand(8)
      end
      if l > maxl
        l = maxl
      end
      pk = generatePokemon(l)
      pkmn = PokeBattle_Pokemon.new(pk, l + 1)
      party.push(pkmn)
    end
    return party
  end
 
  # Generates a wild pokemon based on difficulty (-1 means it will calculate
  # difficulty on your party's level)
  def self.generateWildPokemonData(difficulty = -1)
    if difficulty < 0
       difficulty = calcDifficulty(difficulty)
     end
     maxl = calcMaxLevel
     l = pbBalancedLevel($Trainer.party) - 4 + rand(8)
    if l > maxl
      l = maxl
    end
    species = generatePokemon(level)
    return [species, l]
  end
 
 
  # A Nice little generator for pokemon, it finds a random pokemon then get's
  # it's first evolution and then through a small checksum evolves it if some
  # conditions are met (pokemon can evolve up to 5 levels under the actual
  # evolution data)
  def self.generatePokemon(level)
    species = rand(PBSpecies.maxValue) + 1
    while BLACK_LIST.include?(species)
      rand(PBSpecies.maxValue) + 1
    end
    species = pbGetBabySpecies(species) # revert to the first evolution
    item = 0
    loop do
      nl = level + 5
      nl = MAXIMUM_LEVEL if nl > MAXIMUM_LEVEL
      pkmn = PokeBattle_Pokemon.new(species, nl)
      cevo = Kernel.pbCheckEvolution(pkmn)
      evo = pbGetEvolvedFormData(species)
      if evo
        evo = evo[rand(evo.length - 1)]
        # evolve the species if we can't evolve and there is an evolution
        # and a bit of randomness passes as well as the evolution type cannot
        # be by level
        if evo && cevo < 1 && rand(MAXIMUM_LEVEL) <= level
          species = evo[2] if evo[0] != 4 && rand(MAXIMUM_LEVEL) <= level
        end
      end
      if cevo == -1 || (rand(MAXIMUM_LEVEL) > level && level < 60)
        # ^ Only break the loop if there is no more evolutions or some randomness
        # applies and the level is under 60
        break
      else
        species = evo[2]
      end
    end
     return species
  end
end

class Game_Event
  attr_accessor :trainer
 
  def setTriggerToAction
    @trigger = 0
  end
 
  def setTriggerToEvent
    @trigger = 2
  end
end