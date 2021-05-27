#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Begin contest
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => "Pokemon Contests Script",
  :credits => ["mej71", "Maruno", "FL", "JV", "Umbreon/Hansiec",
  "Saving Raven", "TastyRedTomato", "Luka S.J.", "bo4p5687"]
})
#-------------------------------------------------------------------------------
class PokeContestScene < Some_methods_contest
  attr_reader :name
  attr_reader  :hearts
  attr_accessor :selected
  
  def initialize
    # Sprite
    @sprites={}; @heartsprites={}
    # Viewport
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=999
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=99999+2
    # Ends when set to true
    @contestover = false
    # Set difficulty
    @difficulty = $game_variables[Store_difficulty_contest]
    # Ribbon number given if won
    @ribbonnum = $game_variables[Store_ribbon]
    # Set name contest
    case $game_variables[Name_contest]
    when 1: @contestType="Coolness"   # Cool
    when 2: @contestType="Beauty"     # Beauty
    when 3: @contestType="Cuteness"   # Cute
    when 4: @contestType="Smartness"  # Smart
    when 5: @contestType="Toughness"  # Tough
    end
    # Nervous (No crowd)
    @nvcrowd = false
    # Case
    @order_winner = []
    @player_win=false
    @quantity_winner=0
    @prelim1=0; @prelim2=0; @prelim3=0; @prelim4=0
    @results=[0,0,0,0]; @results_scd = [0,0,0,0]
    #@results_2=[0,0,0,0]; @results_3=[0,0,0,0]
    # Process
    @process = -1
    # Exit
    @exit = false; @exit2 = false; @nexto = false
  end
#-------------------------------------------------------------------------------
  # CONTESTCOMBOS are defined in the bottom of this script
  def pbCheckforCombos
    case @currentpoke
    when @pkmn1; oldmove = @pkmn1lastmove
    when @pkmn2; oldmove = @pkmn2lastmove
    when @pkmn3; oldmove = @pkmn3lastmove
    when @pkmn4; oldmove = @pkmn4lastmove
    end
    # Check Combo
    (0...CONTESTCOMBOS.length).each { |j| (1...CONTESTCOMBOS[j].length).each { |i| return true if @currentmovename == CONTESTCOMBOS[j][i] } if oldmove == CONTESTCOMBOS[j][0] }
    return false
  end
#-------------------------------------------------------------------------------
  def pbStartContest
    # Set opponent
    opponent1 = opponent2 = opponent3 = 0
    opponent1level = opponent2level = opponent3level = 0
    # Method for check pokemon
    if RANDOM_POKEMONS
      opponent1 = 1+rand(PBSpecies.maxValue); opponent2 = 1+rand(PBSpecies.maxValue); opponent3 = 1+rand(PBSpecies.maxValue)
      if !SIMILAR_POKEMONS
        stop_random = 0
        loop do
          case stop_random
          when 0
              break if opponent1 != opponent2 && opponent1 != opponent3 && opponent2 != opponent3
              stop_random = 1
          when 1
            if opponent1 == opponent2 || opponent1 == opponent3
              stop_random = 2
            elsif opponent2 == opponent3
              stop_random = 3
            elsif opponent1 == opponent2 && opponent1 == opponent3
              stop_random = 4
            else
              break
            end
          when 2: opponent1 = 1+rand(PBSpecies.maxValue); stop_random = 1
          when 3: opponent2 = 1+rand(PBSpecies.maxValue); stop_random = 1
          when 4: opponent1 = 1+rand(PBSpecies.maxValue); opponent2 = 1+rand(PBSpecies.maxValue); stop_random = 1
          end
        end
      end
    else
      if EACH_CONTEST
        case $game_variables[Name_contest]
        when 1; list1 = POKEMON_COOL_FIRST; list2 = POKEMON_COOL_SECOND; list3 = POKEMON_COOL_THIRD
        when 2; list1 = POKEMON_BEAUTY_FIRST; list2 = POKEMON_BEAUTY_SECOND; list3 = POKEMON_BEAUTY_THIRD
        when 3; list1 = POKEMON_CUTE_FIRST; list2 = POKEMON_CUTE_SECOND; list3 = POKEMON_CUTE_THIRD
        when 4; list1 = POKEMON_SMART_FIRST; list2 = POKEMON_SMART_SECOND; list3 = POKEMON_SMART_THIRD
        else; list1 = POKEMON_TOUGH_FIRST; list2 = POKEMON_TOUGH_SECOND; list3 = POKEMON_TOUGH_THIRD
        end
      else
        list1 = POKEMON_FIRST_CONTEST; list2 = POKEMON_SECOND_CONTEST; list3 = POKEMON_THIRD_CONTEST
      end
      if list1.length <= 3 || list2.length <= 3 || list3.length <= 3 || 
        list1.length == nil || list2.length == nil || list3.length == nil
        raise ArgumentError.new(_INTL("You should add more Pokemons in Constant."))
        return nil
      end
      # Random pokemon 
      random1 = rand(list1.length); random2 = rand(list2.length); random3 = rand(list3.length)
      opponent1 = list1[random1]; opponent2 = list2[random2]; opponent3 = list3[random3] 
      opponent1 = getID(PBSpecies,opponent1) if opponent1.is_a?(String) || opponent1.is_a?(Symbol)
      opponent2 = getID(PBSpecies,opponent2) if opponent2.is_a?(String) || opponent2.is_a?(Symbol)
      opponent3 = getID(PBSpecies,opponent3) if opponent3.is_a?(String) || opponent3.is_a?(Symbol)
      if !SIMILAR_POKEMONS
        stop_random = 0
        loop do
          case stop_random
          when 0
              break if opponent1 != opponent2 && opponent1 != opponent3 && opponent2 != opponent3
              stop_random = 1
          when 1
            if opponent1 == opponent2 || opponent1 == opponent3
              stop_random = 2
            elsif opponent2 == opponent3
              stop_random = 3
            elsif opponent1 == opponent2 && opponent1 == opponent3
              stop_random = 4
            else
              break
            end
          when 2
            random1 = rand(list1.length); opponent1 = list1[random1]
            opponent1 = getID(PBSpecies,opponent1) if opponent1.is_a?(String) || opponent1.is_a?(Symbol)
            stop_random = 1
          when 3
            random2 = rand(list2.length); opponent2 = list2[random2]
            opponent2 = getID(PBSpecies,opponent2) if opponent2.is_a?(String) || opponent2.is_a?(Symbol)
            stop_random = 1
          when 4
            random1 = rand(list1.length); random2 = rand(list2.length)
            opponent1 = list1[random1]; opponent2 = list2[random2]
            opponent1 = getID(PBSpecies,opponent1) if opponent1.is_a?(String) || opponent1.is_a?(Symbol)
            opponent2 = getID(PBSpecies,opponent2) if opponent2.is_a?(String) || opponent2.is_a?(Symbol)
            stop_random = 1
          end
        end
      end
    end
    # Check pokemon (if there is error)
    check_pokemon_for_contest(opponent1)
    check_pokemon_for_contest(opponent2)
    check_pokemon_for_contest(opponent3)
    # Set pokemon
    @opponent1 = opponent1; @opponent2 = opponent2; @opponent3 = opponent3
    # Level Pokemon
    if SET_LEVEL_CONTEST
      case $game_variables[Store_difficulty_contest]
      when 25
        opponent1level = LEVEL_POKEMON_CONTEST_NORMAL[0]
        opponent2level = LEVEL_POKEMON_CONTEST_NORMAL[1]
        opponent3level = LEVEL_POKEMON_CONTEST_NORMAL[2]
      when 50
        opponent1level = LEVEL_POKEMON_CONTEST_SUPER[0]
        opponent2level = LEVEL_POKEMON_CONTEST_SUPER[1]
        opponent3level = LEVEL_POKEMON_CONTEST_SUPER[2]
      when 75
        opponent1level = LEVEL_POKEMON_CONTEST_HYPER[0]
        opponent2level = LEVEL_POKEMON_CONTEST_HYPER[1]
        opponent3level = LEVEL_POKEMON_CONTEST_HYPER[2]
      when 100
        opponent1level = LEVEL_POKEMON_CONTEST_MASTER[0]
        opponent2level = LEVEL_POKEMON_CONTEST_MASTER[1]
        opponent3level = LEVEL_POKEMON_CONTEST_MASTER[2]
      end
    else
      case $game_variables[Store_difficulty_contest]
      when 25: opponent1level = opponent2level = opponent3level = 25 
      when 50: opponent1level = opponent2level = opponent3level = 50
      when 75: opponent1level = opponent2level = opponent3level = 75
      when 100: opponent1level = opponent2level = opponent3level = 100
      end
    end
    # Set pokemon's candidat
    @pkmn1 = $Trainer.party[$game_variables[Store_pokemon_contest]]
    @pkmn2 = PokeBattle_Pokemon.new(opponent1,opponent1level,$Trainer)
    @pkmn3 = PokeBattle_Pokemon.new(opponent2,opponent2level,$Trainer)
    @pkmn4 = PokeBattle_Pokemon.new(opponent3,opponent3level,$Trainer)
    # Teach opponent pokemon new moves if defined
    (0...CONTESTMOVE2.length).each { |i| @pkmn2.pbLearnMove(CONTESTMOVE2[i]) if CONTESTMOVE2[i] != 0 }
    (0...CONTESTMOVE3.length).each { |i| @pkmn3.pbLearnMove(CONTESTMOVE3[i]) if CONTESTMOVE3[i] != 0 }
    (0...CONTESTMOVE4.length).each { |i| @pkmn4.pbLearnMove(CONTESTMOVE4[i]) if CONTESTMOVE4[i] != 0 }
    # Nicknames for contest pokemon
    @pkmn2.name = $CONTESTNAME2 if $CONTESTNAME2 != ""
    @pkmn3.name = $CONTESTNAME3 if $CONTESTNAME3 != ""
    @pkmn4.name = $CONTESTNAME4 if $CONTESTNAME4 != ""
    # Number
    @pkmn1total = 0; @pkmn2total = 0; @pkmn3total = 0; @pkmn4total = 0
    # Check double
    @pkmn1DoubleNext = false; @pkmn2DoubleNext = false
    @pkmn3DoubleNext = false; @pkmn4DoubleNext = false
    # Check miss
    @pkmn1MissTurn = false; @pkmn2MissTurn = false
    @pkmn3MissTurn = false; @pkmn4MissTurn = false
    # Check move?
    @pkmn1nomoremoves = false; @pkmn2nomoremoves = false
    @pkmn3nomoremoves = false; @pkmn4nomoremoves = false
    # Applause
    @applause = 0
    # Star
    @pkmn1stars = 0; @pkmn2stars = 0; @pkmn3stars = 0; @pkmn4stars = 0
    @stars=[@pkmn1stars,@pkmn2stars,@pkmn3stars,@pkmn4stars]
    # Heart
    @pkmn1hearts = 0; @pkmn2hearts = 0; @pkmn3hearts = 0; @pkmn4hearts = 0
    # Set round
    @round = 1
    @position_pkmn = 0
    # Turn
    pbTurn
    # MC
    pbMessage(_INTL("MC: That's it for judging!"))
    pbMessage(_INTL("Thank you all for a most wonderful display of quality appeals!"))
    pbMessage(_INTL("This concludes all judging! Thank you for your fine efforts!"))
    pbMessage(_INTL("Now, all that remains is the pulse-pounding proclamation of the winner."))
    pbMessage(_INTL("The JUDGE looks ready to make the annoucement!"))
    pbMessage(_INTL("JUDGE: We will now declare the winner!"))
    # End
    pbResultsScene
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Compare
  # Cool, beauty, smart, tough
  def create_condition
    case $game_variables[Store_difficulty_contest]
    when 25
      random1 = 10 + rand(51); random2 = 10 + rand(51); random3 = 10 + rand(51)
      @pkmn2.cute = @pkmn2.cool = @pkmn2.beauty = @pkmn2.smart = @pkmn2.tough = random1
      @pkmn3.cute = @pkmn3.cool = @pkmn3.beauty = @pkmn3.smart = @pkmn3.tough = random2
      @pkmn4.cute = @pkmn4.cool = @pkmn4.beauty = @pkmn4.smart = @pkmn4.tough = random3
      # Sort
      sort_poke_base_number
    when 50
      random1 = 10 + rand(111); random2 = 10 + rand(111); random3 = 10 + rand(111)
      @pkmn2.cute = @pkmn2.cool = @pkmn2.beauty = @pkmn2.smart = @pkmn2.tough = random1
      @pkmn3.cute = @pkmn3.cool = @pkmn3.beauty = @pkmn3.smart = @pkmn3.tough = random2
      @pkmn4.cute = @pkmn4.cool = @pkmn4.beauty = @pkmn4.smart = @pkmn4.tough = random3
      # Sort
      sort_poke_base_number
    when 75
      random1 = 10 + rand(171); random2 = 10 + rand(171); random3 = 10 + rand(171)
      @pkmn2.cute = @pkmn2.cool = @pkmn2.beauty = @pkmn2.smart = @pkmn2.tough = random1
      @pkmn3.cute = @pkmn3.cool = @pkmn3.beauty = @pkmn3.smart = @pkmn3.tough = random2
      @pkmn4.cute = @pkmn4.cool = @pkmn4.beauty = @pkmn4.smart = @pkmn4.tough = random3
      # Sort
      sort_poke_base_number
    when 100
      random1 = 10 + rand(231); random2 = 10 + rand(231); random3 = 10 + rand(231)
      @pkmn2.cute = @pkmn2.cool = @pkmn2.beauty = @pkmn2.smart = @pkmn2.tough = random1
      @pkmn3.cute = @pkmn3.cool = @pkmn3.beauty = @pkmn3.smart = @pkmn3.tough = random2
      @pkmn4.cute = @pkmn4.cool = @pkmn4.beauty = @pkmn4.smart = @pkmn4.tough = random3
      # Sort
      sort_poke_base_number
    end
  end
#-------------------------------------------------------------------------------
  # Show Species Introdution - by FL
  def showSpecies(species,poke,number,complement="",nickname="")
    name=PBSpecies.getName(species)
    kind=pbGetMessage(MessageTypes::Kinds,species)
    battlername=sprintf("Graphics/Battlers/%03d%s",species,complement)
    bitmap=pbResolveBitmap(battlername)
    pbPlayCry(species)
    if bitmap # to prevent crashes
      iconwindow=PictureWindow.new(bitmap)
      iconwindow.x=(Graphics.width/2)-(iconwindow.width/2)
      iconwindow.y=((Graphics.height-96)/2)-(iconwindow.height/2)
      if nickname==""
        pbMessage(_INTL("{1}. The {2} Pokémon.",name,kind))
      else
        pbMessage(_INTL("{1}. The {2} Pokémon.",nickname,kind))
      end
      # Show heart
      show_heart_vote(poke,number)
      iconwindow.dispose
    end
  end
#-------------------------------------------------------------------------------
  # Show heart (character)
  def character_show_heart(number,id_1,id_2,id_3,id_4,id_5,id_6)
    map_name=($game_variables[Store_difficulty_contest]==25)?CONTEST_MAP_DATA_NORMAL[0]:($game_variables[Store_difficulty_contest]==50)?CONTEST_MAP_DATA_SUPER[0]:($game_variables[Store_difficulty_contest]==75)?CONTEST_MAP_DATA_HYPER[0]:CONTEST_MAP_DATA_MASTER[0]
    if number == 6
      move_switch_for_show_heart(map_name,id_1,'A'); move_switch_for_show_heart(map_name,id_2,'A')
      move_switch_for_show_heart(map_name,id_3,'A'); move_switch_for_show_heart(map_name,id_4,'A')
      move_switch_for_show_heart(map_name,id_5,'A'); move_switch_for_show_heart(map_name,id_6,'A')
    elsif number == 5
      move_switch_for_show_heart(map_name,id_1,'A'); move_switch_for_show_heart(map_name,id_2,'A')
      move_switch_for_show_heart(map_name,id_3,'A'); move_switch_for_show_heart(map_name,id_4,'A')
      move_switch_for_show_heart(map_name,id_5,'A')
    elsif number == 4
      move_switch_for_show_heart(map_name,id_1,'A'); move_switch_for_show_heart(map_name,id_2,'A')
      move_switch_for_show_heart(map_name,id_3,'A'); move_switch_for_show_heart(map_name,id_4,'A')
    elsif number == 3
      move_switch_for_show_heart(map_name,id_1,'A'); move_switch_for_show_heart(map_name,id_2,'A')
      move_switch_for_show_heart(map_name,id_3,'A')
    elsif number == 2
      move_switch_for_show_heart(map_name,id_1,'A'); move_switch_for_show_heart(map_name,id_2,'A')
    elsif number == 1
      move_switch_for_show_heart(map_name,id_1,'A')
    end
  end
#-------------------------------------------------------------------------------
  # Show heart (condition)
  def show_heart_vote(poke,number)
    score_normal = 60; score_super = 120; score_hyper = 180; score_master = 240
    poke = (number==1)? poke.cool : (number == 2)? poke.beauty : (number == 3)? poke.cute : (number == 4)? poke.smart : poke.tough
    case $game_variables[Store_difficulty_contest]
    when 25
      if poke >= score_normal
        $game_variables[Store_number_for_emotion_normal] = 6
        character_show_heart(6,7,8,9,10,11,12)
      elsif poke >= (score_normal/6*5).to_f && poke < score_normal
        $game_variables[Store_number_for_emotion_normal] = 5
        character_show_heart(5,7,8,9,10,11,12)
      elsif poke >= (score_normal/6*4).to_f && poke < (score_normal/6*5).to_f
        $game_variables[Store_number_for_emotion_normal] = 4
        character_show_heart(4,7,8,9,10,11,12)
      elsif poke >= (score_normal/6*3).to_f && poke < (score_normal/6*4).to_f
        $game_variables[Store_number_for_emotion_normal] = 3
        character_show_heart(3,7,8,9,10,11,12)
      elsif poke >= (score_normal/6*2).to_f && poke < (score_normal/6*3).to_f
        $game_variables[Store_number_for_emotion_normal] = 2
        character_show_heart(2,7,8,9,10,11,12)
      elsif poke >= (score_normal/6).to_f && poke < (score_normal/6*2).to_f
        $game_variables[Store_number_for_emotion_normal] = 1
        character_show_heart(1,7,8,9,10,11,12)
      end
    when 50
      if poke >= score_super
        $game_variables[Store_number_for_emotion_super] = 6
        character_show_heart(6,7,8,9,10,11,12)
      elsif poke >= (score_super/6*5).to_f && poke < score_super
        $game_variables[Store_number_for_emotion_super] = 5
        character_show_heart(5,7,8,9,10,11,12)
      elsif poke >= (score_super/6*4).to_f && poke < (score_super/6*5).to_f
        $game_variables[Store_number_for_emotion_super] = 4
        character_show_heart(4,7,8,9,10,11,12)
      elsif poke >= (score_super/6*3).to_f && poke < (score_super/6*4).to_f
        $game_variables[Store_number_for_emotion_super] = 3
        character_show_heart(3,7,8,9,10,11,12)
      elsif poke >= (score_super/6*2).to_f && poke < (score_super/6*3).to_f
        $game_variables[Store_number_for_emotion_super] = 2
        character_show_heart(2,7,8,9,10,11,12)
      elsif poke >= (score_super/6).to_f && poke < (score_super/6*2).to_f
        $game_variables[Store_number_for_emotion_super] = 1
        character_show_heart(1,7,8,9,10,11,12)
      end
    when 75
      if poke >= score_hyper
        $game_variables[Store_number_for_emotion_hyper] = 6
        character_show_heart(6,7,8,9,10,11,12)
      elsif poke >= (score_hyper/6*5).to_f && poke < score_hyper
        $game_variables[Store_number_for_emotion_hyper] = 5
        character_show_heart(5,7,8,9,10,11,12)
      elsif poke >= (score_hyper/6*4).to_f && poke < (score_hyper/6*5).to_f
        $game_variables[Store_number_for_emotion_hyper] = 4
        character_show_heart(4,7,8,9,10,11,12)
      elsif poke >= (score_hyper/6*3).to_f && poke < (score_hyper/6*4).to_f
        $game_variables[Store_number_for_emotion_hyper] = 3
        character_show_heart(3,7,8,9,10,11,12)
      elsif poke >= (score_hyper/6*2).to_f && poke < (score_hyper/6*3).to_f
        $game_variables[Store_number_for_emotion_hyper] = 2
        character_show_heart(2,7,8,9,10,11,12)
      elsif poke >= (score_hyper/6).to_f && poke < (score_hyper/6*2).to_f
        $game_variables[Store_number_for_emotion_hyper] = 1
        character_show_heart(1,7,8,9,10,11,12)
      end
    when 100
      if poke >= score_master
        $game_variables[Store_number_for_emotion_master] = 6
        character_show_heart(6,7,8,9,10,11,12)
      elsif poke >= (score_master/6*5).to_f && poke < score_master
        $game_variables[Store_number_for_emotion_master] = 5
        character_show_heart(5,7,8,9,10,11,12)
      elsif poke >= (score_master/6*4).to_f && poke < (score_master/6*5).to_f
        $game_variables[Store_number_for_emotion_master] = 4
        character_show_heart(4,7,8,9,10,11,12)
      elsif poke >= (score_master/6*3).to_f && poke < (score_master/6*4).to_f
        $game_variables[Store_number_for_emotion_master] = 3
        character_show_heart(3,7,8,9,10,11,12)
      elsif poke >= (score_master/6*2).to_f && poke < (score_master/6*3).to_f
        $game_variables[Store_number_for_emotion_master] = 2
        character_show_heart(2,7,8,9,10,11,12)
      elsif poke >= (score_master/6).to_f && poke < (score_master/6*2).to_f
        $game_variables[Store_number_for_emotion_master] = 1
        character_show_heart(1,7,8,9,10,11,12)
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Presentation
  def presentation_pokemon
    map_name=($game_variables[Store_difficulty_contest]==25)?CONTEST_MAP_DATA_NORMAL[0]:($game_variables[Store_difficulty_contest]==50)?CONTEST_MAP_DATA_SUPER[0]:($game_variables[Store_difficulty_contest]==75)?CONTEST_MAP_DATA_HYPER[0]:CONTEST_MAP_DATA_MASTER[0]
    # MC
    move_switch_for_show_heart(map_name,6,'A')
    rank_name=($game_variables[Store_difficulty_contest]==25)? "Normal":($game_variables[Store_difficulty_contest]==50)? "Super":($game_variables[Store_difficulty_contest]==75)? "Hyper":"Master"
    pbMessage(_INTL("MC: Hello! We're just getting started with a {1} Rank Pokemon {2} Contest.",rank_name,@contestType))
    pbMessage(_INTL("The participating Trainers and their Pokemon are as follows:"))
    move_switch_for_show_heart(map_name,6,'B')
    # Show Pokemon
    move_switch_for_show_heart(map_name,2,'A')
    pbMessage(_INTL("Entry No.1"))
    showSpecies(@opponent1,@pkmn2,$game_variables[Name_contest],"",@pkmn2.name)
    pbWait(10) # Wait
    move_switch_for_show_heart(map_name,2,'B')
    move_switch_for_show_heart(map_name,1,'A')
    pbWait(15) # Wait
    pbMessage(_INTL("Entry No.2"))
    showSpecies(@opponent2,@pkmn3,$game_variables[Name_contest],"",@pkmn3.name)
    pbWait(10) # Wait
    move_switch_for_show_heart(map_name,1,'B')
    move_switch_for_show_heart(map_name,3,'A')
    pbWait(15) # Wait
    pbMessage(_INTL("Entry No.3"))
    showSpecies(@opponent3,@pkmn4,$game_variables[Name_contest],"",@pkmn4.name)
    pbWait(10) # Wait
    move_switch_for_show_heart(map_name,3,'B')
    move_switch_for_show_heart(map_name,4,'B')
    pbWait(15) # Wait
    $game_self_switches[[map_name,4,'A']] = true
    pbMessage(_INTL("Entry No.4"))
    idpkmplayer = $Trainer.party[$game_variables[Store_pokemon_contest]].species
    showSpecies(idpkmplayer,@pkmn1,$game_variables[Name_contest],"",@pkmn1.name)
    pbWait(10) # Wait
    move_switch_for_show_heart(map_name,4,'C')
    $game_self_switches[[map_name,4,'A']] = true
    # MC
    pbMessage(_INTL("MC: We're just seen the four Pokemon contestants. Now it's time for primary judging!"))
    pbMessage(_INTL("The audience will vote on their favorite Pokemon contestants. Without any further ado, let the voting begin!"))
    pbMessage(_INTL("Voting under way..."))
    wait(20)
    pbMessage(_INTL("Voting is now complete!"))
    pbMessage(_INTL("While the votes are being tallied, let's move on to secondary judging!"))
    pbMessage(_INTL("The second stage of judging is the much anticipated appeal time!"))
    pbMessage(_INTL("May the contestants amaze us with superb appeals of dazzling moves!"))
    pbMessage(_INTL("Let's see a little enthusiasm! Let's appeal!"))
    move_switch_for_show_heart(map_name,6,'C')
    move_switch_for_show_heart(map_name,5,'A')
    pbWait(5) # Wait
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Main round processing function
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def scene_play
    @sprites["background"] = IconSprite.new(0,0,@viewport1)
    @sprites["background"].setBitmap("Graphics/Pictures/Contest/contestbg")
    @sprites["message"] = Sprite.new(@viewport)
    @sprites["message"].bitmap = Bitmap.new("Graphics/Pictures/Contest/mess")
    @sprites["message"].y = @sprites["background"].bitmap.height - 128
    @sprites["list"] = Sprite.new(@viewport)
    @sprites["list"].bitmap = Bitmap.new("Graphics/Pictures/Contest/list")
    @sprites["list"].x = @sprites["background"].bitmap.width - 165
  end
#-------------------------------------------------------------------------------
  def reset_order
    pbResetContestMoveEffects
    pbDrawText
  end
#-------------------------------------------------------------------------------
  def choose_move
    # Set move
    pokemon = @pkmn1
    # Move
    @sprites["moves"] = IconSprite.new(0,187,@viewport)
    @sprites["moves"].setBitmap("Graphics/Pictures/Contest/moves")
    # Color
    base = Color.new(64,64,64)
    shadow = Color.new(0,0,0)
    # Text
    @sprites["overlay"]  = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["overlay1"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    overlay  = @sprites["overlay"].bitmap
    overlay1 = @sprites["overlay1"].bitmap
    pbSetSmallFont(overlay)
    textpos  = [[_INTL("Please select a move."),12,165,0,Color.new(256,256,256),shadow]]
    imagepos = []
    textpos1 = []
    yPos = 195
    xPos = 10
    selectYPos = 191
    @sprites["selectbar"] = IconSprite.new(6,selectYPos,@viewport)
    @sprites["selectbar"].setBitmap("Graphics/Pictures/Contest/contestselect1")
    @selection = 0
    @selectedmove = PBMoves.getName(@pkmn1.moves[@selection].id)
    (1..PBContestMoves.maxValue).each{|i|
    name = PBContestMoves.getName(i)
    @selectedmove = getID(PBContestMoves,i) if @selectedmove == name }
    selecteddescription = pbGetMessage(MessageTypes::ContestMoveDescriptions,@selectedmove)
    contestmovedata = PBContestMoveData.new(@selectedmove)
    selectedhearts = contestmovedata.hearts
    selectedjam = contestmovedata.jam
    jamfile = sprintf("Graphics/Pictures/Contest/negaheart%d",selectedjam)
    @sprites["selectjam"] = IconSprite.new(400,235,@viewport)
    @sprites["selectjam"].setBitmap(jamfile)
    heartfile = sprintf("Graphics/Pictures/Contest/heart%d",selectedhearts)
    @sprites["selecthearts"] = IconSprite.new(400,200,@viewport)
    @sprites["selecthearts"].setBitmap(heartfile)
    if @pkmn1.moves[@selection].id>0
      textpos1.push([PBMoves.getName(@pkmn1.moves[@selection].id),245,200,0,
       Color.new(256,256,256),Color.new(0,0,0)])
      pbDrawTextPositions(overlay1,textpos1)
    end  
    drawTextEx(overlay1,245,250,255,2,selecteddescription,Color.new(256,256,256),Color.new(0,0,0))
    (0...pokemon.numMoves).each{|i|
    if pokemon.moves[i].id>0
      @selectedmove=PBMoves.getName(@pkmn1.moves[i].id)
      (1..PBContestMoves.maxValue).each{|j|
      name=PBContestMoves.getName(j)
      @selectedmove = getID(PBContestMoves,j) if @selectedmove == name }
      contestmovedata=PBContestMoveData.new(@selectedmove)
      moveType=contestmovedata.contestType
      imagepos.push(["Graphics/Pictures/Contest/contesttype",xPos,yPos,0,
      moveType*28,64,28])
      if @pkmn1lastmove && PBMoves.getName(pokemon.moves[i].id) == @pkmn1lastmove
        textpos.push([PBMoves.getName(pokemon.moves[i].id),xPos+68,yPos+10,0,Color.new(175,175,175),Color.new(0,0,0)])
      else
        textpos.push([PBMoves.getName(pokemon.moves[i].id),xPos+68,yPos+10,0,Color.new(256,256,256),Color.new(0,0,0)])
      end
    else
      textpos.push(["-",316,yPos,0,Color.new(256,256,256),Color.new(0,0,0)])
    end
    yPos+=44 }
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
  end
#-------------------------------------------------------------------------------
  def set_name_move
    selectYPos = (@selection*45 + 192)
    selectYPos = (@selection*45 + 191) if @selection == 0
    selectYPos = (@selection*45 + 190) if @selection == 1
    @sprites["selectbar"].y = selectYPos
    @sprites["selectbar"].setBitmap("Graphics/Pictures/Contest/contestselect1") if @selection == 0
    @sprites["selectbar"].setBitmap("Graphics/Pictures/Contest/contestselect") if @selection != 0
    @selectedmove = PBMoves.getName(@pkmn1.moves[@selection].id)
    (1..PBContestMoves.maxValue).each{|i|
    name = PBContestMoves.getName(i)
    @selectedmove = getID(PBContestMoves,i) if @selectedmove == name }
    contestmovedata = PBContestMoveData.new(@selectedmove)
    selectedhearts = contestmovedata.hearts
    selecteddescription = pbGetMessage(MessageTypes::ContestMoveDescriptions,@selectedmove)
    heartfile = sprintf("Graphics/Pictures/Contest/heart%d",selectedhearts)
    selectedjam = contestmovedata.jam
    jamfile = sprintf("Graphics/Pictures/Contest/negaheart%d",selectedjam)
    @sprites["selectjam"].setBitmap(jamfile)
    @sprites["selecthearts"].setBitmap(heartfile)
    overlay1 = @sprites["overlay1"].bitmap
    overlay1.clear
    textpos1 = []
    textpos1.push([PBMoves.getName(@pkmn1.moves[@selection].id),245,200,0,
    Color.new(256,256,256),Color.new(0,0,0)])
    drawTextEx(overlay1,245,250,255,2,selecteddescription,Color.new(256,256,256),Color.new(0,0,0))
    pbDrawTextPositions(overlay1,textpos1)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def set_move_AI(number)
    @currentpos = number + 1
    @currentpoke = @pokeorder[number]
    # Determine which move to use
    # Pokemon owner : AI for opponents
    i = (@currentpoke == @pkmn1)? @moveselection : pbAI(@pokeorder[number],@difficulty)
    movedata = PBMoveData.new(@pokeorder[number].moves[i].id)
    movedata = PBMoveData.new(@pokeorder[number].moves[0].id) if movedata.id<=0
    @currentmovename = PBMoves.getName(@pokeorder[number].moves[i].id)
    pbWait(2) # Wait
    (1..PBContestMoves.maxValue).each{|i|
    name = PBContestMoves.getName(i)
    # Match the pokemon's move with the equivalent from contestmoves.txt
    if @currentmovename == name              
      @currentmove = getID(PBContestMoves,i)
      # Get actual ID to display proper move animation
      @currentmove1 = getID(PBMoves,i)       
    end }
    (movedata.target == PBTargets::User)? @atself = true : @atself = false
    contestmovedata = PBContestMoveData.new(@currentmove)
    @currenthearts = contestmovedata.hearts
    moveType = contestmovedata.contestType
    pbmoveType(moveType)
    # Skip the move processing if nomore moves is true
    if !pbNoMore 
      # Skip move processing if it misses this turn
      if !pbMissTurn 
        # Check for double hearts
        if pbDoubleNext
          @currenthearts *= 2
          pbReverseDoubleNext
        end
        if @nervous[@currentpos-1]
          pbCustomMessage(_INTL("\\l[3]{1} is nervous.",@pokeorder[number].name),"Graphics/Pictures/Contest/choice 29",nil,340)
          # Check for nervousness, 30% chance
          random = rand(100)
          if random < 30                                                   
            pbCustomMessage(_INTL("\\l[3]{1} was too nervous to move!",@pokeorder[number].name),"Graphics/Pictures/Contest/choice 29",nil,340)
            @nvcrowd = true
          else
            pbCustomMessage(_INTL("\\l[3]{1} used {2}!",@pokeorder[number].name,@currentmovename),"Graphics/Pictures/Contest/choice 29",nil,340)
            pbAnimation(@currentmove1,0,1,0)
            pbFunctionsAdjustHearts  
            pbDisplayAddingPositiveHearts
          end
        else
          pbCustomMessage(_INTL("\\l[3]{1} used {2}!",@pokeorder[number].name,@currentmovename),"Graphics/Pictures/Contest/choice 29",nil,340)
          pbAnimation(@currentmove1,0,1,0)
          pbFunctionsAdjustHearts  
          pbDisplayAddingPositiveHearts
        end
      else
        # Change miss turn variable back after missing turn
        pbReverseMissTurn   
      end
    end
    # Check
    if pbCheckLast && @currentfunction != 15 && @round != 1 && !pbNoMore && !pbMissTurn
      @currenthearts -= 1
      pbCustomMessage(_INTL("\\l[3]The judge looked at {1} expectantly!",@pokeorder[@currentpos-1].name),"Graphics/Pictures/Contest/choice 29",nil,340)
      pbJam(1,@pokeorder[@currentpos-1],@currentpos-1)
      pbDecreaseHearts(@currentpoke,@currentpos,"notnil")
    end
    if @round != 1 && pbCheckforCombos
      @currenthearts = 5
      pbCustomMessage(_INTL("\\l[3]{1} really caught the judges attention!",@pokeorder[@currentpos-1].name),"Graphics/Pictures/Contest/choice 29",nil,340)
      pbDisplayAddingPositiveHearts
      pbDecreaseStarGraphics(@currentpos-1,1,false)
    end
    pbAssignLastMove
    @lastmoveType = @moveType
    # Crowd
    pbCrowd unless @nvcrowd
    pbWait(3) # Wait
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def first_pokemon_play
    # Set bitmap
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDisplayFastest
    # Invisible sprite to serve as target for animations
    @sprites["opponent"] = IconSprite.new(50,30,@viewport)    
    @sprites["opponent"].setBitmap("Graphics/Battler/000")  
    @sprites["opponent"].visible = false
    pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Alright {1}, let's see what you can do!",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",nil,340)
    number = @position_pkmn
    # Set move
    set_move_AI(number)
    pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now onto the next pokemon!",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",nil,340)
    @nvcrowd = false if @nvcrowd
    pbDisposeSprite(@sprites,"pokemon1")
    pbWait(3) # Wait
    @process = 3 # Set process
  end
#-------------------------------------------------------------------------------
  def next_pokemon_play
    number = @position_pkmn
    pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Next up we have {1}!",@pokeorder[number].name),"Graphics/Pictures/Contest/choice 29",nil,340)
    pbDisplayPkmnFast(number)
    pbWait(2) # Wait
    # Set move
    set_move_AI(number)
    if number < 3
      pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now onto the next pokemon!",@pokeorder[number].name),"Graphics/Pictures/Contest/choice 29",nil,340)
      @nvcrowd = false if @nvcrowd
      pbDisposeSprite(@sprites,"pokemon#{number+1}")
      pbWait(3) # Wait
      @process = 3 # Set process
    else
      if @round < 5
        pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now, next round!",@pokeorder[number].name),"Graphics/Pictures/Contest/choice 29",nil,340)
      end
      @nvcrowd = false if @nvcrowd
      pbDisposeSprite(@sprites,"pokemon#{number+1}")
      pbWait(3) # Wait
      # Reset
      pbResetHearts
      @process = 3 if @nexto # Set process
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbTurn
    loop do
      # Update
      update_ingame
      # Exit
      break if @exit 
      case @process
      when -1
        # Determine order by condition
        create_condition
        presentation_pokemon
        # Set scene
        scene_play
        # Set order (reset)
        reset_order
        # Next
        @process = 0
      when 0
        @nexto = false
        @atself = false
        @priorhearts = 0
        file=(@round==1)? "Graphics/Pictures/Contest/Roundone":(@round==2)?"Graphics/Pictures/Contest/Roundtwo":(@round==3)?"Graphics/Pictures/Contest/Roundthree":(@round==4)?"Graphics/Pictures/Contest/Roundfour":"Graphics/Pictures/Contest/Roundfive" 
        @sprites["Round"] = IconSprite.new(0,0,@viewport)
        @sprites["Round"].setBitmap(file)
        pbWait(5) # Wait
        roundupdown = 0
        (0...9).each{|i|
        if roundupdown==0 || roundupdown==1 || roundupdown==4 || roundupdown==5 || roundupdown==8 || roundupdown==9
          @sprites["Round"].y+=6
        else
          @sprites["Round"].y-=6
        end
        roundupdown += 1; pbWait(2) }
        # Dispose
        pbDisposeSprite(@sprites,"Round")
        # Choose
        choose_move
        @process = 1 
      when 1
        if Input.trigger?(Input::DOWN)
          if @selection < @pkmn1.numMoves-1
            @selection += 1
          else
            @selection = 0
          end
          # Set information
          set_name_move
        end
        if Input.trigger?(Input::UP)
          if @selection > 0
            @selection -= 1
          else
            @selection = @pkmn1.numMoves-1
          end
          # Set information
          set_name_move
        end
        if Input.trigger?(Input::C)
          # Set select (move)
          @moveselection = @selection
          # Clear
          pbDisposeSprite(@sprites,"overlay")
          pbDisposeSprite(@sprites,"overlay1")
          # Dispose
          pbDisposeSprite(@sprites,"selecthearts")
          pbDisposeSprite(@sprites,"moves")
          pbDisposeSprite(@sprites,"selectbar")
          pbDisposeSprite(@sprites,"selectjam")
          pbDisposeSprite(@sprites,"overlay")
          pbDisposeSprite(@sprites,"overlay1")
          @process = 2 
        end
      when 2
        if @position_pkmn == 0
          # First
          first_pokemon_play 
        else
          # Second, Third, Fourth
          next_pokemon_play
        end
      when 3
        @position_pkmn += 1
        @process = (@position_pkmn >= 4)? 4 : 2
      when 4
        @round += 1
        if @round > 5
          # Set order for next round
          pbOrder
          # Set order (reset)
          reset_order
          # Message
          pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]We're all out of Appeal Time!"),"Graphics/Pictures/Contest/choice 29",nil,340)
          # Clear overlay to prep for end scene
          pbDisposeSpriteHash(@sprites)
          @exit = true
        else
          # Set order for next round
          pbOrder
          # Set order (reset)
          reset_order
          # Set position
          @position_pkmn = 0
          # Set process
          @process = 0 # Next round
        end
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#  Misc.  Functions
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbAssignLastMove
    case @currentpoke
    when @pkmn1: @pkmn1lastmove = @currentmovename
    when @pkmn2: @pkmn2lastmove = @currentmovename
    when @pkmn3: @pkmn3lastmove = @currentmovename
    else @pkmn4lastmove = @currentmovename
    end
  end
#-------------------------------------------------------------------------------
  def pbCheckLast
    case @currentpoke
    when @pkmn1
      if @pkmn1lastmove
        if @currentmovename == @pkmn1lastmove
          return true
        else
          return false
        end
      end
    when @pkmn2
      if @pkmn2lastmove
        if @currentmovename == @pkmn2lastmove
          return true
        else
          return false
        end
      end
    when @pkmn3
      if @pkmn3lastmove
        if @currentmovename == @pkmn3lastmove
          return true
        else
          return false
        end
      end
    when @pkmn4
      if @pkmn4lastmove
        if @currentmovename == @pkmn4lastmove
          return true
        else
          return false
        end
      end
    end
  end
#-------------------------------------------------------------------------------
  def pbmoveType(moveType)
    case moveType
    when 0: @moveType = "Cool"
    when 1: @moveType = "Beauty"
    when 2: @moveType = "Cute"
    when 3: @moveType = "Smart"
    when 4: @moveType = "Tough"
    end
  end
#-------------------------------------------------------------------------------
  def pbDrawText
    @sprites["overlay2"].bitmap.clear if @sprites["overlay2"]
    # Change graphic indicating what position the player's pokemon is at
    if !@sprites["playerspokebg"]
      @sprites["playerspokebg"] = IconSprite.new(347,96,@viewport)
      @sprites["playerspokebg"].setBitmap("Graphics/Pictures/Contest/playerspoke")
    end
    (0..3).each{|i| @sprites["playerspokebg"].y=96*i if @pokeorder[i] == @pkmn1}
    @sprites["overlay2"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport) if !@sprites["overlay2"]
    pbSetSystemFont(@sprites["overlay2"].bitmap)
    overlay = @sprites["overlay2"].bitmap
    overlay.clear
    pokeone = _INTL("{1}",@pokeorder[0].name)
    poketwo = _INTL("{1}",@pokeorder[1].name)
    pokethree = _INTL("{1}",@pokeorder[2].name)
    pokefour = _INTL("{1}",@pokeorder[3].name)
    baseColor = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    textPositions=[
    [pokeone,353,5,false,baseColor,shadowColor],
    [poketwo,353,100,false,baseColor,shadowColor],
    [pokethree,353,195,false,baseColor,shadowColor],
    [pokefour,353,290,false,baseColor,shadowColor],
    ]
    pbDrawTextPositions(overlay,textPositions)
  end
#-------------------------------------------------------------------------------
  # Checks if pokemon can use moves
  def pbNoMore
    case @currentpoke
    when @pkmn1
      if @pkmn1nomoremoves 
        return true
      else
        return false
      end
    when @pkmn2
      if @pkmn2nomoremoves 
        return true
      else
        return false
      end
    when @pkmn3
      if @pkmn3nomoremoves 
        return true
      else
        return false
      end
    when @pkmn4
      if @pkmn4nomoremoves
        return true
      else
        return false
      end
    else return false
    end
  end
#-------------------------------------------------------------------------------
  # Checks if pokemon misses this turn
  def pbMissTurn  
    case @currentpoke
    when @pkmn1
      if @pkmn1MissTurn 
        return true
      else
        return false
      end
    when @pkmn2
      if @pkmn2MissTurn 
       return true
      else
       return false
      end
    when @pkmn3
      if @pkmn3MissTurn 
        return true
      else
        return false
      end
    when @pkmn4
      if @pkmn4MissTurn 
        return true
      else
        return false
      end
    else return false
    end
  end
#-------------------------------------------------------------------------------
  # Check if it should double hearts
  def pbDoubleNext  
    case @currentpoke
    when @pkmn1
      if @pkmn1DoubleNext
        return true
      else
        return false
      end
    when @pkmn2
      if @pkmn2DoubleNext 
        return true
      else
        return false
      end
    when @pkmn3
      if @pkmn3DoubleNext
        return true
      else
        return false
      end
    when @pkmn4
      if @pkmn4DoubleNext 
        return true
      else
        return false
      end
    else return false
    end
  end
#-------------------------------------------------------------------------------
  def pbSetNoMoreMoves
    case @currentpoke
    when @pkmn1: @pkmn1nomoremoves = true
    when @pkmn2: @pkmn2nomoremoves = true
    when @pkmn3: @pkmn3nomoremoves = true
    when @pkmn4: @pkmn4nomoremoves = true
    end
  end
#-------------------------------------------------------------------------------
  def pbSetMissTurn
    case @currentpoke
    when @pkmn1: @pkmn1MissTurn = true
    when @pkmn2: @pkmn2MissTurn = true
    when @pkmn3: @pkmn3MissTurn = true
    when @pkmn4: @pkmn4MissTurn = true
    end
  end  
#-------------------------------------------------------------------------------
  def pbSetDoubleNext
    case @currentpoke
    when @pkmn1: @pkmn1DoubleNext = true
    when @pkmn2: @pkmn2DoubleNext = true
    when @pkmn3: @pkmn3DoubleNext = true
    when @pkmn4: @pkmn4DoubleNext = true
    end
  end
#-------------------------------------------------------------------------------
  def pbReverseMissTurn
    case @currentpoke
    when @pkmn1: @pkmn1MissTurn = false
    when @pkmn2: @pkmn2MissTurn = false
    when @pkmn3: @pkmn3MissTurn = false
    when @pkmn4: @pkmn4MissTurn = false
    end
  end
#-------------------------------------------------------------------------------
  def pbReverseDoubleNext
    case @currentpoke
    when @pkmn1: @pkmn1DoubleNext = false
    when @pkmn2: @pkmn2DoubleNext = false
    when @pkmn3: @pkmn3DoubleNext = false
    when @pkmn4: @pkmn4DoubleNext = false
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#  Heart Graphic Functions
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbDisplayAddingPositiveHearts
    case @currentpoke
    when @pkmn1
      (0...@currenthearts).each{|i|
      @pkmn1hearts += 1
      heartfile_1 = sprintf("Graphics/Pictures/Contest/heart%d",@pkmn1hearts)if @pkmn1hearts<21
      pbWait(1) # Wait
      @heartsprites["firstpokehearts"] = IconSprite.new(399,45+((@currentpos-1)*96),@viewport)
      @heartsprites["firstpokehearts"].setBitmap(heartfile_1) }
      @priorhearts = @pkmn1hearts
    when @pkmn2
      (0...@currenthearts).each{|i|
      @pkmn2hearts += 1
      heartfile_2 = sprintf("Graphics/Pictures/Contest/heart%d",@pkmn2hearts)if @pkmn2hearts<21
      pbWait(1) # Wait
      @heartsprites["secondpokehearts"] = IconSprite.new(399,45+((@currentpos-1)*96),@viewport)
      @heartsprites["secondpokehearts"].setBitmap(heartfile_2) }
      @priorhearts = @pkmn2hearts
    when @pkmn3
      (0...@currenthearts).each{|i|
      @pkmn3hearts += 1
      heartfile_3=sprintf("Graphics/Pictures/Contest/heart%d",@pkmn3hearts)if @pkmn3hearts<21
      pbWait(1) # Wait
      @heartsprites["thirdpokehearts"] = IconSprite.new(399,45+((@currentpos-1)*96),@viewport)
      @heartsprites["thirdpokehearts"].setBitmap(heartfile_3) }
      @priorhearts = @pkmn3hearts
    when @pkmn4
      (0...@currenthearts).each{|i|
      @pkmn4hearts += 1
      heartfile_4 = sprintf("Graphics/Pictures/Contest/heart%d",@pkmn4hearts)if @pkmn4hearts<21
      pbWait(1) # Wait
      @heartsprites["fourthpokehearts"] = IconSprite.new(399,45+((@currentpos-1)*96),@viewport)
      @heartsprites["fourthpokehearts"].setBitmap(heartfile_4) }
      @priorhearts = @pkmn4hearts
    end
  end
#-------------------------------------------------------------------------------
  def pbDecreaseHearts(target,position,selfjam=nil)
    if selfjam == nil
      if @currentjam == 1
        pbCustomMessage(_INTL("\\l[3]{1} looked down out of distraction!",target.name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      else
        pbCustomMessage(_INTL("\\l[3]{1} couldn't help leaping up!",target.name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      end
    end
    case target
    when @pkmn1
      @pkmn1jam*=2 if @easilystartled[position-1]
      (0...@pkmn1jam).each{|i|
      if @pkmn1hearts == 0
        pbDisposeSprite(@heartsprites,"firstpokehearts")
        @heartsprites["firstpokehearts"]=IconSprite.new(399,45+((position-1)*96),@viewport)
      end
      @pkmn1hearts -= 1
      heartfile_1=sprintf("Graphics/Pictures/Contest/heart%d",@pkmn1hearts) if @pkmn1hearts >= 0 && @pkmn1hearts<21
      heartfile_1=sprintf("Graphics/Pictures/Contest/negaheart%d",@pkmn1hearts.abs) if @pkmn1hearts < 0 && @pkmn1hearts>-21
      @heartsprites["firstpokehearts"].setBitmap(heartfile_1)
      pbWait(1) }
      @priorhearts = @pkmn1hearts
    when @pkmn2
      @pkmn2jam*=2 if @easilystartled[position-1]
      (0...@pkmn2jam).each{|i|
      if @pkmn2hearts == 0
        pbDisposeSprite(@heartsprites,"secondpokehearts")
        @heartsprites["secondpokehearts"]=IconSprite.new(399,45+((position-1)*96),@viewport)
      end
      @pkmn2hearts -= 1
      heartfile_2=sprintf("Graphics/Pictures/Contest/heart%d",@pkmn2hearts) if @pkmn2hearts >= 0 && @pkmn2hearts<21
      heartfile_2=sprintf("Graphics/Pictures/Contest/negaheart%d",@pkmn2hearts.abs) if @pkmn2hearts < 0 && @pkmn2hearts>-21
      @heartsprites["secondpokehearts"].setBitmap(heartfile_2)
      pbWait(1) }
      @priorhearts = @pkmn2hearts
    when @pkmn3
      @pkmn3jam*=2 if @easilystartled[position-1]
      (0...@pkmn3jam).each{|i|
      if @pkmn3hearts == 0
        pbDisposeSprite(@heartsprites,"thirdpokehearts")
        @heartsprites["thirdpokehearts"]=IconSprite.new(399,45+((position-1)*96),@viewport)
      end
      @pkmn3hearts -= 1
      heartfile_3=sprintf("Graphics/Pictures/Contest/heart%d",@pkmn3hearts) if @pkmn3hearts >= 0 && @pkmn3hearts<21
      heartfile_3=sprintf("Graphics/Pictures/Contest/negaheart%d",@pkmn3hearts.abs) if @pkmn3hearts < 0 && @pkmn3hearts>-21
      @heartsprites["thirdpokehearts"].setBitmap(heartfile_3)
      pbWait(1) }
      @priorhearts = @pkmn3hearts
    when @pkmn4
      @pkmn4jam*=2 if @easilystartled[position-1]
      (0...@pkmn4jam).each{|i|
      if @pkmn4hearts == 0
        pbDisposeSprite(@heartsprites,"fourthpokehearts")
        @heartsprites["fourthpokehearts"]=IconSprite.new(399,45+((position-1)*96),@viewport)
      end
      @pkmn4hearts -= 1
      heartfile_4=sprintf("Graphics/Pictures/Contest/heart%d",@pkmn4hearts) if @pkmn4hearts >= 0 && @pkmn4hearts<21
      heartfile_4=sprintf("Graphics/Pictures/Contest/negaheart%d",@pkmn4hearts.abs) if @pkmn4hearts < 0 && @pkmn4hearts>-21
      @heartsprites["fourthpokehearts"].setBitmap(heartfile_4)
      pbWait(1) }
      @priorhearts = @pkmn4hearts
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Get rid of hearts graphics at end round, and add up heart totals
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbResetHearts
    @roundtotals = []
    # Dispose
    pbDisposeSprite(@heartsprites,"firstpokehearts")
    pbDisposeSprite(@heartsprites,"secondpokehearts")
    pbDisposeSprite(@heartsprites,"thirdpokehearts")
    pbDisposeSprite(@heartsprites,"fourthpokehearts")
    # Dispose star
    pbDisposeSprite(@sprites,"firstpokestars") if @sprites["firstpokestars"]
    pbDisposeSprite(@sprites,"secondpokestars") if @sprites["secondpokestars"]
    pbDisposeSprite(@sprites,"thirdpokestars") if @sprites["thirdpokestars"]
    pbDisposeSprite(@sprites,"fourthpokestars") if @sprites["fourthpokestars"]
    # Record (total)
    @pkmn1total += @pkmn1hearts
    @pkmn2total += @pkmn2hearts
    @pkmn3total += @pkmn3hearts
    @pkmn4total += @pkmn4hearts
    # Record (round)
    @roundtotals = [@pkmn1total,@pkmn2total,@pkmn3total,@pkmn4total]
    # Set heart (again)
    @pkmn1hearts = 0
    @pkmn2hearts = 0
    @pkmn3hearts = 0
    @pkmn4hearts = 0
    # Next
    @nexto = true
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#  Determines order for first round - based condition (cool,beauty,tough,cute,smart)
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Round 1
  def sort_poke_base_number
    marked = [false,false,false,false]
    marked_a = [false,false,false,false]
    name = [@pkmn1,@pkmn2,@pkmn3,@pkmn4]
    @pokeorder = [0,0,0,0]
    case $game_variables[Name_contest]
    # Cool
    when 1
      poke = [@pkmn1.cool,@pkmn2.cool,@pkmn3.cool,@pkmn4.cool]
      order_poke = poke.sort.reverse
    # Beauty
    when 2
      poke = [@pkmn1.beauty,@pkmn2.beauty,@pkmn3.beauty,@pkmn4.beauty]
      order_poke = poke.sort.reverse
    # Cute
    when 3
      poke = [@pkmn1.cute,@pkmn2.cute,@pkmn3.cute,@pkmn4.cute]
      order_poke = poke.sort.reverse
    # Smart
    when 4
      poke = [@pkmn1.smart,@pkmn2.smart,@pkmn3.smart,@pkmn4.smart]
      order_poke = poke.sort.reverse
    # Tough
    else 
      poke = [@pkmn1.tough,@pkmn2.tough,@pkmn3.tough,@pkmn4.tough]
      order_poke = poke.sort.reverse
    end
    (0...poke.size).each{|i| (0...poke.size).each{|j|
    if order_poke[i] == poke[j] && !marked[i] 
      if !marked_a[j]
        @pokeorder[i] = name[j]
        marked[i] = true
        marked_a[j] = true
      end
    end }}
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#     Determine order for next round
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbOrder
    @stars = [] 
    order = []
    mosthearts = @roundtotals.sort.reverse
    # Move up
    if @MoveUp.include?(true)
      (0...@MoveUp.length).each{|i|
      if @MoveUp[i] && !@MoveDown[i]
        newpoke=(@pokeorder[i]==@pkmn1)? @pkmn1:(@pokeorder[i]==@pkmn2)? @pkmn2:(@pokeorder[i]==@pkmn3)? @pkmn3:@pkmn4
        order.push(newpoke)
        newstars=(newpoke==@pkmn1)? @pkmn1stars:(newpoke==@pkmn2)? @pkmn2stars:(newpoke==@pkmn3)? @pkmn3stars:@pkmn4stars
        @stars.push(newstars)
      end}
    end
    if order.length < 4
     (0...4).each{|i|
      newpoke=nil
      if (mosthearts[i]==@pkmn1total && !(order.include?(@pkmn1)) && !@MoveDown[pbCurrentPokeNum(@pkmn1)])
        newpoke = @pkmn1
      elsif (mosthearts[i]==@pkmn2total && !(order.include?(@pkmn2)) && !@MoveDown[pbCurrentPokeNum(@pkmn2)])
        newpoke = @pkmn2
      elsif (mosthearts[i]==@pkmn3total && !(order.include?(@pkmn3)) && !@MoveDown[pbCurrentPokeNum(@pkmn3)])
        newpoke = @pkmn3
      elsif (mosthearts[i]==@pkmn4total && !(order.include?(@pkmn4)) && !@MoveDown[pbCurrentPokeNum(@pkmn4)])
        newpoke = @pkmn4
      end
      if newpoke != nil
        order.push(newpoke)
        newstars=(newpoke==@pkmn1)? @pkmn1stars:(newpoke==@pkmn2)? @pkmn2stars:(newpoke==@pkmn3)? @pkmn3stars:@pkmn4stars
        @stars.push(newstars)
      end }
    end
    # Move Down
    if @MoveDown.include?(true)
      (0...@MoveDown.length).each{|i|
      if @MoveDown[i] && !@MoveUp[i]
        newpoke=(@pokeorder[i]==@pkmn1)? @pkmn1:(@pokeorder[i]==@pkmn2)? @pkmn2:(@pokeorder[i]==@pkmn3)? @pkmn3:@pkmn4
        order.push(newpoke)
        newstars=(newpoke==@pkmn1)? @pkmn1stars:(newpoke==@pkmn2)? @pkmn2stars:(newpoke==@pkmn3)? @pkmn3stars:@pkmn4stars
        @stars.push(newstars)
      end }
    end
    # Random order for Scramble
    if @Scramble && @round <= 5
      orders=[@pkmn1,@pkmn2,@pkmn3,@pkmn4]
      @stars=[@pkmn1stars,@pkmn2stars,@pkmn3stars,@pkmn4stars]
      # seed RNG with fixed value depending on date (reseed RNG)
      srand 
      neworders = orders.shuffle
      order = neworders
      (0...neworders.length).each{|i|
      if neworders[i] == @pkmn1
        @stars[i] = @pkmn1stars
      elsif neworders[i] == @pkmn2
        @stars[i] = @pkmn2stars
      elsif neworders[i] == @pkmn3
        @stars[i] = @pkmn3stars
      elsif neworders[i] == @pkmn4
        @stars[i] = @pkmn4stars
      end }
    end
    @pokeorder.clear
    @pokeorder = order
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#                        Display Pokemon Graphics
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbPositionPokemonSprite_contest(sprite,left,top)
    sprite.x = left-80
    sprite.y = top-80
  end
#-------------------------------------------------------------------------------
  # Displays the sprite of the fastest pokemon, as per FindFastest
  def pbDisplayFastest  
    @sprites["pokemon1"]=PokemonSprite.new(@viewport1)
    @sprites["pokemon1"].setPokemonBitmap(@pokeorder[0],true)
    @sprites["pokemon1"].mirror=true
    pbPositionPokemonSprite_contest(@sprites["pokemon1"],346,256)
  end
#-------------------------------------------------------------------------------
  def pbDisplayPkmnFast(number)
    @sprites["pokemon#{number+1}"]=PokemonSprite.new(@viewport1)
    @sprites["pokemon#{number+1}"].setPokemonBitmap(@pokeorder[number],true)
    @sprites["pokemon#{number+1}"].mirror=true
    pbPositionPokemonSprite_contest(@sprites["pokemon#{number+1}"],346,256)
  end
#-------------------------------------------------------------------------------
  # Find pokemon's number (i.e. i - position for @pkmn1)
  def pbCurrentPokeNum(poke)
    (0..3).each { |i| return i if @pokeorder[i] == poke }
  end
#-------------------------------------------------------------------------------
  # End round reset
  def pbResetContestMoveEffects  
    @Oblivious=[false,false,false,false]
    @AvoidOnce=[0,0,0,0]
    @Scramble=false
    @MoveUp=[false,false,false,false]
    @MoveDown=[false,false,false,false]
    @UpCondition=[false,false,false,false]
    @previoushearts=0
    @crowdexcitment=true
    @goodappeal=[false,false,false,false]
    @easilystartled=[false,false,false,false]
    @nervous=[false,false,false,false]
    @jamaffected=[false,false,false,false]
    @hasattention=[false,false,false,false]
    # Set again
    pbNervousGraphic
    pbObliviousGraphic
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#   Adjusts hearts via movefunctions.  New move functions go in case statement
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbFunctionsAdjustHearts
    contestmovedata = PBContestMoveData.new(@currentmove)
    @currentfunction = contestmovedata.contestfunction
    @currentjam = contestmovedata.jam
    i = @currentpos-1
    case @currentfunction
    when 1: @AvoidOnce[i] = 1; pbObliviousGraphic
    when 2: @Oblivious[i]=true; pbObliviousGraphic
    when 3: @MoveUp[i]=true
    when 4: @UpCondition[i]=true
    when 5
      pbCustomMessage(_INTL("\\l[3]It tried to startle the other Pokemon!"),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      if @currentpos == 4
        if @Oblivious[2] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[2] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[2]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(2)
          pbJam(@currentjam,@pokeorder[2],3)
          pbDecreaseHearts(@pokeorder[2],3)
          pbStartleGraphic(2,2)
        end
        if @Oblivious[1] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[1] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[1]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(1)
          pbJam(@currentjam,@pokeorder[1],2)
          pbDecreaseHearts(@pokeorder[1],2)
          pbStartleGraphic(1,1)
        end
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      elsif @currentpos == 3
        if @Oblivious[1] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[1]>0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[1]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(1)
          pbJam(@currentjam,@pokeorder[1],2)
          pbDecreaseHearts(@pokeorder[1],2)
          pbStartleGraphic(1,1)
        end
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      elsif @currentpos == 2
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      else
        pbCustomMessage(_INTL("\\l[3]But it failed.."),"Graphics/Pictures/Contest/choice 29",newx=nil,340)  
      end
    when 6
      @currenthearts=@currentpos
      @currenthearts=(@currentpos+1) if @currenpos == 4
    when 7  
      for j in 0...3
        if @hasattention[j] == true && !(j==@currentpos-1)
          if @Oblivious[j] == true
            pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          elsif @AvoidOnce[j] > 0
            pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
            @AvoidOnce[j]=0
            pbObliviousGraphic
          else
            pbStartleGraphic(j-1)
            pbJam(@currentjam,@pokeorder[j],j+1)
            pbDecreaseHearts(@pokeorder[j],j+1)
            pbStartleGraphic(j-1,j-1)
          end
        end
      end
    when 8
      pbCustomMessage(_INTL("\\l[3]It tried to startle the previous Pokemon!"),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      if @currentpos == 4
        if @Oblivious[2] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[2] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[2]=0
          pbObliviousGraphic
        else  
          pbStartleGraphic(2)
          pbJam(@currentjam,@pokeorder[2],3)
          pbDecreaseHearts(@pokeorder[2],3)
          pbStartleGraphic(2,2)
        end
      elsif @currentpos == 3
        if @Oblivious[1] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[1] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[1]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(1)
          pbJam(@currentjam,@pokeorder[1],2)
          pbDecreaseHearts(@pokeorder[1],2)
          pbStartleGraphic(1,1)
        end
      elsif @currentpos == 2
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      else
        pbCustomMessage(_INTL("\\l[3]But it failed.."),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      end
    when 9
      if @priorhearts[@currentpos-1] >= 3
        @currenthearts=(@currenthearts*2)
      else
        @currenthearts==1
      end
    when 10: @easilystartled[i] = true
    when 11: @MoveDown[i] = true
    when 12
      for j in 0..3
        if @priorhearts[j] > 3
          if @Oblivious[j] == true
            pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          elsif @AvoidOnce[j]>0
            pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
            @AvoidOnce[j]=0
            pbObliviousGraphic
          else  
            pbStartleGraphic(j-1)
            pbJam(@currentjam,@pokeorder[j],j+1)
            pbDecreaseHearts(@pokeorder[j],j+1)
            pbStartleGraphic(j-1,j-1)
          end
        end
      end
    when 13
      pbCustomMessage(_INTL("\\l[3]The crowd died down!"),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      @crowdexcitment=false
    when 14
      if @currentpos == 1
        pbCustomMessage(_INTL("\\l[3]The standout {1} hustled even more!",@pokeorder[i].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @currenthearts=(@currenthearts*2)
      end
    when 16
      pbSetMissTurn
      pbCustomMessage(_INTL("\\l[3]It tried to startle the other Pokemon!"),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      if @currentpos == 4
        if @Oblivious[2] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[2] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[2].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[2]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(2)
          pbJam(@currentjam,@pokeorder[2],3)
          pbDecreaseHearts(@pokeorder[2],3)
          pbStartleGraphic(2,2)
        end
        if @Oblivious[1] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[1] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[1]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(1)
          pbJam(@currentjam,@pokeorder[1],2)
          pbDecreaseHearts(@pokeorder[1],2)
          pbStartleGraphic(1,1)
        end
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0]>0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      elsif @currentpos == 3
        if @Oblivious[1] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[1] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[1].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[1]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(1)
          pbJam(@currentjam,@pokeorder[1],2)
          pbDecreaseHearts(@pokeorder[1],2)
          pbStartleGraphic(1,1)
        end
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      elsif @currentpos == 2
        if @Oblivious[0] == true
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        elsif @AvoidOnce[0] > 0
          pbCustomMessage(_INTL("\\l[3]{1} managed to avoid seeing it",@pokeorder[0].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
          @AvoidOnce[0]=0
          pbObliviousGraphic
        else
          pbStartleGraphic(0)
          pbJam(@currentjam,@pokeorder[0],1)
          pbDecreaseHearts(@pokeorder[0],1)
          pbStartleGraphic(0,0)
        end
      else
        pbCustomMessage(_INTL("\\l[3]But it failed.."),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      end
    when 17
      if @currentpos == 1
        (1..3).each { |j| 
        pbCustomMessage(_INTL("\\l[3]{1} became nervous.",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @nervous[j] = true }
      elsif @currentpos == 2
        (2..3).each { |j| 
        pbCustomMessage(_INTL("\\l[3]{1} became nervous.",@pokeorder[j].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @nervous[j] = true }
      elsif @currentpos == 3
        pbCustomMessage(_INTL("\\l[3]{1} became nervous.",@pokeorder[3].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @nervous[3] = true
      end
      pbNervousGraphic
    when 18: pbSetNoMoreMoves  
    when 19: @currenthearts = (@applause+1)
    when 20: @currenthearts = (rand(5)+1)  
    when 21
      if @currentpos == 4
        pbCustomMessage(_INTL("\\l[3]The standout {1} hustled even more!",@pokeorder[i].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @currenthearts = 5
      end
    when 22  
      if @currentpos == 0
        pbCustomMessage(_INTL("\\l[3]But it failed."),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      else
        (0...@currentpos-1).each {|j| pbDecreaseStarGraphics(j,1)}
      end
    when 23
      @currenthearts = @currentpos
      @currenthearts = (@currentpos+1) if @currenpos == 4
    when 24
      pbCustomMessage(_INTL("\\l[3]{1} scrambled up the order for the next turn!",@pokeorder[i].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      @Scramble = true
    when 25: @currenthearts = (@currenthearts*2) if @moveType == @lastmoveType
    when 26: @MoveDown[i] = true
    when 27
      pbSetDoubleNext
      pbCustomMessage(_INTL("\\l[3]{1} is getting prepared.",@pokeorder[i].name),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      @currenthearts = 1
    when 28: @currenthearts=(rand(5)+1)
    when 29  
      if @currentpos == 1
        @currenthearts = 1
      else
        if @priorhearts[@currentpos-1] < 3
          @currenthearts = (@currenthearts*2)
        else
          @currenthearts = 1
        end
      end
    when 30
      if @currentpos == 1
        @currenthearts = 1
      else
        @currenthearts = (@priorhearts[currentpos-1]/2).to_f
      end
    when 31: @applause = 5; pbCrowd(move="notnil")
    when 32
      if @currentpos == 0
        pbCustomMessage(_INTL("\\l[3]But if failed."),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
      else
        (0...@currentpos).each {|j| pbDecreaseStarGraphics(j,1) if @stars[j] > 0 }
      end
    when 33: @currenthearts = @applause
    when 34: @currenthearts = @priorhearts[@currentpos-1]
    when 35: @currenthearts = @stars[@currentpos-1]    
    when 36  
      if @movetype == @contestType
        @currenthearts = (@currenthearts+1)
      else
        @currenthearts = @currenthearts    
      end
    when 37: @currenthearts = (@currenthearts+@priorhearts[@currentpos-1])
    when 38  
      currentApplause = @applause
      currentApplause = 5 if currentApplause < 0 || 5 < currentApplause
      @currenthearts = 6-currentApplause
    when 39: @currenthearts = (@round+1)
    when 40
      if @currentpos > 1
        @currenthearts = (@currenthearts*2) if @priorhearts[@currentpos-1] > 3
      else
        @currenthearts = 1
      end
    when 41: @currenthearts = @applause
    else @currenthearts = @currenthearts
    end
  end
 
#===============================================================================
#                          Controls Applause meter
#===============================================================================

  def pbCrowd(move=nil)
    xPos = -172
    @sprites["Applause Bar"] = IconSprite.new(xPos,0,@viewport)
    @sprites["Applause Bar"].setBitmap("Graphics/Pictures/Contest/applause")
    applausefile=sprintf("Graphics/Pictures/Contest/applause%d",@applause)
    @sprites["applausemeter"] = IconSprite.new((xPos+19),50,@viewport)
    @sprites["applausemeter"].setBitmap(applausefile)
    @appear = 0
    43.times{
    xPos += 4
    @sprites["applausemeter"].x = (xPos+19)
    @sprites["Applause Bar"].x = xPos 
    pbWait(1) # Wait
    }
    if move == nil
      if @moveType == @contestType
        @applause = (@applause+1)
        applausefile = sprintf("Graphics/Pictures/Contest/applause%d",@applause)
        @sprites["applausemeter"].setBitmap(applausefile)
        if @moveType == "Beauty"
          pbCustomMessage(_INTL("\\l[3]{1}'s {2} went over great!",@pokeorder[@currentpos-1].name,@contestType),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        else
          pbCustomMessage(_INTL("\\l[3]{1}'s {2}ness went over great!",@pokeorder[@currentpos-1].name,@contestType),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        end
        @currenthearts = 1
        pbDisplayAddingPositiveHearts
      else
        if @moveType == "Beauty"
          pbCustomMessage(_INTL("\\l[3]{1}'s {2} didn't go over very well!",@pokeorder[@currentpos-1].name,@moveType),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        else
          pbCustomMessage(_INTL("\\l[3]{1}'s {2}ness didn't go over very well!",@pokeorder[@currentpos-1].name,@moveType),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        end
        if @applause > 0
          @applause -= 1
          applausefile = sprintf("Graphics/Pictures/Contest/applause%d",@applause)
          @sprites["applausemeter"].setBitmap(applausefile)
          pbJam(1,@pokeorder[@currentpos-1],@currentpos)
          pbDecreaseHearts(@pokeorder[@currentpos-1],@currentpos,"notnil")
        else
          @applause = 0
          applausefile = sprintf("Graphics/Pictures/Contest/applause%d",@applause)
          @sprites["applausemeter"].setBitmap(applausefile)
        end
      end
      if @crowdexcitment==true && @applause==5
        pbCustomMessage(_INTL("\\l[3]{1}'s {2} really got the crowd going!",@pokeorder[@currentpos-1].name,@moveType),"Graphics/Pictures/Contest/choice 29",newx=nil,340)
        @currenthearts = 5
        pbDisplayAddingPositiveHearts
        @applause=0
        applausefile=sprintf("Graphics/Pictures/Contest/applause%d",@applause)
        @sprites["applausemeter"].setBitmap(applausefile)
      end
      43.times {
      if @sprites["Applause Bar"]
        xPos-=4
        @sprites["Applause Bar"].x = xPos
        @sprites["applausemeter"].x = xPos + 19 if @sprites["applausemeter"]
        pbWait(1) # Wait
      end }
      pbDisposeSprite(@sprites,"Applause Bar") if @sprites["Applause Bar"]
      pbDisposeSprite(@sprites,"applausemeter") if @sprites["applausemeter"]
    end
  end
 
  def pbJam(jam,target,position)
    case target
      when @pkmn1: @pkmn1jam = jam
      when @pkmn2: @pkmn2jam = jam
      when @pkmn3: @pkmn3jam = jam
      else @pkmn4jam = jam
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#                        Miscellaneous Graphic functions
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbNervousGraphic
    if @nervous[0] && !@sprites["nervousone"]
      @sprites["nervousone"] = IconSprite.new(374,47,@viewport)
      @sprites["nervousone"].setBitmap("Graphics/Pictures/Contest/nervous")
    end
    if @nervous[1] && !@sprites["nervoustwo"]
      @sprites["nervoustwo"] = IconSprite.new(374,143,@viewport)
      @sprites["nervoustwo"].setBitmap("Graphics/Pictures/Contest/nervous")
    end
    if @nervous[2] && !@sprites["nervousthree"]
      @sprites["nervousthree"] = IconSprite.new(374,239,@viewport)
      @sprites["nervousthree"].setBitmap("Graphics/Pictures/Contest/nervous")
    end  
    if @nervous[3] && !@sprites["nervousfour"]
      @sprites["nervousfour"] = IconSprite.new(374,335,@viewport)
      @sprites["nervousfour"].setBitmap("Graphics/Pictures/Contest/nervous")
    end  
    pbDisposeSprite(@sprites,"nervousone") if @sprites["nervousone"] && !@nervous[0]
    pbDisposeSprite(@sprites,"nervoustwo") if @sprites["nervoustwo"] && !@nervous[1] 
    pbDisposeSprite(@sprites,"nervousthree") if @sprites["nervousthree"] && !@nervous[2] 
    pbDisposeSprite(@sprites,"nervousfour") if @sprites["nervousfour"] && !@nervous[3] 
  end
#-------------------------------------------------------------------------------
  def pbObliviousGraphic
    if (@Oblivious[0] || @AvoidOnce[0]>0) && !@sprites["obliviousone"]
      @sprites["obliviousone"]=IconSprite.new(374,47+(96*(@currentpos-1)),@viewport)
      @sprites["obliviousone"].setBitmap("Graphics/Pictures/Contest/oblivious")
    end
    if (@Oblivious[1] || @AvoidOnce[1]>0) && !@sprites["oblivioustwo"]
      @sprites["oblivioustwo"]=IconSprite.new(374,47+(96*(@currentpos-1)),@viewport)
      @sprites["oblivioustwo"].setBitmap("Graphics/Pictures/Contest/oblivious")
    end
    if (@Oblivious[2] || @AvoidOnce[2]>0) && !@sprites["obliviousthree"]
      @sprites["obliviousthree"]=IconSprite.new(374,47+(96*(@currentpos-1)),@viewport)
      @sprites["obliviousthree"].setBitmap("Graphics/Pictures/Contest/oblivious")
    end  
    if (@Oblivious[3] || @AvoidOnce[3]>0) && !@sprites["obliviousfour"]
      @sprites["obliviousfour"]=IconSprite.new(374,47+(96*(@currentpos-1)),@viewport)
      @sprites["obliviousfour"].setBitmap("Graphics/Pictures/Contest/oblivious")
    end  
    pbDisposeSprite(@sprites,"obliviousone") if @sprites["obliviousone"] && !@Oblivious[0] && @AvoidOnce[0]==0
    pbDisposeSprite(@sprites,"oblivioustwo") if @sprites["oblivioustwo"] && !@Oblivious[1] && @AvoidOnce[1]==0
    pbDisposeSprite(@sprites,"obliviousthree") if @sprites["obliviousthree"] && !@Oblivious[2] && @AvoidOnce[2]==0
    pbDisposeSprite(@sprites,"obliviousfour") if @sprites["obliviousfour"] && !@Oblivious[3] && @AvoidOnce[3]==0
  end
#-------------------------------------------------------------------------------
  def pbStartleGraphic(position,deletepos=5)
    if position==0 && !@sprites["startleone"]
      @sprites["startleone"]=IconSprite.new(374,47,@viewport)
      @sprites["startleone"].setBitmap("Graphics/Pictures/Contest/startle")
    end
    if position==1 && !@sprites["startletwo"]
      @sprites["startletwo"]=IconSprite.new(374,143,@viewport)
      @sprites["startletwo"].setBitmap("Graphics/Pictures/Contest/startle")
    end
    if position==2 && !@sprites["startlethree"]
      @sprites["startlethree"]=IconSprite.new(374,239,@viewport)
      @sprites["startlethree"].setBitmap("Graphics/Pictures/Contest/startle")
    end  
    if position==3 && !@sprites["startlefour"]
      @sprites["startlefour"]=IconSprite.new(374,335,@viewport)
      @sprites["startlefour"].setBitmap("Graphics/Pictures/Contest/startle")
    end
    if deletepos < 5
      pbDisposeSprite(@sprites,"startleone") if @sprites["startleone"] && deletepos==0
      pbDisposeSprite(@sprites,"startletwo") if @sprites["startletwo"] && deletepos==1
      pbDisposeSprite(@sprites,"startlethree") if @sprites["startlethree"] && deletepos==2
      pbDisposeSprite(@sprites,"startlefour") if @sprites["startlefour"] && deletepos==3
    end
  end
#-------------------------------------------------------------------------------
  def change_star_f(number,graphic,change,decrease,position)
    (0..change).each{|i|
    number -= 1 if decrease && number>0
    number += 1 if !decrease
    @sprites[graphic] = IconSprite.new(350,78+(94*position),@viewport) unless @sprites[graphic]
    starfile = sprintf("Graphics/Pictures/Contest/stars%d",number) if number<=6
    @sprites[graphic].setBitmap(starfile)
    pbWait(2)
    break if number == 0 }
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbDecreaseStarGraphics(position,change,decrease=true)
    case @stars[position]
    when @pkmn1stars; change_star_f(@pkmn1stars,"firstpokestars",change,decrease,position)
    when @pkmn2stars; change_star_f(@pkmn2stars,"secondpokestars",change,decrease,position)
    when @pkmn3stars; change_star_f(@pkmn3stars,"thirdpokestars",change,decrease,position)
    when @pkmn4stars; change_star_f(@pkmn4stars,"fourthpokestars",change,decrease,position)
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                          Animation Stuff Below
#                 Don't change unless you know what you're doing 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbFindAnimation(moveid,userIndex,hitnum)
    begin
      move2anim=load_data("Data/move2anim.dat")
      noflip=false
      # On player's side
      if (userIndex&1)==0   
        anim=move2anim[0][moveid]
      # On opposing side
      else                  
        anim=move2anim[1][moveid]
        noflip=true if anim
        anim=move2anim[0][moveid] if !anim
      end
      return [anim+hitnum,noflip] if anim
      if hasConst?(PBMoves,:TACKLE)
        anim=move2anim[0][getConst(PBMoves,:TACKLE)]
        return [anim,false] if anim
      end
      rescue
      return nil
    end
    return nil
  end
#-------------------------------------------------------------------------------
  def pbAnimation(moveid,user,target,hitnum=0)
    animid=pbFindAnimation(moveid,0,hitnum)
    return if !animid
    anim=animid[0]
    animations=load_data("Data/PkmnAnimations.rxdata")
    pbSaveShadows {
      # On opposing side and using OppMove animation
      if animid[1]
        pbAnimationCore(animations[anim],target,user)
      # On player's side, and/or using Move animation
      else         
        pbAnimationCore(animations[anim],user,target)
      end
    }
  end
#-------------------------------------------------------------------------------
  def pbSaveShadows
    shadows=[]
    for i in 0...4
      s=@sprites["shadow#{i}"]
      shadows[i]=s ? s.visible : false
      s.visible=false if s
    end
    yield
    for i in 0...4
      s=@sprites["shadow#{i}"]
      s.visible=shadows[i] if s
    end
  end
#-------------------------------------------------------------------------------
  def pbAnimationCore(animation,user,target)
    return if !animation
    @briefmessage=false
    case @currentpos
      when 1: usersprite = @sprites["pokemon1"]
      when 2: usersprite = @sprites["pokemon2"]
      when 3: usersprite = @sprites["pokemon3"]
      when 4: usersprite = @sprites["pokemon4"]
    end
    targetsprite = (@atself==false)? @sprites["opponent"] : usersprite
    olduserx = usersprite ? usersprite.x : 0
    oldusery = usersprite ? usersprite.y : 0
    oldtargetx = targetsprite ? targetsprite.x : 0
    oldtargety = targetsprite ? targetsprite.y : 0
    # Start animation player
    animplayer = PBAnimationPlayerContest.new(animation,user,target,usersprite,targetsprite,self)
    userwidth = (!usersprite || !usersprite.bitmap || usersprite.bitmap.disposed?) ? 128 : usersprite.bitmap.width
    userheight = (!usersprite || !usersprite.bitmap || usersprite.bitmap.disposed?) ? 128 : usersprite.bitmap.height
    targetwidth = (!targetsprite.bitmap || targetsprite.bitmap.disposed?) ? 128 : targetsprite.bitmap.width
    targetheight = (!targetsprite.bitmap || targetsprite.bitmap.disposed?) ? 128 : targetsprite.bitmap.height
    
    animplayer.setLineTransform(
    PokeBattle_SceneConstants::FOCUSUSER_X,
    PokeBattle_SceneConstants::FOCUSUSER_Y,
    PokeBattle_SceneConstants::FOCUSTARGET_X,
    PokeBattle_SceneConstants::FOCUSTARGET_Y,
    olduserx+(userwidth/2),
    oldusery+(userheight/2),
    oldtargetx+(targetwidth/2),
    oldtargety+(targetheight/2))
    animplayer.start
    while animplayer.playing?
      animplayer.update
      # Update
      update_ingame
    end
    #usersprite.ox=0 if usersprite
    #usersprite.oy=0 if usersprite
    
    usersprite.x=olduserx if usersprite
    usersprite.y=oldusery if usersprite
    
    targetsprite.ox=0 if targetsprite && targetsprite != usersprite
    targetsprite.oy=0 if targetsprite && targetsprite != usersprite
    targetsprite.x=oldtargetx if targetsprite && targetsprite != usersprite
    targetsprite.y=oldtargety if targetsprite && targetsprite != usersprite
    animplayer.dispose
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------  
#
#                            End of Animation Stuff
#
#-------------------------------------------------------------------------------  
#-------------------------------------------------------------------------------  
#-------------------------------------------------------------------------------  
#-------------------------------------------------------------------------------  
#
#                                 AI
#
#-------------------------------------------------------------------------------  
#------------------------------------------------------------------------------- 
  def pbAI(pokemon,difficulty)
    movescores = []; nummoves = pokemon.numMoves-1
    (0...nummoves).each{|i|
    score = 100
    move = PBMoves.getName(pokemon.moves[i].id)
    currentmovename = PBMoves.getName(pokemon.moves[i].id)
    if pokemon.moves[i].id > 0
      (1..PBContestMoves.maxValue).each{|j|
      name = PBContestMoves.getName(j)
      move = getID(PBContestMoves,j) if move == name }
      contestmovedata = PBContestMoveData.new(move)
      hearts = contestmovedata.hearts
      jam = contestmovedata.jam
      function = contestmovedata.contestfunction
      type = contestmovedata.contestType
      case function
        # No function
        when 0: score += 60 if hearts>3; score += 30 if hearts<=3
        # Gains oblivious. Increase score for earlier position
        when 1,2  
          case @currentpos
          when 1: score += 60
          when 2: score += 40
          when 4: score -= 20
          end
        # Move Up in order
        when 3
          case @currentpos
          when 4: score += 30
          else score += 10
          end
        # Ups condition    
        when 4: score += 30
        # Tries to startle previous pokemons
        when 5
          case @currentpos
          when 4: score += 70
          when 3: score += 40
          when 1: score -= 20
          end
        # Works better later
        when 6,23   
          case @currentpos
          when 4: score += 70
          when 3: score += 40
          when 1: score -= 20
          end
        # Deducts from pokemon that has judges attention
        when 7: (0...@currentpos).each {|k| score+=30 if @hasattention[k] == true }
        # Startles pokemon in front
        when 8  
          case @currentpos
          when 4: score += 40
          when 3: score += 20
          when 1: score -= 20
          end
        # Better if previous move was better
        when 9,40: score += 60 if @priorhearts >= 3; score-=20 if @priorhearts < 3
        # Easily startled
        when 10   
          case @currentpos
          when 4: score += 60
          when 3: score += 40
          when 1: score -= 20
          end
        # Move down in order
        when 11
          case @currentpos
          when 4: score -= 20
          else score += 20
          end
        # Startles pokemon with good appeals    
        when 12 
          case @currentpos
          when 4: score += 20; score+=30 if @priorhearts>3
          when 3: score += 10; score+=30 if @priorhearts>3
          when 1: score -= 20
          end
        # Stops crowd excitement
        when 13: score -=20 if @applause > 3; score +=20 if @applause <= 3
        # Works best if performed first
        when 14: score+=60 if @currentpos == 1
        # Can be used multiple times without boring judge
        when 15: score+=20
        # Jams pokemon and misses turn
        when 16  
          case @currentpos
          when 4: score += 30
          when 3: score += 20
          end
          case @round
          when 5: score += 60
          when 1: score -= 10
          end
        # Makes all pokemon after nervous
        when 17  
          case @currentpos
          when 1: score += 60
          when 2: score += 40
          when 4: score -= 20
          end
        # No more moves
        when 18  
          if @round == 5
            score += 90
          else
            score -= 60
          end
        # Depends on applause level
        when 19: score += 20 if @applause>2
        # Depends on random
        when 20: score += 20
        # Best if performed last
        when 21: score += 60 if @currentpos == 4
        # Removes a star
        when 22,32: score += 40 if @currentpos==4 && @stars.max>1 && @stars.index(@stars.max) != @currentpos-1
        # Scramble
        when 24: score += 30 if @round !=5
        # Works better if last move type is the same
        when 25 
          if @lastmoveType && type==@lastmoveType
            score += 40
          else
            score -= 10
          end
        # Appeal later next turn
        when 26  
          if @currentpos==4
            score -= 20
          else
            score += 20
          end
        # Double next turn
        when 27  
          if @round !=5
            score += 40
          else
            score -= 60
          end
        # Random amounts
        when 28: score += 20
        # Better if last pokemon's wasn't
        when 29  
          if @priorhearts<3
            score += 60
          else
            score -= 20
          end
        # Half as much as previous pokemon
        when 30: score += (@priorhearts/2.to_f)*10 if @priorhearts
        # Gets crowd going
        when 31: score += 40
        # Better based on crowd excitement
        when 33,41: score += (@applause*10).to_f
        # Same amount as last appearl
        when 34,37: score += (@priorhearts.to_f)*10 if @priorhearts
        # Equals the pokemon's stars
        when 35  
          if @stars[@currentpos-1] > 0
            score += @stars[@currentpos-1]*10
          else
            score -= 30
          end
        when 36
          if type == @contestType
            score += 40
          else
            score -= 10
          end
        # Better for lower applause
        when 38  
          case @applause
          when 1: score += 60
          when 2: score += 40
          when 3: score += 20
          when 4: score -= 20
          end  
        # Better for later rounds
        when 39  
          case @round
          when 5: score += 60
          when 3: score += 40
          when 2: score += 20
          when 1: score -= 20
          end  
      end
      # Better if it's the same type as the contest
      score += 60 if type == @contestType
      @currentmovename = currentmovename
      # Better if it will result in a combo
      score += 60 if @round > 1 && pbCheckforCombos 
      score -= 60 if @round > 1 && function != 15 && pbCheckLast
    end
    movescores.push(score) if pokemon.moves[i].id > 0 }
    # Movescores have been added up. Now find highest value, with a bit of variation
    stdev = pbStdDev(movescores)
    # Finds highest scoring move
    choice = movescores.index(movescores.max)
    notchoice = movescores.index(movescores.min)
    # Use the highest scoring move if it's clearly better (stdev of 100 or more)
    return choice if stdev >= 100 && rand(10) != 0  
    newmovescores = movescores.clone
    newmovescores.sort
    secondlowest = movescores.index(newmovescores[1])
    r = rand(movescores.length)
    movescores[notchoice] = nil if difficulty > 25
    movescores[secondlowest] = nil if difficulty > 75
    # Lowest difficulty
    if difficulty > 25
      return r if movescores[r] != nil && rand(10) > 4
    elsif difficulty > 50
      return r if movescores[r] != nil && rand(10) > 2
    elsif difficulty > 75
      2.times { return r if movescores[r] != nil && rand(10) > 2 }
    else
      return r
    end
  end
#------------------------------------------------------------------------------- 
  # From PokeBattle_AI
  def pbStdDev(scores) 
    n = 0; sum = 0
    scores.each{|s| sum += s; n += 1 }
    return 0 if n == 0
    mean = sum.to_f/n.to_f
    varianceTimesN = 0
    for i in 0...scores.length
      if scores[i] > 0
        deviation=scores[i].to_f-mean
        varianceTimesN+=deviation*deviation
      end
    end
    # Using population standard deviation
    # [(n-1) makes it a sample std dev, would be 0 with only 1 sample]
    return Math.sqrt(varianceTimesN/n)
  end
#------------------------------------------------------------------------------- 
#------------------------------------------------------------------------------- 
#------------------------------------------------------------------------------- 
#
#                               End of AI
#
#------------------------------------------------------------------------------- 
#------------------------------------------------------------------------------- 
#------------------------------------------------------------------------------- 
#------------------------------------------------------------------------------- 
#-------------------------------------------------------------------------------
#
#                              Results Scene
#
#-------------------------------------------------------------------------------
#------------------------------------------------------------------------------- 
  def pbResultsScene
    # Update
    update_ingame
    store = $game_variables[Store_pokemon_contest]
    @sprites["bg"] = Sprite.new(@viewport2)
    @sprites["bg"].bitmap = Bitmap.new("Graphics/Pictures/Contest/Background")
    (1..5).each{|i| (1..4).each{|j|
    @sprites["color#{i}_#{j}"] = Sprite.new(@viewport2)
    @sprites["color#{i}_#{j}"].bitmap = Bitmap.new("Graphics/Pictures/Contest/Color_Bar")
    @sprites["color#{i}_#{j}"].src_rect.width = @sprites["color#{i}_#{j}"].bitmap.width
    @sprites["color#{i}_#{j}"].src_rect.height = @sprites["color#{i}_#{j}"].bitmap.height/5
    @sprites["color#{i}_#{j}"].x = -93
    @sprites["color#{i}_#{j}"].visible = false }}
    (1..5).each{|i|
	  @sprites["color#{i}_1"].src_rect.y = -20 + i*20
	  @sprites["color#{i}_2"].src_rect.y = -20 + i*20
	  @sprites["color#{i}_3"].src_rect.y = -20 + i*20
	  @sprites["color#{i}_4"].src_rect.y = -20 + i*20 }
    (1..4).each{|i|
    @sprites["color1_#{i}"].y = 78+i*50
    @sprites["color2_#{i}"].y = 78+i*50
    @sprites["color3_#{i}"].y = 78+i*50
    @sprites["color4_#{i}"].y = 78+i*50
    @sprites["color5_#{i}"].y = 78+i*50 }
    # Set background
    @sprites["bg2"] = Sprite.new(@viewport2)
    @sprites["bg2"].bitmap = Bitmap.new("Graphics/Pictures/Contest/Background_2")
    # Set result
    @sprites["results"] = IconSprite.new(0,0,@viewport2)
    @sprites["results"].setBitmap("Graphics/Pictures/Contest/resultsbg")
    # Draw poke icons
    @pkmn1sprite = PokemonIconSprite.new(@pkmn1,@viewport2)
    @pkmn2sprite = PokemonIconSprite.new(@pkmn2,@viewport2)
    @pkmn3sprite = PokemonIconSprite.new(@pkmn3,@viewport2)
    @pkmn4sprite = PokemonIconSprite.new(@pkmn4,@viewport2)
    # Positions poke icons
    @pkmn1sprite.x = 86
    @pkmn2sprite.x = 86
    @pkmn3sprite.x = 86
    @pkmn4sprite.x = 86
    @pkmn1sprite.y = 93
    @pkmn2sprite.y = @pkmn1sprite.y + 50
    @pkmn3sprite.y = @pkmn2sprite.y + 50
    @pkmn4sprite.y = @pkmn3sprite.y + 50
    # Bitmap to draw text on, instead of pbMessage
    @sprites["textbitmap"]= BitmapSprite.new(Graphics.width,Graphics.height,@viewport2) 
    @sprites["textbitmap"].z= @viewport2.z
    # Color for rectangles, determined by contest type
    rectcolor=(@contestType=="Coolness")?Color.new(178,34,34):(@contestType=="Beauty")?Color.new(0,0,255):(@contestType=="Smartness")?Color.new(0,100,0):(@contestType=="Toughness")?Color.new(255,215,0):Color.new(255,0,255)
    case @contestType
    when "Coolness": (1..4).each { |i| @sprites["color1_#{i}"].visible = true }
    when "Beauty": (1..4).each { |i| @sprites["color2_#{i}"].visible = true }
    when "Smartness": (1..4).each { |i| @sprites["color3_#{i}"].visible = true }
    when "Toughness": (1..4).each { |i| @sprites["color4_#{i}"].visible = true }
    when "Cuteness": (1..4).each { |i| @sprites["color5_#{i}"].visible = true }
    end
    # Points Preliminary
    case @contestType
    when "Coolness"
      @prelim1 += 20 if isConst?($Trainer.party[store].item,PBItems,:REDSCARF)
      @prelim1 += $Trainer.party[store].cool
      @prelim2 += @pkmn2.cool
      @prelim3 += @pkmn3.cool
      @prelim4 += @pkmn4.cool
    when "Beauty"
      @prelim1 += 20 if isConst?($Trainer.party[store].item,PBItems,:BLUESCARF)
      @prelim1 += $Trainer.party[store].beauty
      @prelim2 += @pkmn2.beauty
      @prelim3 += @pkmn3.beauty
      @prelim4 += @pkmn4.beauty
    when "Smartness"
      @prelim1 += 20 if isConst?($Trainer.party[store].item,PBItems,:GREENSCARF)
      @prelim1 += $Trainer.party[store].smart
      @prelim2 += @pkmn2.smart
      @prelim3 += @pkmn3.smart
      @prelim4 += @pkmn4.smart
    when "Toughness"
      @prelim1 += 20 if isConst?($Trainer.party[store].item,PBItems,:YELLOWSCARF)
      @prelim1 += $Trainer.party[store].tough
      @prelim2 += @pkmn2.tough
      @prelim3 += @pkmn3.tough
      @prelim4 += @pkmn4.tough
    when "Cuteness"
      @prelim1 += 20 if isConst?($Trainer.party[store].item,PBItems,:PINKSCARF)  
      @prelim1 += $Trainer.party[store].cute
      @prelim2 += @pkmn2.cute
      @prelim3 += @pkmn3.cute
      @prelim4 += @pkmn4.cute
    end
    # Extra points if it's shiny
    @prelim1 += 25 if $Trainer.party[store].isShiny?
    @prelim2 += 25 if @pkmn2.isShiny?
    @prelim3 += 25 if @pkmn3.isShiny?
    @prelim4 += 25 if @pkmn4.isShiny?
    # Gives points for "scarves".  Pokemon won't actually have any.  Less likely to
    @prelim2 += 20 if (@difficulty==100 || (@difficulty==75 && rand(1)==0) || (@difficulty==50 && rand(2)==0))
    @prelim3 += 20 if (@difficulty==100 || (@difficulty==75 && rand(1)==0) || (@difficulty==50 && rand(2)==0))
    @prelim4 += 20 if (@difficulty==100 || (@difficulty==75 && rand(1)==0) || (@difficulty==50 && rand(2)==0))
    # Method for determine winner
    method_determine_order_poke_2
    # Array of the scores to use
    @results=[(@prelim1*130/297).to_f,(@prelim2*130/297).to_f,(@prelim3*130/297).to_f,(@prelim4*130/297).to_f]
    loop do
      # Update
      update_ingame
      if !@contestover
        # Start
        textpos=[]
        textpos.push([_INTL("Announcing the results!"),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        pbWait(3)
        # Draw rectangles, using the prelims as the initial
        textpos.clear
        @sprites["textbitmap"].bitmap.clear
        textpos=[]
        textpos.push([_INTL("The preliminary results!"),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        pbDrawTextPositions(@sprites["textbitmap"].bitmap,textpos)
        10.times {
        (1..5).each { |i| @sprites["color#{i}_1"].x += (@results[0]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_2"].x += (@results[1]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_3"].x += (@results[2]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_4"].x += (@results[3]/10).to_f }
        pbWait(1) # Wait
        }
        # Operation of second results
        (0..3).each{|i|
        if @order_winner[i] == @pkmn1
          @results_scd[0]=(@winner[i]*260/@winner[0]).to_f - @results[0]
        elsif @order_winner[i] == @pkmn2
          @results_scd[1]=(@winner[i]*260/@winner[0]).to_f - @results[1]
        elsif @order_winner[i] == @pkmn3
          @results_scd[2]=(@winner[i]*260/@winner[0]).to_f - @results[2]
        elsif @order_winner[i] == @pkmn4
          @results_scd[3]=(@winner[i]*260/@winner[0]).to_f - @results[3]
        end}
        pbWait(20)
        # Second results
        textpos = []
        @sprites["textbitmap"].bitmap.clear
        textpos.push([_INTL("Round 2 results!"),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        pbDrawTextPositions(@sprites["textbitmap"].bitmap,textpos)
        10.times {
        (1..5).each { |i| @sprites["color#{i}_1"].x += (@results_scd[0]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_2"].x += (@results_scd[1]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_3"].x += (@results_scd[2]/10).to_f }
        pbWait(1) # Wait
        (1..5).each { |i| @sprites["color#{i}_4"].x += (@results_scd[3]/10).to_f }
        pbWait(1) # Wait 
        }
        @sprites["textbitmap"].bitmap.clear
        textpos = []
        # Determine winner
        case @quantity_winner
        when 1
          textpos.push([(_INTL("{1} is the winner!",@order_winner[0].name)),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        when 2
          textpos.push([(_INTL("{1} and {2} are the winners!",@order_winner[0].name,@order_winner[1].name)),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        when 3
          textpos.push([(_INTL("{1},{2} and {3} are the winners!",@order_winner[0].name,@order_winner[1].name,@order_winner[2].name)),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        when 4
          textpos.push([(_INTL("{1},{2},{3} and {4} are the winners!",@order_winner[0].name,@order_winner[1].name,@order_winner[2].name,@order_winner[3].name)),Graphics.width/3,309,0,rectcolor,Color.new(136,168,208)])
        end
        pbDrawTextPositions(@sprites["textbitmap"].bitmap,textpos)
        $Trainer.party[store].giveRibbon(@ribbonnum) if !($Trainer.party[store].hasRibbon?(@ribbonnum)) && @player_win
        # Allows scene to exit loop and end
        @contestover = true
      else
        @exit2 = true if Input.trigger?(Input::C)
        break if @exit2
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Determine winner
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def method_determine_order_poke_2
    # Marked
    marked = [false,false,false,false]
    marked_a = [false,false,false,false]
    # Set
    pkmnT = [@pkmn1,@pkmn2,@pkmn3,@pkmn4]
    @order_winner = [0,0,0,0]
    # Score
    p1 = @pkmn1total + @prelim1 + @pkmn1stars
    p2 = @pkmn2total + @prelim2 + @pkmn2stars
    p3 = @pkmn3total + @prelim3 + @pkmn3stars
    p4 = @pkmn4total + @prelim4 + @pkmn4stars
    if p1 <= 0 
      p1 = 0 
    elsif p2 <= 0
      p2 = 0
    elsif p3 <= 0
      p3 = 0
    elsif p4 <= 0
      p4 = 0
    end
    @winner=[p1,p2,p3,p4]
    w_s = @winner.sort.reverse
    (0...4).each{|i| (0...4).each{|j|
    if w_s[i] == @winner[j] && !marked[i] 
      if !marked_a[j]
        @order_winner[i] = pkmnT[j]
        marked[i] = true
        marked_a[j] = true
      end
    end }}
    @player_win = true if @order_winner[0] == @pkmn1 && w_s[0] != w_s[1]
    w_u = w_s
    w_u.uniq!
    case w_u.size
    when 1; @quantity_winner = 4
    when 2; @quantity_winner = 3
    when 3; @quantity_winner = 2
    when 4; @quantity_winner = 1
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Update Sprite
  def update; pbUpdateSpriteHash(@sprites); end
  
  # Update
  def update_ingame
    Graphics.update
    Input.update
    self.update
  end
#-------------------------------------------------------------------------------
  # Ends everything
  def pbEndScene
    @pkmn1sprite.dispose
    @pkmn2sprite.dispose
    @pkmn3sprite.dispose
    @pkmn4sprite.dispose
    pbDisposeSpriteHash(@heartsprites) if @heartsprites
    pbDisposeSpriteHash(@sprites)
    if @quantity_winner == 1
      case @order_winner[0] 
      when @pkmn1: position = "No.4"
      when @pkmn2: position = "No.1"
      when @pkmn3: position = "No.2"
      when @pkmn4: position = "No.3"
      end
      pbMessage(_INTL("MC: Congratulation! The winner is {1},{2}",position,@order_winner[0].name))
      pbMessage(_INTL("MC: Your ribbon will get after this show. Thank you!"))
    else
      pbMessage(_INTL("MC: OMG! I can't believe. We are the winners. Sorry! We must restart."))
      pbMessage(_INTL("MC: Please register again."))
    end
    # Reset variables
    $game_variables[Name_contest]=0
    $game_variables[Store_pokemon_contest]=0
    $game_variables[Store_difficulty_contest] = 0
    # Reset these global variables for next use
    (0..3).each{|i|
    CONTESTMOVE2[i]=0 
    CONTESTMOVE3[i]=0
    CONTESTMOVE4[i]=0 }
    # Reset these global variables for next use
    $CONTESTNAME2 = "" 
    $CONTESTNAME3 = ""
    $CONTESTNAME4 = ""
    $game_map.autoplay
    @viewport.dispose
    transferPlayer(*COORIDINATE_WHEN_FINISH_CONTEST)
  end
  
end

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

class PokeContest
  def initialize(scene)
    @scene=scene
  end
 
  def pbStartContest
    @scene.pbStartContest
    @scene.pbEndScene
  end
end
 
 
def pbContest
  scene=PokeContestScene.new
  screen=PokeContest.new(scene)
  screen.pbStartContest
end

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Animation player for contest
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class PBAnimationPlayerContest
  attr_accessor :looping
  MAXSPRITES=30
 
  def initialize(animation,user,target,usersprite,targetsprite,scene=nil,ineditor=false)
    @animation=animation
    @user=user
    @usersprite=usersprite
    @targetsprite=targetsprite
    @userbitmap=(@usersprite && @usersprite.bitmap) ? @usersprite.bitmap : nil # not to be disposed
    @targetbitmap=(@targetsprite && @targetsprite.bitmap) ? @targetsprite.bitmap : nil # not to be disposed
    @scene=scene
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=999
    @ineditor=ineditor
    @looping=false
    # Animation sheet graphic
    @animbitmap=nil 
    @frame=-1
    @srcLine=nil
    @dstLine=nil
    @userOrig=getSpriteCenter(@usersprite)
    @targetOrig=getSpriteCenter(@targetsprite)
    @animsprites=[]
    @animsprites[0]=@usersprite
    @animsprites[1]=@targetsprite
    (2...MAXSPRITES).each { |i|
      @animsprites[i] = Sprite.new(@viewport); @animsprites[i].bitmap = nil; @animsprites[i].visible = false
    }
    @bgColor=ColoredPlane.new(Color.new(0,0,0),@viewport)
    @bgColor.borderX=64 if ineditor
    @bgColor.borderY=64 if ineditor
    @bgColor.z=2
    @bgColor.opacity=0
    @bgColor.refresh
    @bgGraphic=AnimatedPlane.new(@viewport)
    @bgGraphic.setBitmap(nil)
    @bgGraphic.borderX=64 if ineditor
    @bgGraphic.borderY=64 if ineditor
    @bgGraphic.z=2
    @bgGraphic.opacity=0
    @bgGraphic.refresh
    @oldbg=[]
   
    @foColor=ColoredPlane.new(Color.new(0,0,0),@viewport)
    @foColor.borderX=64 if ineditor
    @foColor.borderY=64 if ineditor
    @foColor.z=38
    @foColor.opacity=0
    @foColor.refresh
    @foGraphic=AnimatedPlane.new(@viewport)
    @foGraphic.setBitmap(nil)
    @foGraphic.borderX=64 if ineditor
    @foGraphic.borderY=64 if ineditor
    @foGraphic.z=38
    @foGraphic.opacity=0
    @foGraphic.refresh
    @oldfo=[]
  end

  def dispose
    @animbitmap.dispose if @animbitmap
    for i in 2...MAXSPRITES
      @animsprites[i].dispose if @animsprites[i]
    end
    @bgGraphic.dispose
    @bgColor.dispose
    @foGraphic.dispose
    @foColor.dispose
  end
 
  def start
    @frame=0
  end
 
  def playing?
    return @frame>=0
  end
 
  def setLineTransform(x1,y1,x2,y2,x3,y3,x4,y4)
    @srcLine=[x1,y1,x2,y2]
    @dstLine=[x3,y3,x4,y4]
  end
 
  def update
    return if @frame<0
    if (@frame>>1) >= @animation.length
      @frame=(@looping) ? 0 : -1
      if @frame<0
        @animbitmap.dispose if @animbitmap
        @animbitmap=nil
        return
      end
    end
    if !@animbitmap || @animbitmap.disposed?
      @animbitmap=AnimatedBitmap.new("Graphics/Animations/"+@animation.graphic,
         @animation.hue).deanimate
      for i in 0...MAXSPRITES
        @animsprites[i].bitmap=@animbitmap if @animsprites[i]
      end
    end
    @bgGraphic.update
    @bgColor.update
    @foGraphic.update
    @foColor.update
    if (@frame&1)==0
      thisframe=@animation[@frame>>1]
      # Make all cel sprites invisible
      for i in 0...MAXSPRITES
        @animsprites[i].visible=false if @animsprites[i]
      end
      # Set each cel sprite acoordingly
      for i in 0...thisframe.length
        cel=thisframe[i]
        next if !cel
        sprite=@animsprites[i]
        next if !sprite
        # Set cel sprite's graphic
        if cel[AnimFrame::PATTERN]==-1
          sprite.bitmap=@userbitmap
        elsif cel[AnimFrame::PATTERN]==-2
          sprite.bitmap=@targetbitmap
        else
          sprite.bitmap=@animbitmap
        end
        cel[AnimFrame::MIRROR]=1
        # Apply settings to the cel sprite
        pbSpriteSetAnimFrame(sprite,cel,@usersprite,@targetsprite)
        case cel[AnimFrame::FOCUS]
          # Focused on target
          when 1   
            sprite.x=cel[AnimFrame::X]+@targetOrig[0]-PokeBattle_SceneConstants::FOCUSTARGET_X
            sprite.y=cel[AnimFrame::Y]+@targetOrig[1]-PokeBattle_SceneConstants::FOCUSTARGET_Y
          # Focused on user
          when 2   
            sprite.x=cel[AnimFrame::X]+@userOrig[0]-PokeBattle_SceneConstants::FOCUSUSER_X
            sprite.y=cel[AnimFrame::Y]+@userOrig[1]-PokeBattle_SceneConstants::FOCUSUSER_Y
          # Focused on user and target
          when 3   
            if @srcLine && @dstLine
              point=transformPoint(
                 @srcLine[0],@srcLine[1],@srcLine[2],@srcLine[3],
                 @dstLine[0],@dstLine[1],@dstLine[2],@dstLine[3],
                 sprite.x,sprite.y)
              sprite.x=point[0]
              sprite.y=point[1]
            end
        end
        sprite.x+=64 if @ineditor
        sprite.y+=64 if @ineditor
      end
      # Play timings
      @animation.playTiming(@frame>>1,@bgGraphic,@bgColor,@foGraphic,@foColor,@oldbg,@oldfo,@user)
    end
    @frame+=1
  end
end