#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Add new methods
#
#-------------------------------------------------------------------------------
class Some_methods_contest
  
  def move_switch_for_transfer(switch='A')
    $game_self_switches[[CONTEST_MAP_BEFORE_PLAY,CONTEST_MOVE_EVENT,switch]] = true
    $game_map.need_refresh = true
    loop do
      break if !$game_self_switches[[CONTEST_MAP_BEFORE_PLAY,CONTEST_MOVE_EVENT,switch]]
      self.wait(1)
    end
  end
  
  def move_switch_for_show_heart(map,event,switch='A')
    $game_self_switches[[map,event,switch]] = true
    $game_map.need_refresh = true
    loop do
      break if !$game_self_switches[[map,event,switch]]
      self.wait(1)
    end
  end
  
  def transferPlayer(id,x,y,face=false)
    @vp = Viewport.new(0,0,Graphics.width,Graphics.height)
    @vp.color = Color.new(0,0,0,0)
    16.times do
      next if @vp.nil?
      @vp.color.alpha += 16
      wait(1)
    end
    $MapFactory = PokemonMapFactory.new(id)
    $game_player.moveto(x, y)
    $game_player.refresh
    if !face
      $game_player.turn_right
    else
      $game_player.turn_down
    end
    $game_map.autoplay
    $game_map.update
    8.times do; Graphics.update; end
    16.times do
      next if @vp.nil?
      @vp.color.alpha -= 16
      wait(1)
    end
  end
  
  def check_pokemon_for_contest(species)
    name = getConstantName(PBSpecies,species) rescue nil
    if !species || species < 1 || species > PBSpecies.maxValue || !name
      raise ArgumentError.new(_INTL("The species number (no. {1} of {2}) is invalid.",species,PBSpecies.maxValue))
      return nil
    end
  end
  
  def wait(frames)
    frames.times do
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
  
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
def pbAddContestMove(poke,move1=0,move2=0,move3=0,move4=0)
  poketochange=[0,0,0,0]
  poketochange[0]=move1; poketochange[1]=move2
  poketochange[2]=move3; poketochange[3]=move4
  case poke
  when 2: (0..3).each {|i| CONTESTMOVE2[i] = poketochange[i]}
  when 3: (0..3).each {|i| CONTESTMOVE3[i] = poketochange[i] }
  when 4: (0..3).each {|i| CONTESTMOVE4[i] = poketochange[i] }
  end
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
def pbChangeContestName(poke,name="")
  if name != "" && name.length<16
    case poke
    when 2: $CONTESTNAME2 = name
    when 3: $CONTESTNAME3 = name
    when 4: $CONTESTNAME4 = name
    end
  end  
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Before play contest (registered)
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class Choose_Contest < Some_methods_contest
  @@num_ribbon = 0
  # Choose pokemon for contest
  def choose
    if $Trainer.party.size < 0
      pbMessage(_INTL("You don't have any Pokemons."))
    else
      pbMessage(_INTL("Hello!"))
      pbMessage(_INTL("This is the reception counter for Pokemon Contest."))
      choice = [_INTL("Enter"),_INTL("Cancel")]
      choose = pbMessage(_INTL("Would you like to enter your Pokemon in our Contest?"),choice,-1)
      case choose
        when 0
          choice2 = [_INTL("Coolness Contest"),_INTL("Beauty Contest"),_INTL("Cuteness Contest"),
          _INTL("Smartness Contest"),_INTL("Toughness Contest"),_INTL("Exit")]
          choose2 = pbMessage(_INTL("Which Contest would you like to enter?"),choice2,-1)
          case choose2
            # Coolness Contest
            when 0
              choice3 = [_INTL("Normal Rank"),_INTL("Super Rank"),_INTL("Hyper Rank"),
              _INTL("Master Rank"),_INTL("Exit")]
              choose3 = pbMessage(_INTL("Which Rank would you like to enter?"),choice3,-1)
              case choose3
                when 0
                  @@num_ribbon = 1
                  choose_pokemon_contest
                when 1
                  @@num_ribbon = 2
                  choose_pokemon_contest
                when 2
                  @@num_ribbon = 3
                  choose_pokemon_contest
                when 3
                  @@num_ribbon = 4
                  choose_pokemon_contest
                when 4,-1: pbMessage(_INTL("We hope you will participate another time."))
              end
            # Beauty Contest  
            when 1
              choice3 = [_INTL("Normal Rank"),_INTL("Super Rank"),_INTL("Hyper Rank"),
              _INTL("Master Rank"),_INTL("Exit")]
              choose3 = pbMessage(_INTL("Which Rank would you like to enter?"),choice3,-1)
              case choose3
                when 0
                  @@num_ribbon = 5
                  choose_pokemon_contest
                when 1
                  @@num_ribbon = 6
                  choose_pokemon_contest
                when 2
                  @@num_ribbon = 7
                  choose_pokemon_contest
                when 3
                  @@num_ribbon = 8
                  choose_pokemon_contest
                when 4,-1: pbMessage(_INTL("We hope you will participate another time."))
              end
            # Cuteness Contest
            when 2
              choice3 = [_INTL("Normal Rank"),_INTL("Super Rank"),_INTL("Hyper Rank"),
              _INTL("Master Rank"),_INTL("Exit")]
              choose3 = pbMessage(_INTL("Which Rank would you like to enter?"),choice3,-1)
              case choose3
                when 0
                  @@num_ribbon = 9
                  choose_pokemon_contest
                when 1
                  @@num_ribbon = 10
                  choose_pokemon_contest
                when 2
                  @@num_ribbon = 11
                  choose_pokemon_contest
                when 3
                  @@num_ribbon = 12
                  choose_pokemon_contest
                when 4,-1: pbMessage(_INTL("We hope you will participate another time."))
              end
            # Smartness Contest
            when 3
              choice3 = [_INTL("Normal Rank"),_INTL("Super Rank"),_INTL("Hyper Rank"),
              _INTL("Master Rank"),_INTL("Exit")]
              choose3 = pbMessage(_INTL("Which Rank would you like to enter?"),choice3,-1)
              case choose3
                when 0
                  @@num_ribbon = 13
                  choose_pokemon_contest
                when 1
                  @@num_ribbon = 14
                  choose_pokemon_contest
                when 2
                  @@num_ribbon = 15
                  choose_pokemon_contest
                when 3
                  @@num_ribbon = 16
                  choose_pokemon_contest
                when 4,-1: pbMessage(_INTL("We hope you will participate another time."))
              end
            # Toughness Contest
            when 4
              choice3 = [_INTL("Normal Rank"),_INTL("Super Rank"),_INTL("Hyper Rank"),
              _INTL("Master Rank"),_INTL("Exit")]
              choose3 = pbMessage(_INTL("Which Rank would you like to enter?"),choice3,-1)
              case choose3
                when 0
                  @@num_ribbon = 17
                  choose_pokemon_contest
                when 1
                  @@num_ribbon = 18
                  choose_pokemon_contest
                when 2
                  @@num_ribbon = 19
                  choose_pokemon_contest
                when 3
                  @@num_ribbon = 20
                  choose_pokemon_contest
                when 4,-1: pbMessage(_INTL("We hope you will participate another time."))
              end
            # Exit
            when 5,-1: pbMessage(_INTL("We hope you will participate another time."))
          end
        # Exit
        when 1,-1
          pbMessage(_INTL("We hope you will participate another time."))
      end
    end
  end
#-------------------------------------------------------------------------------
  # Method choose pokemon.
  def choose_pokemon_contest
    chosen = 0; process = 0; exit = false
    able = ((@@num_ribbon-1)%4 == 0)? proc {|poke|!poke.isEgg? && !(poke.isShadow? rescue false)} : proc {|poke|!poke.isEgg? && !(poke.isShadow? rescue false) && poke.hasRibbon?(@@num_ribbon-1)}
    loop do
      break if exit
      case process
        when 0
          pbFadeOutIn(99999){
          scene = PokemonParty_Scene.new
          screen = PokemonPartyScreen.new(scene,$Trainer.party)
          if able
            chosen=screen.pbChooseAblePokemon(able,false)
            process = 1
          else
            screen.pbStartScene(_INTL("Choose a Pokémon."),false)
            chosen = screen.pbChoosePokemon
            screen.pbEndScene
            process = 1
          end }
        when 1
          Graphics.update
          Input.update
          if chosen >= 0
            if $Trainer.party[chosen].hasRibbon?(@@num_ribbon)
              pbMessage(_INTL("Oh, but that Ribbon..."))
              pbMessage(_INTL("Your Pokemon has won this Contest before, hasn't it?"))
              if Kernel.pbConfirmMessage("Would you like to enter it in this Contest anyway?")
                pbMessage(_INTL("Okay, your Pokemon will be entered in this Contest."))
                pbMessage(_INTL("Your Pokemon is Entry No.4. The Contest will begin shortly."))
                pbSet(Store_pokemon_contest,chosen)
                inf_play; move_player
                exit = true
              else
                pbMessage(_INTL("Which Pokemon would you like to enter?"))
                process = 0
              end
            else
              pbSet(Store_pokemon_contest,chosen)
              pbMessage(_INTL("Okay, your Pokemon will be entered in this Contest."))
              pbMessage(_INTL("Your Pokemon is Entry No.4. The Contest will begin shortly."))
              inf_play; move_player
              exit = true
            end
          else
            cancel = [_INTL("Yes"),_INTL("No")]
            cancel2 = pbMessage(_INTL("Cancel participation?"),cancel,-1)
            case cancel2
              when 0,-1:
                pbMessage(_INTL("We hope you will participate another time."))
                exit = true
              when 1: process = 0
            end
          end
      end
    end
  end
#-------------------------------------------------------------------------------
  # Transfer player
  def move_player
    move_switch_for_transfer('A')
    (0..1).each { |i| $game_self_switches[[CONTEST_MAP_BEFORE_PLAY,CONTEST_DOOR_EVENT[i],'A']] = true }
    move_switch_for_transfer('B')
    (0..1).each { |i| $game_self_switches[[CONTEST_MAP_BEFORE_PLAY,CONTEST_DOOR_EVENT[i],'A']] = false } if !$game_self_switches[[CONTEST_MAP_BEFORE_PLAY,CONTEST_MOVE_EVENT,'B']]
    move_switch_for_transfer('C')
    (0...5).each { |i| 
    map_ribbon_normal = (1+i*4); map_ribbon_super = (2+i*4); map_ribbon_hyper = (3+i*4); map_ribbon_master = (4+i*4)
    transferPlayer(*CONTEST_MAP_DATA_NORMAL) if @@num_ribbon == map_ribbon_normal
    transferPlayer(*CONTEST_MAP_DATA_SUPER) if @@num_ribbon == map_ribbon_super
    transferPlayer(*CONTEST_MAP_DATA_HYPER) if @@num_ribbon == map_ribbon_hyper
    transferPlayer(*CONTEST_MAP_DATA_MASTER) if @@num_ribbon == map_ribbon_master }
  end
#-------------------------------------------------------------------------------
  # Some informations
  def inf_play
    case @@num_ribbon
      when 1,2,3,4: $game_variables[Name_contest] = 1
      when 5,6,7,8: $game_variables[Name_contest] = 2
      when 9,10,11,12: $game_variables[Name_contest] = 3
      when 13,14,15,16: $game_variables[Name_contest] = 4 
      when 17,18,19,20: $game_variables[Name_contest] = 5
    end
    if (@@num_ribbon-1)%4 == 0
      $game_variables[Store_difficulty_contest] = 25
    elsif (@@num_ribbon-2)%4 == 0
      $game_variables[Store_difficulty_contest] = 50
    elsif (@@num_ribbon-3)%4 == 0
      $game_variables[Store_difficulty_contest] = 75
    elsif @@num_ribbon%4 == 0
      $game_variables[Store_difficulty_contest] = 100
    end
    $game_variables[Store_ribbon] = @@num_ribbon
  end
  
end