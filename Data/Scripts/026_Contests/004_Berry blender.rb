#-------------------------------------------------------------------------------
# Berry blender by bo4p5687; graphics by Richard PT
#
# References: (bulbapedia.bulbagarden.net)
#-------------------------------------------------------------------------------
# How to use:
#  pbOneplayer -> mode one player
#  pbTwoplayers -> mode two players
#  pbThreeplayers -> mode three players
#  pbFourplayers -> mode four players
#  pbSpecialplayer -> mode special player
#-------------------------------------------------------------------------------
#
# To this script works, put it above main.
# Using the script "Pokeblock" with this script.
#
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => "Berry blender",
  :credits => ["bo4p5687", "graphics by Richard PT"]
})
#-------------------------------------------------------------------------------
# Limit of pokeblock
MAX_POKEBLOCK = 999 
#-------------------------------------------------------------------------------
# Variable should be reserved
COLOR_SAVOUR = [
  [401,402,403,404], # Gold 
  [405], # Black
  
  [406,407], # Gray
  [408,409], # White
  
  [410,411], # Red
  [412,413], # Blue
  [414,415], # Pink
  [416,417], # Green
  [418,419], # Yellow
  
  [420,421], # Purple
  [422,423], # Indigo
  [424,425], # Brown
  [426,427], # Lite Blue
  [428,429]  # Olive
]
#-------------------------------------------------------------------------------
#
#
#-------------------------------------------------------------------------------
class BerryBlender
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Name player
# You can add the name here.
NAME_PLAYER_ONE = ["JANE","JASON","JACK","NICOLA"]
NAME_PLAYER_TWO = ["JAME","GABRIEL","XAVIER","FABIO"]
NAME_PLAYER_THREE = ["PALMA","PAM","TABBY","DAISY"]
NAME_PLAYER_SPECIAL = ["MASTER","SUPER"]
#-------------------------------------------------------------------------------
# The berries which a special player can play with the player.
BERRIES_SPECIAL = [
"Cheri Berry","Chesto Berry","Pecha Berry","Rawst Berry",
"Aspear Berry","Leppa Berry","Oran Berry","Persim Berry",
"Lum Berry","Sitrus Berry","Figy Berry","Wiki Berry",
"Mago Berry","Aguav Berry","Iapapa Berry","Razz Berry",
"Bluk Berry","Nanab Berry","Wepear Berry","Pinap Berry",
"Pomeg Berry","Kelpsy Berry","Qualot Berry","Hondew Berry",
"Grepa Berry","Tamato Berry","Cornn Berry","Magost Berry",
"Rabuta Berry","Nomel Berry","Spelon Berry","Pamtre Berry",
"Watmel Berry","Durin Berry","Belue Berry","Occa Berry",
"Passho Berry","Wacan Berry","Rindo Berry","Yache Berry",
"Chople Berry","Kebia Berry","Shuca Berry","Coba Berry",
"Payapa Berry","Tanga Berry","Charti Berry","Kasib Berry",
"Haban Berry","Colbur Berry","Babiri Berry","Chilan Berry",
"Liechi Berry","Ganlon Berry","Salac Berry","Petaya Berry",
"Apicot Berry","Lansat Berry","Starf Berry","Enigma Berry",
"Micle Berry","Custap Berry","Jaboca Berry","Rowap Berry"]
#-------------------------------------------------------------------------------
# Each line is a serial flavor of each berry.
FLAVOR = [
# spicy | dry | sweet | bitter | sour
[1,0,0,0,-1], # Cheri Berry Flavor
[-1,1,0,0,0], # Chesto Berry Flavor
[0,-1,1,0,0], # Pecha Berry Flavor
[0,0,-1,1,0], # Rawst Berry Flavor
[0,0,0,-1,1], # Aspear Berry Flavor
[1,-1,0,0,0], # Leppa Berry Flavor
[0,0,0,0,0], # Oran Berry Flavor
[0,0,0,0,0], # Persim Berry Flavor
[0,0,0,0,0], # Lum Berry Flavor
[0,0,0,0,0], # Sitrus Berry Flavor
[1,0,0,0,-1], # Figy Berry Flavor
[-1,1,0,0,0], # Wiki Berry Flavor
[0,-1,1,0,0], # Mago Berry Flavor
[0,0,-1,1,0], # Aguav Berry Flavor
[0,0,0,-1,1], # Iapapa Berry Flavor
[0,1,0,0,-1], # Razz Berry Flavor
[-1,0,1,0,0], # Bluk Berry Flavor
[0,-1,0,1,0], # Nanab Berry Flavor
[0,0,-1,0,1], # Wepear Berry Flavor
[1,0,0,-1,0], # Pinap Berry Flavor
[1,-1,0,1,-1], # Pomeg Berry Flavor
[-1,1,-1,0,1], # Kelpsy Berry Flavor
[1,-1,1,-1,0], # Qualot Berry Flavor
[0,1,-1,1,-1], # Hondew Berry Flavor
[-1,0,1,-1,1], # Grepa Berry Flavor
[1,1,0,0,-2], # Tamato Berry Flavor
[-2,1,1,0,0], # Cornn Berry Flavor
[0,-2,1,1,0], # Magost Berry Flavor
[0,0,-2,1,1], # Rabuta Berry Flavor
[1,0,0,-2,1], # Nomel Berry Flavor
[3,1,0,0,-4], # Spelon Berry Flavor
[-4,3,1,0,0], # Pamtre Berry Flavor
[0,-4,3,1,0], # Watmel Berry Flavor
[0,0,-4,3,1], # Durin Berry Flavor
[1,0,0,-4,3], # Belue Berry Flavor
[0,0,0,0,0], # Occa Berry Flavor # Generation IV
[0,0,0,0,0], # Passho Berry Flavor # Generation IV
[0,0,0,0,0], # Wacan Berry Flavor # Generation IV
[0,0,0,0,0], # Rindo Berry Flavor # Generation IV
[0,0,0,0,0], # Yache Berry Flavor # Generation IV
[0,0,0,0,0], # Chople Berry Flavor # Generation IV
[0,0,0,0,0], # Kebia Berry Flavor # Generation IV
[0,0,0,0,0], # Shuca Berry Flavor # Generation IV
[0,0,0,0,0], # Coba Berry Flavor # Generation IV
[0,0,0,0,0], # Payapa Berry Flavor # Generation IV
[0,0,0,0,0], # Tanga Berry Flavor # Generation IV
[0,0,0,0,0], # Charti Berry Flavor # Generation IV
[0,0,0,0,0], # Kasib Berry Flavor # Generation IV
[0,0,0,0,0], # Haban Berry Flavor # Generation IV
[0,0,0,0,0], # Colbur Berry Flavor # Generation IV
[0,0,0,0,0], # Babiri Berry Flavor # Generation IV
[0,0,0,0,0], # Chilan Berry Flavor # Generation IV
[4,-4,4,-1,-3], # Liechi Berry Flavor
[-4,4,-4,4,0], # Ganlon Berry Flavor
[0,-4,4,-4,4], # Salac Berry Flavor
[4,0,-4,4,-4], # Petaya Berry Flavor
[-4,4,0,-4,4], # Apicot Berry Flavor
[0,0,0,0,0], # Lansat Berry Flavor
[0,0,0,0,0], # Starf Berry Flavor
[0,0,0,0,0], # Enigma Berry Flavor
[0,0,0,0,0], # Micle Berry Flavor # Generation IV
[0,0,0,0,0], # Custap Berry Flavor # Generation IV
[0,0,0,0,0], # Jaboca Berry Flavor # Generation IV
[0,0,0,0,0]  # Rowap Berry Flavor # Generation IV
]

#-------------------------------------------------------------------------------
  def initialize(number)
    # Viewport
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99998
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=99999
    # Sprites
    @sprites={}
    # Berries in Bag
    @determine_berries = []
    (1..PBItems.maxValue).each { |i| @determine_berries.push(i) if pbIsBerry?(i)}
    # Set process
    @process = 0
    # Set exit
    @exit = false
    # Set Name Player(AI)
    @nameplayerone = NAME_PLAYER_ONE.shuffle.first
    @nameplayertwo = NAME_PLAYER_TWO.shuffle.first
    @nameplayerthree = NAME_PLAYER_THREE.shuffle.first
    @nameplayerspecial = NAME_PLAYER_SPECIAL.shuffle.first
    # Check mode for play
    @check_mode = nil; @numplayer = number
    # Berry for choose
    @berry = 0
    # Scale
    @scale = [4,3,2,1]
    # Set speed
    @speed = 0
    # ID berry for AI
    @berryone = 0; @berrytwo = 0; @berrythree = 0; @berryspecial = 0
    # Record 
    @perfect = 0; @good = 0; @miss = 0
    @perfectone = 0; @goodone = 0; @missone = 0
    @perfecttwo = 0; @goodtwo = 0; @misstwo = 0
    @perfectthree = 0; @goodthree = 0; @missthree = 0
    # Effects appear
    @appear = 0
    # Set the circle
    @circle = 0; @circletwo = 2
    # Decrease speed
    @decrease = 0 
    # Increase time
    @increase = 0 
    # Max speed
    @maxspeed = 0
    # Set disappear
    @disappear = [[],[],[]]; @disappear_one = [[],[],[]]; @disappear_two = [[],[],[]]; @disappear_three = [[],[],[]]
    # Flavor of berry
    @flavor = []
    # Can get reward
    @getreward = false
    # Note
    # rank; name; berry
    @note = []; @note2 = []; @note3 = []
    # Set rank
    @rank = []
    # Record after play
    @qsym = []; @qsym2 = []; @qsym3 = []; @qsym4 = []
    # Record information
    @recp = []; @recp2 = []; @recp3 = []; @recp4 = []
    # Record (sum)
    @recall = []
    # Flavor
    @flavorplayer = 0; @flavorplayerone = 0; @flavorplayertwo = 0; @flavorplayerthree = 0; @flavorplayerspecial = 0
  end
  
  def pbStart
    if hasBerries
      pbBGMPlay("021-Field04")
      # Draw
      draw_scene
      # Choose
      pbMessage(_INTL("Starting up the Berry Blender."))
      pbMessage(_INTL("Please select a Berry from your Bag to put in the Berry Blender"))
      case @numplayer
        when 0; one_player 
        when 1; two_players 
        when 2; three_players 
        when 3; four_players 
        else; special_player 
      end
      pbEndScene
      $game_map.update
      $game_map.autoplay
    else
      pbMessage(_INTL("You don't have any berries."))
    end
  end
#-------------------------------------------------------------------------------
  # One player
  def one_player
    loop do
      @check_mode = 1
      # Update
      update_ingame
      break if @exit
      case @process
      when 0
        # Choose berry in your bag
        choice_berry
        @process = 1
      when 1
        if @berry > 0
          # Delete item
          $PokemonBag.pbDeleteItem(@berry,1)
          # Draw overlay
          draw_speed_overlay # Speed
          @process = 2
        else
          if pbConfirmMessage("Do you want to continue?")
            pbMessage(_INTL("Plese select Berry."))
            @process = 0
          else
            @exit = true
          end
        end
      when 2
        # Draw
        scene_one # 1 player (scene)
        draw_berry_one # Berry
        draw_name_player # Name (Scene-All)
        name_player # Name of player
        draw_annoucement # Annoucement
        draw_effect # Effect
        draw_time_bar # Time
        @process = 3 
      when 3
        # Draw
        draw_speed # Speed
        # Annimation Berry
        annimation_berry_one
        @process = 4 if !@sprites["berry"].visible
      when 4
        # Draw
        draw_circle # Circle
        # Scale
        (0...@scale.size).each{|i| @sprites["circle"].zoom_x = @scale[i]
        @sprites["circle"].zoom_y = @scale[i]; pbWait(3)}
        @process = 5 if @sprites["circle"].zoom_x <= 1 && @sprites["circle"].zoom_y <= 1
      when 5
        # Annoucement
        annoucement
        @speed = 7
        # Draw
        draw_speed # Speed 
        @process = 6 if !@sprites["start"].visible
      when 6
        # Play
        play
        @process = 7 if @sprites["time"].x >= 188
      when 7
        disappear_2
        (1..2).each { |i| @sprites["effect#{i}"].visible = false }
        pbWait(10)
        # Draw Result
        draw_result
        draw_text_result_overlay
        @process = -1
      when -1
        @sprites["results"].y += 8
        if @sprites["results"].y >= 0
          @sprites["results"].y = 0
          pbWait(10)
          @process = 8 
        end
      when 8
        # Draw
        draw_results_symbol # Symbol of Perfect, Good, Miss
        draw_result_one # Result
        @process = 9 if Input.trigger?(Input::C)
      when 9
        # Clear symbol
        bitmap = @sprites["overlay_results_symbol"].bitmap
        bitmap.clear
        # Redraw
        redraw_result_one
        @process = 10 if Input.trigger?(Input::C)
      when 10
        @sprites["results"].visible = false
        # Clear result
        @sprites["overlay_results"].bitmap.clear
        # Flavor
        determine_color_one
        if pbConfirmMessage("Would you like to blend another Berry?")
          @process = 11
        else
          @exit = true
        end
      when 11
        # Dispose
        dispose
        # Redraw
        draw_scene
        # Set_again
        @berry = 0
        @perfect = 0; @good = 0; @miss = 0
        @appear = 0
        @speed = 0; @maxspeed = 0
        @decrease = 0 
        @increase = 0
        @circle = 0; @circletwo = 2
        @disappear = [[],[],[]]
        @process = 0
      end
    end
  end
#-------------------------------------------------------------------------------
  # Two players
  def two_players
    loop do
      @check_mode = 2
      # Update
      update_ingame
      break if @exit
      case @process
      when 0
        # Choose berry in your bag
        choice_berry
        @process = 1
      when 1
        if @berry > 0
          # Delete item
          $PokemonBag.pbDeleteItem(@berry,1)
          # Draw overlay
          draw_speed_overlay # Speed
          @process = 2
        else
          if pbConfirmMessage("Do you want to continue?")
            pbMessage(_INTL("Plese select Berry."))
            @process = 0
          else
            @exit = true
          end
        end
      when 2
        # Draw
        scene_two # 2 players (scene)
        # Berry
        draw_berry_one 
        draw_berry_two
        draw_name_player # Name (Scene-All)
        name_player # Name of player
        name_one # Name of AI (1)
        draw_annoucement # Annoucement
        draw_effect # Effect
        draw_time_bar # Time
        @process = 3 
      when 3
        # Draw
        draw_speed # Speed
        # Annimation Berry
        annimation_berry_two
        @process = 4 if !@sprites["berry_one"].visible && @sprites["berry_one"].y >= SCREEN_HEIGHT/2
      when 4
        # Draw
        draw_circle # Circle
        # Scale
        (0...@scale.size).each{|i| @sprites["circle"].zoom_x = @scale[i]
        @sprites["circle"].zoom_y = @scale[i]; pbWait(3)}
        @process = 5 if @sprites["circle"].zoom_x <= 1 && @sprites["circle"].zoom_y <= 1
      when 5
        # Annoucement
        annoucement
        @speed = 7
        # Draw
        draw_speed # Speed 
        @process = 6 if !@sprites["start"].visible
      when 6
        # Play
        play
        if @sprites["time"].x >= 188
          # Record after play
          record_symbol
          record_player_play
          @process = 7 
        end
      when 7
        disappear_2; disappear_one_2
        (1..2).each { |i| @sprites["effect#{i}"].visible = false }
        # Define
        define_infor
        # Draw Result
        draw_result
        draw_text_result_overlay
        @process = -1
      when -1
        @sprites["results"].y += 8
        if @sprites["results"].y >= 0
          @sprites["results"].y = 0
          pbWait(10)
          @process = 8 
        end
      when 8
        # Draw
        draw_results_symbol # Symbol of Perfect, Good, Miss
        draw_result_two # Result
        @process = 9 if Input.trigger?(Input::C)
      when 9
        # Clear symbol
        bitmap = @sprites["overlay_results_symbol"].bitmap
        bitmap.clear
        # Redraw
        redraw_result_two
        @process = 10 if Input.trigger?(Input::C)
      when 10
        @sprites["results"].visible = false
        # Clear result
        @sprites["overlay_results"].bitmap.clear
        # Flavor
        determine_color_two 
        if pbConfirmMessage("Would you like to blend another Berry?")
          @process = 11
        else
          @exit = true
        end
      when 11
        # clear
        dispose  
        # Redraw
        draw_scene
        # Set_again
        @berry = 0; @berryone = 0
        @perfect = 0; @good = 0; @miss = 0
        @perfectone = 0; @goodone = 0; @missone = 0
        @appear = 0
        @speed = 0; @maxspeed = 0
        @decrease = 0 
        @increase = 0 
        @circle = 0; @circletwo = 2
        @disappear = [[],[],[]]; @disappear_one = [[],[],[]]
        @getreward = false
        @process = 0
      end
    end
  end
#-------------------------------------------------------------------------------
  # Three players
  def three_players
    loop do
      @check_mode = 3
      # Update
      update_ingame
      break if @exit
      case @process
      when 0
        # Choose berry in your bag
        choice_berry
        @process = 1
      when 1
        if @berry > 0
          # Delete item
          $PokemonBag.pbDeleteItem(@berry,1)
          # Draw overlay
          draw_speed_overlay # Speed
          @process = 2
        else
          if pbConfirmMessage("Do you want to continue?")
            pbMessage(_INTL("Plese select Berry."))
            @process = 0
          else
            @exit = true
          end
        end
      when 2
        # Draw
        scene_three # 3 players (scene)
        # Berry
        draw_berry_one 
        draw_berry_two
        draw_berry_three
        draw_name_player # Name (Scene-All)
        name_player # Name of player
        name_one # Name of AI (1)
        name_two # Name of AI (2)
        draw_annoucement # Annoucement
        draw_effect # Effect
        draw_time_bar # Time
        @process = 3 
      when 3
        # Draw
        draw_speed # Speed
        # Annimation Berry
        annimation_berry_three
        @process = 4 if !@sprites["berry_two"].visible && @sprites["berry_two"].y <= SCREEN_HEIGHT/2
      when 4
        # Draw
        draw_circle # Circle
        # Scale
        (0...@scale.size).each{|i| @sprites["circle"].zoom_x = @scale[i]
        @sprites["circle"].zoom_y = @scale[i]; pbWait(3)}
        @process = 5 if @sprites["circle"].zoom_x <= 1 && @sprites["circle"].zoom_y <= 1
      when 5
        # Annoucement
        annoucement
        @speed = 7
        # Draw
        draw_speed # Speed 
        @process = 6 if !@sprites["start"].visible
      when 6
        # Play
        play
        if @sprites["time"].x >= 188
          # Record after play
          record_symbol
          record_player_play
          @process = 7 
        end
      when 7
        disappear_2; disappear_one_2; disappear_two_2
        (1..2).each { |i| @sprites["effect#{i}"].visible = false }
        # Define
        define_infor
        # Draw Result
        draw_result
        draw_text_result_overlay
        @process = -1
      when -1
        @sprites["results"].y += 8
        if @sprites["results"].y >= 0
          @sprites["results"].y = 0
          pbWait(10)
          @process = 8 
        end
      when 8
        # Draw
        draw_results_symbol # Symbol of Perfect, Good, Miss
        draw_result_three # Result
        @process = 9 if Input.trigger?(Input::C)
      when 9
        # Clear symbol
        bitmap = @sprites["overlay_results_symbol"].bitmap
        bitmap.clear
        # Redraw
        redraw_result_three
        @process = 10 if Input.trigger?(Input::C)
      when 10
        @sprites["results"].visible = false
        # Clear result
        @sprites["overlay_results"].bitmap.clear
        # Flavor
        determine_color_three 
        if pbConfirmMessage("Would you like to blend another Berry?")
          @process = 11
        else
          @exit = true
        end
      when 11
        # clear
        dispose  
        # redraw
        draw_scene
        # set_again
        @berry = 0; @berryone = 0; @berrytwo = 0
        @perfect = 0; @good = 0; @miss = 0
        @perfectone = 0; @goodone = 0; @missone = 0
        @perfecttwo = 0; @goodtwo = 0; @misstwo = 0
        @appear = 0
        @speed = 0; @maxspeed = 0
        @decrease = 0 
        @increase = 0 
        @circle = 0; @circletwo = 2
        @disappear = [[],[],[]]; @disappear_one = [[],[],[]]; @disappear_two = [[],[],[]]
        @getreward = false
        @process = 0
      end
    end
  end
#-------------------------------------------------------------------------------
  # Four players
  def four_players
    loop do
      @check_mode = 4
      # Update
      update_ingame
      break if @exit
      case @process
      when 0
        # Choose berry in your bag
        choice_berry
        @process = 1
      when 1
        if @berry > 0
          # Delete item
          $PokemonBag.pbDeleteItem(@berry,1)
          # Draw overlay
          draw_speed_overlay # Speed
          @process = 2
        else
          if pbConfirmMessage("Do you want to continue?")
            pbMessage(_INTL("Plese select Berry."))
            @process = 0
          else
            @exit = true
          end
        end
      when 2
        # Draw
        scene_four # 4 players (scene)
        # Berry
        draw_berry_one 
        draw_berry_two
        draw_berry_three
        draw_berry_four
        draw_name_player # Name (Scene-All)
        name_player # Name of player
        name_one # Name of AI (1)
        name_two # Name of AI (2)
        name_three # Name of AI (3)
        draw_annoucement # Annoucement
        draw_effect # Effect
        draw_time_bar # Time
        @process = 3
      when 3
        # Draw
        draw_speed # Speed
        # Annimation Berry
        annimation_berry_four
        @process = 4 if !@sprites["berry_three"].visible && @sprites["berry_three"].y <= SCREEN_HEIGHT/2
      when 4 
        # Draw
        draw_circle # Circle
        # Scale
        (0...@scale.size).each{|i| @sprites["circle"].zoom_x = @scale[i]
        @sprites["circle"].zoom_y = @scale[i]; pbWait(3)}
        @process = 5 if @sprites["circle"].zoom_x <= 1 && @sprites["circle"].zoom_y <= 1
      when 5
        # Annoucement
        annoucement
        @speed = 7
        # Draw
        draw_speed # Speed 
        @process = 6 if !@sprites["start"].visible
      when 6
        # Play
        play
        if @sprites["time"].x >= 188
          # Record after play
          record_symbol
          record_player_play
          @process = 7 
        end
      when 7
        disappear_2; disappear_one_2; disappear_two_2; disappear_three_2
        (1..2).each { |i| @sprites["effect#{i}"].visible = false }
        # Define
        define_infor
        # Draw Result
        draw_result
        draw_text_result_overlay
        @process = -1
      when -1
        @sprites["results"].y += 8
        if @sprites["results"].y >= 0
          @sprites["results"].y = 0
          pbWait(10)
          @process = 8 
        end
      when 8
        # Draw
        draw_results_symbol # Symbol of Perfect, Good, Miss
        draw_result_four # Result
        @process = 9 if Input.trigger?(Input::C)
      when 9
        # Clear symbol
        bitmap = @sprites["overlay_results_symbol"].bitmap
        bitmap.clear
        # Redraw
        redraw_result_four
        @process = 10 if Input.trigger?(Input::C)
      when 10
        @sprites["results"].visible = false
        # Clear result
        @sprites["overlay_results"].bitmap.clear
        # Flavor
        determine_color_four 
        if pbConfirmMessage("Would you like to blend another Berry?")
          @process = 11
        else
          @exit = true
        end
      when 11
        # clear
        dispose  
        # redraw
        draw_scene
        # set_again
        @berry = 0; @berryone = 0; @berrytwo = 0; @berrythree = 0
        @perfect = 0; @good = 0; @miss = 0
        @perfectone = 0; @goodone = 0; @missone = 0
        @perfecttwo = 0; @goodtwo = 0; @misstwo = 0
        @perfectthree = 0; @goodthree = 0; @missthree = 0
        @appear = 0
        @speed = 0; @maxspeed = 0
        @decrease = 0 
        @increase = 0 
        @circle = 0; @circletwo = 2
        @disappear = [[],[],[]]; @disappear_one = [[],[],[]]; @disappear_two = [[],[],[]]; @disappear_three = [[],[],[]]
        @getreward = false
        @process = 0
      end
    end
  end
#-------------------------------------------------------------------------------
  # Special player
  def special_player
    loop do
      @check_mode = 0
      # Update
      update_ingame
      break if @exit
      case @process
      when 0
        # Choose berry in your bag
        choice_berry
        @process = 1
      when 1
        if @berry > 0
          # Delete item
          $PokemonBag.pbDeleteItem(@berry,1)
          # Draw overlay
          draw_speed_overlay # Speed
          @process = 2
        else
          if pbConfirmMessage("Do you want to continue?")
            pbMessage(_INTL("Plese select Berry."))
            @process = 0
          else
            @exit = true
          end
        end
      when 2
        # Draw
        scene_two # 2 players (scene)
        # Berry
        draw_berry_one
        draw_berry_special 
        draw_name_player # Name (Scene-All)
        name_player # Name of player
        name_special # Name of AI (special-master)
        draw_annoucement # Annoucement
        draw_effect # Effect
        draw_time_bar # Time
        @process = 3 
      when 3
        # Draw
        draw_speed # Speed
        # Annimation Berry
        annimation_berry_special
        @process = 4 if !@sprites["berry_special"].visible && @sprites["berry_special"].y >= SCREEN_HEIGHT/2
      when 4
        # Draw
        draw_circle # Circle
        # Scale
        (0...@scale.size).each{|i| @sprites["circle"].zoom_x = @scale[i]
        @sprites["circle"].zoom_y = @scale[i]; pbWait(3)}
        @process = 5 if @sprites["circle"].zoom_x <= 1 && @sprites["circle"].zoom_y <= 1
      when 5
        # Annoucement
        annoucement
        @speed = 7
        # Draw
        draw_speed # Speed 
        @process = 6 if !@sprites["start"].visible
      when 6
        # Play
        play
        if @sprites["time"].x >= 188
          # Record after play
          record_symbol
          record_player_play
          @process = 7 
        end
      when 7
        disappear_2; disappear_one_2
        (1..2).each { |i| @sprites["effect#{i}"].visible = false }
        # Define
        define_infor
        # Draw Result
        draw_result
        draw_text_result_overlay
        @process = -1
      when -1
        @sprites["results"].y += 8
        if @sprites["results"].y >= 0
          @sprites["results"].y = 0
          pbWait(10)
          @process = 8 
        end
      when 8
        # Draw
        draw_results_symbol
        draw_result_special
        @process = 9 if Input.trigger?(Input::C)
      when 9
        # Clear symbol
        bitmap = @sprites["overlay_results_symbol"].bitmap
        bitmap.clear
        # Redraw
        redraw_result_special
        @process = 10 if Input.trigger?(Input::C)
      when 10
        @sprites["results"].visible = false
        # Clear result
        @sprites["overlay_results"].bitmap.clear
        # Flavor
        determine_color_special
        if Kernel.pbConfirmMessage("Would you like to blend another Berry?")
          @process = 11
        else
          @exit = true
        end
      when 11
        # clear
        dispose  
        # redraw
        draw_scene
        # set_again
        @berry = 0; @berryspecial = 0
        @perfect = 0; @good = 0; @miss = 0
        @perfectone = 0; @goodone = 0; @missone = 0
        @appear = 0
        @speed = 0; @maxspeed = 0
        @decrease = 0 
        @increase = 0 
        @circle = 0; @circletwo = 2
        @disappear = [[],[],[]]; @disappear_one = [[],[],[]]
        @process = 0
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Draw scene
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_scene
    # Behind scene
    @sprites["behind"] = Sprite.new(@viewport1)
    @sprites["behind"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Behind")
    # Scene begin
    @sprites["scene"] = Sprite.new(@viewport)
    @sprites["scene"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Scene")
  end
  
  def draw_time_bar
    @sprites["time"] = Sprite.new(@viewport1)
    @sprites["time"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Time")
    @sprites["time"].x = 52
    @sprites["time"].y = 5
  end
  
  def draw_speed_overlay
    @sprites["overlay_speed"] = Sprite.new(@viewport1)
    @sprites["overlay_speed"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_speed"].bitmap.clear
  end
  
  def draw_text_result_overlay
    @sprites["overlay_results_symbol"] = Sprite.new(@viewport2)
    @sprites["overlay_results_symbol"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_results_symbol"].bitmap.clear
    
    @sprites["overlay_results"] = Sprite.new(@viewport2)
    @sprites["overlay_results"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_results"].bitmap.clear
  end
  
  def draw_result
    @sprites["results"] = Sprite.new(@viewport2)
    @sprites["results"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Results")
    @sprites["results"].y = -SCREEN_HEIGHT
  end
#-------------------------------------------------------------------------------
  def draw_effect
    (1..2).each { |i|
      @sprites["effect#{i}"] = Sprite.new(@viewport)
      @sprites["effect#{i}"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Effect_#{i}")
      @sprites["effect#{i}"].visible = false }
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_annoucement
    # Draw number
    (1..3).each { |i|
    @sprites["#{i}"] = Sprite.new(@viewport2)
    @sprites["#{i}"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/#{i}")
    @sprites["#{i}"].x = 232
    @sprites["#{i}"].y = 162
    @sprites["#{i}"].visible = false }
    # Draw Start
    @sprites["start"] = Sprite.new(@viewport2)
    @sprites["start"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Start")
    @sprites["start"].x = 192
    @sprites["start"].y = 167
    @sprites["start"].visible = false
  end
  
  # Annoucement
  def annoucement
    (1..3).each{|i| pbSEPlay('Berry Blender Countdown',100,100) 
    @sprites["#{i}"].visible = true; pbWait(20)
    @sprites["#{i}"].visible = false; pbWait(20)}
    pbSEPlay('Berry Blender Start',100,100)
    @sprites["start"].visible = true
    pbWait(20)
    @sprites["start"].visible = false
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_circle(x=256,y=192)
    @sprites["circle"] = Sprite.new(@viewport)
    @sprites["circle"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/Circle")
    @sprites["circle"].ox = @sprites["circle"].bitmap.width/2
    @sprites["circle"].oy = @sprites["circle"].bitmap.height/2
    @sprites["circle"].x = x
    @sprites["circle"].y = y
    @sprites["circle"].zoom_x = 5
    @sprites["circle"].zoom_y = 5
  end

  def draw_speed
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["overlay_speed"].bitmap
    bitmap.clear
    textposition = []
    textposition.push([_INTL("{1}",@speed),300,321,1,basecolor,shadowcolor])
    bitmap.font.size = 28
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textposition)
  end
  
  def effect
    (1..2).each{|i| @sprites["effect#{i}"].visible = true
    @sprites["effect#{i}"].x = rand(SCREEN_WIDTH); @sprites["effect#{i}"].y = rand(SCREEN_HEIGHT)}
  end
#-------------------------------------------------------------------------------
  def draw_results_symbol
    namegraphic = ["Perfect","Good","Miss"]
    bitmap = @sprites["overlay_results_symbol"].bitmap
    bitmap.clear
    imgpos = []
    (0...namegraphic.size).each {|i|
    imgpos.push(["Graphics/Pictures/BerryBlender/"+ namegraphic[i],240+80*i,90,0,0,-1,-1])}
    pbDrawImagePositions(bitmap,imgpos)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Name player
#
#-------------------------------------------------------------------------------
  # Create draw
  def draw_name_player
    @sprites["name_player"] = Sprite.new(@viewport1)
    @sprites["name_player"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["name_player"].bitmap.clear
  end
  
  def name_player(x=12,y=117)
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["name_player"].bitmap
    textpos = [[_INTL("{1}",$Trainer.name),x,y,0,basecolor,shadowcolor]]
    bitmap.font.size = 30
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textpos)
  end
  
  def name_one(x=371,y=117)
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["name_player"].bitmap
    textpos = [[_INTL("{1}",@nameplayerone),x,y,0,basecolor,shadowcolor]]
    bitmap.font.size = 30
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textpos)
  end
  
  def name_two(x=12,y=233)
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["name_player"].bitmap
    textpos = [[_INTL("{1}",@nameplayertwo),x,y,0,basecolor,shadowcolor]]
    bitmap.font.size = 30
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textpos)
  end
  
  def name_three(x=371,y=233)
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["name_player"].bitmap
    textposition = []
    textposition.push([_INTL("{1}",@nameplayerthree),x,y,0,basecolor,shadowcolor])
    bitmap.font.size = 30
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textposition)
  end
  
  def name_special(x=371,y=117)
    basecolor = Color.new(84,253,140)
    shadowcolor = Color.new(96,201,131)
    bitmap = @sprites["name_player"].bitmap
    textposition = []
    textposition.push([_INTL("{1}",@nameplayerspecial),x,y,0,basecolor,shadowcolor])
    bitmap.font.size = 30
    bitmap.font.name = "Arial"
    pbDrawTextPositions(bitmap,textposition)
  end
#-------------------------------------------------------------------------------
#
# Scene
#
#-------------------------------------------------------------------------------
  def scene_one
    @sprites["scene_one_player"] = Sprite.new(@viewport)
    @sprites["scene_one_player"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/OnePlayer")
  end
  
  def scene_two
    @sprites["scene_two_players"] = Sprite.new(@viewport)
    @sprites["scene_two_players"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/TwoPlayers")
  end
  
  def scene_three
    @sprites["scene_three_players"] = Sprite.new(@viewport)
    @sprites["scene_three_players"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/ThreePlayers")
  end
  
  def scene_four
    @sprites["scene_four_players"] = Sprite.new(@viewport)
    @sprites["scene_four_players"].bitmap = Bitmap.new("Graphics/Pictures/BerryBlender/FourPlayers")
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Berry
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Player choose berry
  def choice_berry
    pbFadeOutIn(99999){
    scene = PokemonBag_Scene.new
    screen = PokemonBagScreen.new(scene,$PokemonBag)
    @berry = screen.pbChooseItemScreen(Proc.new{|item| pbIsBerry?(item)})}
  end
  
  # Draw berry
  def draw_berry_one
    filename = sprintf("%s",getConstantName(PBItems,@berry)) rescue nil
    filename = sprintf("item%03d",@berry) if !pbResolveBitmap("Graphics/Icons/#{filename}")
    @sprites["berry"] = Sprite.new(@viewport)
    @sprites["berry"].bitmap = Bitmap.new("Graphics/Icons/#{filename}")
    @sprites["berry"].ox = @sprites["berry"].bitmap.width/2
    @sprites["berry"].oy = @sprites["berry"].bitmap.height/2
  end
  
  def draw_berry_two
    berryrandom = rand(@determine_berries.length)
    @berryone = @determine_berries[berryrandom]
    filename = sprintf("%s",getConstantName(PBItems,@berryone)) rescue nil
    filename = sprintf("item%03d",@berryone) if !pbResolveBitmap("Graphics/Icons/#{filename}")
    @sprites["berry_one"] = Sprite.new(@viewport)
    @sprites["berry_one"].bitmap = Bitmap.new("Graphics/Icons/#{filename}")
    @sprites["berry_one"].x = SCREEN_WIDTH
    @sprites["berry_one"].y = 0
    @sprites["berry_one"].ox = @sprites["berry_one"].bitmap.width/2
    @sprites["berry_one"].oy = @sprites["berry_one"].bitmap.height/2
    @sprites["berry_one"].visible = false
  end
  
  def draw_berry_three
    berryrandom = rand(@determine_berries.length)
    @berrytwo = @determine_berries[berryrandom]
    filename = sprintf("%s",getConstantName(PBItems,@berrytwo)) rescue nil
    filename = sprintf("item%03d",@berrytwo) if !pbResolveBitmap("Graphics/Icons/#{filename}")
    @sprites["berry_two"] = Sprite.new(@viewport)
    @sprites["berry_two"].bitmap = Bitmap.new("Graphics/Icons/#{filename}")
    @sprites["berry_two"].x = 0
    @sprites["berry_two"].y = SCREEN_HEIGHT
    @sprites["berry_two"].ox = @sprites["berry_two"].bitmap.width/2
    @sprites["berry_two"].oy = @sprites["berry_two"].bitmap.height/2
    @sprites["berry_two"].visible = false
  end

  def draw_berry_four
    berryrandom = rand(@determine_berries.length)
    @berrythree = @determine_berries[berryrandom]
    filename = sprintf("%s",getConstantName(PBItems,@berrythree)) rescue nil
    filename = sprintf("item%03d",@berrythree) if !pbResolveBitmap("Graphics/Icons/#{filename}")
    @sprites["berry_three"] = Sprite.new(@viewport)
    @sprites["berry_three"].bitmap = Bitmap.new("Graphics/Icons/#{filename}")
    @sprites["berry_three"].x = SCREEN_WIDTH
    @sprites["berry_three"].y = SCREEN_HEIGHT
    @sprites["berry_three"].ox = @sprites["berry_three"].bitmap.width/2
    @sprites["berry_three"].oy = @sprites["berry_three"].bitmap.height/2
    @sprites["berry_three"].visible = false
  end
  
  def draw_berry_special
    berryrandom = rand(BERRIES_SPECIAL.length)
    (1..PBItems.maxValue).each {|i| @berryspecial = i if PBItems.getName(i) == BERRIES_SPECIAL[berryrandom] && pbIsBerry?(i)}
    filename = sprintf("item%03d",@berryspecial)
    @sprites["berry_special"] = Sprite.new(@viewport)
    @sprites["berry_special"].bitmap = Bitmap.new("Graphics/Icons/#{filename}")
    @sprites["berry_special"].x = SCREEN_WIDTH
    @sprites["berry_special"].y = 0
    @sprites["berry_special"].ox = @sprites["berry_special"].bitmap.width/2
    @sprites["berry_special"].oy = @sprites["berry_special"].bitmap.height/2
    @sprites["berry_special"].visible = false
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Animation
  def animation_berry(spritename="",xcor=0,ycor=0,xcon=false,ycon=false)
    xcor2 = SCREEN_WIDTH/2; ycor2 = SCREEN_HEIGHT/2
    dis = Math.sqrt((xcor2-xcor)**2 + (ycor2-ycor)**2)
    disr = Math.sqrt((xcor2-@sprites["#{spritename}"].x)**2 + (ycor2-@sprites["#{spritename}"].y)**2)
    if !xcon
      @sprites["#{spritename}"].x += 2
    else
      @sprites["#{spritename}"].x -= 2
    end
    if !ycon
      if @sprites["#{spritename}"].y < ycor2
        # Circle 1
        if disr < (1/4*dis)
          @sprites["#{spritename}"].y += 0.5
        elsif disr >= (1/4*dis) && disr < (1/2*dis)
          @sprites["#{spritename}"].y += 2.1
        # Circle 2
        elsif disr >= (1/2*dis) && disr < (2/3*dis)
          @sprites["#{spritename}"].y += 0.75
        elsif disr >= (2/3*dis) && disr < (5/6*dis)
          @sprites["#{spritename}"].y += 1.85
        # Circle 3
        elsif disr >= (5/6*dis) && disr < (11/12*dis)
          @sprites["#{spritename}"].y += 0.5
        elsif disr >= (11/12*dis) && disr < dis
          @sprites["#{spritename}"].y += 1.6
        end
      else
        @sprites["#{spritename}"].visible = false
      end
    else
      if @sprites["#{spritename}"].y > ycor2
        # Circle 1
        if disr < (1/4*dis)
          @sprites["#{spritename}"].y -= 0.5
        elsif disr >= (1/4*dis) && disr < (1/2*dis)
          @sprites["#{spritename}"].y -= 2.1
        # Circle 2
        elsif disr >= (1/2*dis) && disr < (2/3*dis)
          @sprites["#{spritename}"].y -= 0.75
        elsif disr >= (2/3*dis) && disr < (5/6*dis)
          @sprites["#{spritename}"].y -= 1.85
        # Circle 3
        elsif disr >= (5/6*dis) && disr < (11/12*dis)
          @sprites["#{spritename}"].y -= 0.5
        elsif disr >= (11/12*dis) && disr < dis
          @sprites["#{spritename}"].y -= 1.6
        end
      else
        @sprites["#{spritename}"].visible = false
      end
    end
    @sprites["#{spritename}"].angle += 8
  end
#-------------------------------------------------------------------------------
  def annimation_berry_one; animation_berry("berry"); end
  
  def annimation_berry_two
    animation_berry("berry")
    if !@sprites["berry"].visible
      @sprites["berry_one"].visible = true
      animation_berry("berry_one",SCREEN_WIDTH,0,true) 
    end
  end
  
  def annimation_berry_three
    animation_berry("berry")
    if !@sprites["berry"].visible
      @sprites["berry_one"].visible = true
      animation_berry("berry_one",SCREEN_WIDTH,0,true) 
      if !@sprites["berry_one"].visible
        @sprites["berry_two"].visible = true
        animation_berry("berry_two",0,SCREEN_HEIGHT,false,true)  
      end
    end
  end
  
  def annimation_berry_four
    animation_berry("berry")
    if !@sprites["berry"].visible
      @sprites["berry_one"].visible = true
      animation_berry("berry_one",SCREEN_WIDTH,0,true) 
      if !@sprites["berry_one"].visible
        @sprites["berry_two"].visible = true
        animation_berry("berry_two",0,SCREEN_HEIGHT,false,true)  
        if !@sprites["berry_two"].visible
          @sprites["berry_three"].visible = true
          animation_berry("berry_three",SCREEN_WIDTH,SCREEN_HEIGHT,true,true)  
        end
      end
    end
  end
  
  def annimation_berry_special
    animation_berry("berry")
    if !@sprites["berry"].visible
      @sprites["berry_special"].visible = true
      animation_berry("berry_special",SCREEN_WIDTH,0,true)  
    end
  end

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#
# Draw result
#
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # One player
  def draw_result_one
    # Color
    bcolor = Color.new(191,25,25)
    scolor = Color.new(125,58,58)
    bitmap = @sprites["overlay_results"].bitmap
    bitmap.clear
    # Text
    txtpos = []
    txtpos.push([_INTL("1. {1}",$Trainer.name),6,152,0,bcolor,scolor])
    (0..2).each { |i| 
    txtpos.push([_INTL("{1}",@qsym[i]),230+86*i,152,0,bcolor,scolor])} 
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,txtpos)
  end
#-------------------------------------------------------------------------------
  def redraw_result_one
    # Color
    bcolor = Color.new(191,25,25)
    scolor = Color.new(125,58,58)
    bitmap = @sprites["overlay_results"].bitmap
    bitmap.clear
    # Text
    txtpos = []
    txtpos.push([_INTL("1. {1}",$Trainer.name),6,152,0,bcolor,scolor],
     [_INTL("{1}",PBItems.getName(@berry)),240,152,0,bcolor,scolor],
     [_INTL("Max speed: {1}",@maxspeed),170,92,0,bcolor,scolor])
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,txtpos)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_for_first_result(number)
    # Color
    bcolor = Color.new(191,25,25)
    scolor = Color.new(125,58,58)
    bitmap = @sprites["overlay_results"].bitmap
    bitmap.clear
    # Text
    txtpos = []
    (0...number).each { |i| txtpos.push([_INTL("{1}. {2}",@rank[i],@note[i]),6,152+32*i,0,bcolor,scolor])}
    (0...number).each { |i| (0..2).each { |j| txtpos.push([_INTL("{1}",@note2[i][j]),230+86*j,152+32*i,0,bcolor,scolor])}}
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,txtpos)
  end
  
  def draw_for_second_result(number)
    # Color
    bcolor = Color.new(191,25,25)
    scolor = Color.new(125,58,58)
    bitmap = @sprites["overlay_results"].bitmap
    bitmap.clear
    # Text
    txtpos = []
    txtpos.push([_INTL("Max speed: {1}",@maxspeed),170,92,0,bcolor,scolor])
    (0...number).each { |i| txtpos.push(
      [_INTL("{1}. {2}",@rank[i],@note[i]),6,152+32*i,0,bcolor,scolor],
      [_INTL("{1}",@note3[i]),240,152+32*i,0,bcolor,scolor])}
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,txtpos)
  end
#-------------------------------------------------------------------------------
  # Two players
  def draw_result_two
    draw_for_first_result(2)
  end
#-------------------------------------------------------------------------------
  def redraw_result_two
    draw_for_second_result(2)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Three players
  def draw_result_three
    draw_for_first_result(3)
  end
#-------------------------------------------------------------------------------
  def redraw_result_three
    draw_for_second_result(3)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Four players
  def draw_result_four
    draw_for_first_result(4)
  end
#-------------------------------------------------------------------------------
  def redraw_result_four
    draw_for_second_result(4)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Special player
  def draw_result_special
    draw_for_first_result(2)
  end
#-------------------------------------------------------------------------------
  def redraw_result_special
    draw_for_second_result(2)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Record
#
#-------------------------------------------------------------------------------
  def record_symbol
    @qsym = [@perfect,@good,@miss]
    if @check_mode == 2 || @check_mode == 0
      @qsym2 = [@perfectone,@goodone,@missone]
    elsif @check_mode == 3
      @qsym2 = [@perfectone,@goodone,@missone]
      @qsym3 = [@perfecttwo,@goodtwo,@misstwo]
    elsif @check_mode == 4
      @qsym2 = [@perfectone,@goodone,@missone]
      @qsym3 = [@perfecttwo,@goodtwo,@misstwo]
      @qsym4 = [@perfectthree,@goodthree,@missthree]
    end
  end
  
  def record_player_play
    # Record symbol, name, berry
    @recp = [@qsym,$Trainer.name,PBItems.getName(@berry)]
    case @check_mode
    when 2
      @recp2 = [@qsym2,@nameplayerone,PBItems.getName(@berryone)]
      # Record all
      @recall = [@recp,@recp2]
    when 3
      @recp2 = [@qsym2,@nameplayerone,PBItems.getName(@berryone)]
      @recp3 = [@qsym3,@nameplayertwo,PBItems.getName(@berrytwo)]
      # Record all
      @recall = [@recp,@recp2,@recp3]
    when 4
      @recp2 = [@qsym2,@nameplayerone,PBItems.getName(@berryone)]
      @recp3 = [@qsym3,@nameplayertwo,PBItems.getName(@berrytwo)]
      @recp4 = [@qsym4,@nameplayerthree,PBItems.getName(@berrythree)]
      # Record all
      @recall = [@recp,@recp2,@recp3,@recp4]
    when 0
      @recp2 = [@qsym2,@nameplayerspecial,PBItems.getName(@berryspecial)]
      # Record all
      @recall = [@recp,@recp2]
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Define rank
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def define_infor
    # Marked
    marked = []; marked_a = []
    # Set score
    score = []
    (0...@recall.size).each{|i| score.push(200*@recall[i][0][0]+10*@recall[i][0][1]-@recall[i][0][2]) 
    @note.push(0); @note2.push(0); @note3.push(0); marked.push(false); marked_a.push(false) }
    score_s = score.sort.reverse
    # Set rank
    @rank = [1]
    (1...@recall.size).each{|i| @rank.push(0)}
    (1...score_s.size).each{|i| @rank[i] = (score_s[i] == score_s[i-1]) ? @rank[i-1] : @rank[i-1]+1 }
    # Set name,etc
    (0...@recall.size).each{|i| (0...@recall.size).each{|j|
    if score_s[i] == score[j] && !marked[i] 
      if !marked_a[j]
        @note[i]  = @recall[j][1] # Name of players
        @note2[i] = @recall[j][0] # Quantity (3 numbers)
        @note3[i] = @recall[j][2] # Name of berry
        marked[i] = true
        marked_a[j] = true
      end
    end }}
    @getreward = false if @rank.first!=@rank[1] && @note.first == $Trainer.name
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Play
#-------------------------------------------------------------------------------
  def play
    # Disappear
    dis_p_g_m
    # Reset angle
    @sprites["circle"].angle = 0 if @sprites["circle"].angle == 360
    # Effect
    @appear += 1
    if @appear == 1
      (1..2).each { |i| @sprites["effect#{i}"].visible = false }
      @appear = 0
    end
    # Set circle
    @circletwo = 0 if @circletwo == 2
    if @circle == 2
      @circletwo += 1
      @circle = 0
    end
    @circle += 1
    # Calc speed
    if @speed <= 20
      if @circletwo==2
        @sprites["circle"].angle += 10 
        # AI play
        deter_circ
      end
    elsif @speed <= 40 && @speed > 20
      if @circle==2
        @sprites["circle"].angle += 10 
        # AI play
        deter_circ
      end
    elsif @speed < 200 && @speed > 40
      @sprites["circle"].angle += 10
      # AI play
      deter_circ
    end
    # Player (play)
    some_informations_play 
    if @increase >= 3
      @increase = 0
      @sprites["time"].x += 22 
      # Next
      @sprites["time"].x = 188 if @sprites["time"].x >= 188
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def deter_circ
    if @check_mode == 0
      determine_special
    elsif @check_mode == 2
      determine_circle_320
    elsif @check_mode == 3
      determine_circle_140
      determine_circle_320
    elsif @check_mode == 4
      determine_circle_140
      determine_circle_220
      determine_circle_320
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def dis_p_g_m
    # Disappear Perfect, Good, Miss (player)
    disappear
    if @check_mode == 0 || @check_mode == 2 
      disappear_one
    elsif @check_mode == 3
      disappear_two
      disappear_one
    elsif @check_mode == 4
      disappear_two
      disappear_three
      disappear_one
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Determine score
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def change_speed(number=[15,12,8,5,3],nega=false)
    if !nega
      if @speed <= 20
        @speed += number[0]
      elsif @speed <= 40 && @speed > 20
        @speed += number[1]
      elsif @speed <= 60 && @speed > 40
        @speed += number[2]
      elsif @speed <= 80 && @speed > 60
        @speed += number[3]
      elsif @speed <= 105 && @speed > 80
        @speed += number[4]
      end
    else
      if @speed <= 20
        @speed -= number[0]
      elsif @speed <= 40 && @speed > 20
        @speed -= number[1]
      elsif @speed <= 60 && @speed > 40
        @speed -= number[2]
      elsif @speed <= 80 && @speed > 60
        @speed -= number[3]
      elsif @speed <= 105 && @speed > 80
        @speed -= number[4]
      end
    end
  end
#-------------------------------------------------------------------------------
  def some_informations_play
    if Input.trigger?(Input::C)
      # Draw effect
      effect
      if @sprites["circle"].angle == 40
        @perfect += 1
        # Draw graphic
        draw_perfect
        # Change
        change_speed
        # Draw speed
        draw_speed
        @increase += 1
      elsif @sprites["circle"].angle == 50|| @sprites["circle"].angle == 30
        @good += 1
        # Draw graphic
        draw_good
        # Change
        change_speed([12,10,6,3,1])
        # Draw speed
        draw_speed
        @increase += 1
      else
        @miss += 1
        # Draw graphic
        draw_miss
        # Change
        change_speed(number=[1,3,5,7,10],true)
        # Draw speed
        draw_speed
      end
    end
    # Set decrease speed
    @decrease += 1
    if @decrease == 100
      @decrease = 0
      @speed -= 1
      # Draw speed
      draw_speed
    end
    # Set max value
    if @speed >= 105
      @speed = 105
      # Draw value
      draw_speed
    # Set min value
    elsif @speed <= 7
      @speed = 7 
      # Draw value
      draw_speed
    end
    @maxspeed = @speed if @speed > @maxspeed
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Determine score (AI)
#
#-------------------------------------------------------------------------------
  def determine_circle_320
    if @sprites["circle"].angle == 320
      random = rand(4)
      # Draw effect
      effect
      case random
      when 0
        @perfectone += 1
        # Draw Perfect
        draw_perfect_one
        pbSEPlay('Berry Blender Perfect',100,100)
        # Change
        change_speed
        # Draw Speed
        draw_speed
        @increase += 1
      when 1
        @goodone += 1
        # Draw Good
        draw_good_one
        pbSEPlay('Berry Blender Good',100,100)
        # Change
        change_speed([12,10,6,3,1])
        # Draw Speed
        draw_speed
        @increase += 1
      when 2
        @missone += 1
        # Draw Miss
        draw_miss_one
        pbSEPlay('Berry Blender Miss',100,100)
        # Change
        change_speed([1,3,5,7,10],true)
        # Draw Speed
        draw_speed
      end
    end
  end
#-------------------------------------------------------------------------------
  def determine_circle_140
    if @sprites["circle"].angle == 140
      random = rand(4)
      # Draw effect
      effect
      case random
      when 0
        @perfecttwo += 1
        # Draw Perfect
        draw_perfect_two
        pbSEPlay('Berry Blender Perfect',100,100)
        # Change
        change_speed
        # Draw Speed
        draw_speed
        @increase += 1
      when 1
        @goodtwo += 1
        # Draw Good
        draw_good_two
        pbSEPlay('Berry Blender Good',100,100)
        # Change
        change_speed([12,10,6,3,1])
        # Draw Speed
        draw_speed
        @increase += 1
      when 2
        @misstwo += 1
        # Draw Miss
        draw_miss_two
        pbSEPlay('Berry Blender Miss',100,100)
        # Change
        change_speed([1,3,5,7,10],true)
        # Draw Speed
        draw_speed
      end
    end
  end
#-------------------------------------------------------------------------------
  def determine_circle_220
    if @sprites["circle"].angle == 220
      random = rand(4)
      # Draw effect
      effect
      case random
      when 0
        @perfectthree += 1
        # Draw Perfect
        draw_perfect_three
        pbSEPlay('Berry Blender Perfect',100,100)
        # Change
        change_speed
        # Draw Speed
        draw_speed
        @increase += 1
      when 1
        @goodthree += 1
        # Draw Good
        draw_good_three
        pbSEPlay('Berry Blender Good',100,100)
        # Change
        change_speed([12,10,6,3,1])
        # Draw Speed
        draw_speed
        @increase += 1
      when 2
        @missthree += 1
        # Draw Miss
        draw_miss_three
        pbSEPlay('Berry Blender Miss',100,100)
        # Change
        change_speed([1,3,5,7,10],true)
        # Draw Speed
        draw_speed
      end
    end
  end
#-------------------------------------------------------------------------------
  def determine_special
    if @sprites["circle"].angle == 320
      # Draw effect
      effect
      @perfectone += 1
      # Draw Perfect
      draw_perfect_one
      pbSEPlay('Berry Blender Perfect',100,100)
      # Change
      change_speed
      # Draw speed
      draw_speed
      @increase += 1
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Perfect, good, miss
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_icon_play(sprite,filename,mus=nil,xsprite=171,ysprite=96)
    if !@sprites[sprite]
      @sprites[sprite] = IconSprite.new(0,0,@viewport)
      pbSEPlay(mus,100,100) if mus!=nil
      @sprites[sprite].setBitmap("Graphics/Pictures/BerryBlender/#{filename}")
      @sprites[sprite].x = xsprite
      @sprites[sprite].y = ysprite
    end
  end
  
  def disappear_icon(limit,name,condition)
    (0..limit).each{|i| 
    if @sprites[name+"#{i}"]
      condition.push(0) if condition[i-1].nil?
      condition[i-1] += 1
      pbDisposeSprite(@sprites,name+"#{i}") if condition[i-1] >= 4
    end }
  end
  
  def visible_f_icon_play(limit,sprite,limit1,sprite1,limit2,sprite2)
    (0..limit).each{|i| @sprites[sprite+"#{i}"].visible = false if @sprites[sprite+"#{i}"]}
    (0..limit1).each{|i| @sprites[sprite1+"#{i}"].visible = false if @sprites[sprite1+"#{i}"]}
    (0..limit2).each{|i| @sprites[sprite2+"#{i}"].visible = false if @sprites[sprite2+"#{i}"]}
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Player
  def draw_perfect; draw_icon_play("P_#{@perfect}","Perfect","Berry Blender Perfect"); end
  def draw_good; draw_icon_play("G_#{@good}","Good","Berry Blender Good"); end
  def draw_miss; draw_icon_play("M_#{@miss}","Miss","Berry Blender Miss"); end
#-------------------------------------------------------------------------------
  def disappear
    disappear_icon(@perfect,"P_",@disappear[0])
    disappear_icon(@good,"G_",@disappear[1])
    disappear_icon(@miss,"M_",@disappear[2])
  end
  
  def disappear_2; visible_f_icon_play(@perfect,"P_",@good,"G_",@miss,"M_"); end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # One
  def draw_perfect_one
    draw_icon_play("P1_#{@perfectone}","Perfect","Berry Blender Perfect",309,96)
  end
  
  def draw_good_one
    draw_icon_play("G1_#{@goodone}","Good","Berry Blender Good",309,96)
  end
  
  def draw_miss_one
    draw_icon_play("M1_#{@missone}","Miss","Berry Blender Miss",309,96)
  end
#-------------------------------------------------------------------------------
  def disappear_one
    disappear_icon(@perfectone,"P1_",@disappear_one[0])
    disappear_icon(@goodone,"G1_",@disappear_one[1])
    disappear_icon(@missone,"M1_",@disappear_one[2])
  end
  
  def disappear_one_2; visible_f_icon_play(@perfectone,"P1_",@goodone,"G1_",@missone,"M1_"); end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Two
  def draw_perfect_two
    draw_icon_play("P2_#{@perfecttwo}","Perfect","Berry Blender Perfect",172,258)
  end
  
  def draw_good_two
    draw_icon_play("G2_#{@goodtwo}","Good","Berry Blender Good",172,258)
  end
  
  def draw_miss_two
    draw_icon_play("M2_#{@misstwo}","Miss","Berry Blender Miss",172,258)
  end
#-------------------------------------------------------------------------------
  def disappear_two
    disappear_icon(@perfecttwo,"P2_",@disappear_two[0])
    disappear_icon(@goodtwo,"G2_",@disappear_two[1])
    disappear_icon(@misstwo,"M2_",@disappear_two[2])
  end
  
  def disappear_two_2; visible_f_icon_play(@perfecttwo,"P2_",@goodtwo,"G2_",@misstwo,"M2_"); end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Three
  def draw_perfect_three
    draw_icon_play("P3_#{@perfectthree}","Perfect","Berry Blender Perfect",310,258)
  end
  
  def draw_good_three
    draw_icon_play("G3_#{@goodthree}","Good","Berry Blender Good",310,258)
  end
  
  def draw_miss_three
    draw_icon_play("M3_#{@missthree}","Miss","Berry Blender Miss",310,258)
  end
#-------------------------------------------------------------------------------
  def disappear_three
    disappear_icon(@perfectthree,"P3_",@disappear_three[0])
    disappear_icon(@goodthree,"G3_",@disappear_three[1])
    disappear_icon(@missthree,"M3_",@disappear_three[2])
  end
  
  def disappear_three_2; visible_f_icon_play(@perfectthree,"P3_",@goodthree,"G3_",@missthree,"M3_"); end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Determine color
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # One player
  def determine_color_one
    (0...@determine_berries.length).each { |i| @flavorplayer = i if @determine_berries[i] == @berry }
    @flavor = FLAVOR[@flavorplayer]
    (0..4).each { |i| if @flavor[i] <= 0; @flavor[i] = -1; else; @flavor[i] = 1; end}
    # Set flavor
    flavor_color
  end
#-------------------------------------------------------------------------------
  # Two players
  def determine_color_two
    (0...@determine_berries.length).each { |i| 
    @flavorplayer = i if @determine_berries[i] == @berry 
    @flavorplayerone = i if @determine_berries[i] == @berryone }
    @flavor = []
    (0..4).each { |i| 
    f = (FLAVOR[@flavorplayer][i] + FLAVOR[@flavorplayerone][i])*10 - 2
    if f <= 0; f = -1; else; f = 1; end; @flavor.push(f)}
    # Set flavor
    flavor_color
  end
#-------------------------------------------------------------------------------
  # Three players
  def determine_color_three
    (0...@determine_berries.length).each { |i| 
    @flavorplayer = i if @determine_berries[i] == @berry 
    @flavorplayerone = i if @determine_berries[i] == @berryone 
    @flavorplayertwo = i if @determine_berries[i] == @berrytwo }
    @flavor = []
    (0..4).each { |i| 
    f = (FLAVOR[@flavorplayer][i] + FLAVOR[@flavorplayerone][i] + FLAVOR[@flavorplayertwo][i])*10 - 2
    if f <= 0; f = -1; else; f = 1; end; @flavor.push(f)}
    # Set flavor
    flavor_color
  end
#-------------------------------------------------------------------------------
  # Four players
  def determine_color_four
    (0...@determine_berries.length).each { |i| 
    @flavorplayer = i if @determine_berries[i] == @berry 
    @flavorplayerone = i if @determine_berries[i] == @berryone 
    @flavorplayertwo = i if @determine_berries[i] == @berrytwo
    @flavorplayerthree = i if @determine_berries[i] == @berrythree }
    @flavor = []
    (0..4).each { |i| 
    f = (FLAVOR[@flavorplayer][i] + FLAVOR[@flavorplayerone][i] + FLAVOR[@flavorplayertwo][i] + FLAVOR[@flavorplayerthree][i])*10 - 2
    if f <= 0; f = -1; else; f = 1; end; @flavor.push(f)}
    # Set flavor
    flavor_color
  end
#-------------------------------------------------------------------------------
  # Special player
  def determine_color_special
    (0...@determine_berries.length).each { |i| 
    @flavorplayer = i if @determine_berries[i] == @berry 
    @flavorplayerspecial = i if @determine_berries[i] == @berryspecial }
    @flavor = []
    (0..4).each { |i| 
    f = (FLAVOR[@flavorplayer][i] + FLAVOR[@flavorplayerspecial][i])*10 - 2
    if f <= 0; f = -1; else; f = 1; end; @flavor.push(f)}
    # Set flavor
    flavor_color
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def flavor_color
    # Check same berry
    case @check_mode
    when 0: check = (@berry == @berryspecial) ? true : false
    when 1: check = false
    when 2: check = (@berry == @berryone) ? true : false
    when 3: check = (@berry == @berryone || @berry == @berrytwo || @berryone == @berrytwo) ? true : false
    when 4: check = (@berry == @berryone || @berry == @berrytwo || @berry == @berrythree || 
            @berryone == @berrytwo || @berryone == @berrythree || @berrytwo == @berrythree) ? true : false
    end
    # Create flavor
    # Black
    if @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] <= 0 || check
      # Add
      add_color_savour(1,0)
      pbMessage(_INTL("Black Pokeblock was made."))
    # White
    elsif @flavor[0] > 0 && @flavor[1] > 0 && @flavor[2] > 0 && @flavor[3] > 0 && @flavor[4] <= 0 || 
      @flavor[0] <= 0 && @flavor[1] > 0 && @flavor[2] > 0 && @flavor[3] > 0 && @flavor[4] > 0 || 
      @flavor[0] > 0 && @flavor[1] <= 0 && @flavor[2] > 0 && @flavor[3] > 0 && @flavor[4] > 0 ||
      @flavor[0] > 0 && @flavor[1] > 0 && @flavor[2] <= 0 && @flavor[3] > 0 && @flavor[4] > 0 ||
      @flavor[0] > 0 && @flavor[1] > 0 && @flavor[2] > 0 && @flavor[3] <= 0 && @flavor[4] > 0
      if @maxspeed <= 100
        # Add
        add_color_savour(3,0)
        pbMessage(_INTL("White Pokeblock - Level 1 was made."))
      else
        # Add
        add_color_savour(3,1)
        pbMessage(_INTL("White Pokeblock - Level 2 was made."))
      end
    # Red + Gold
    elsif @flavor[0] > 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(4,1)
        pbMessage(_INTL("Red Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(4,0)
        pbMessage(_INTL("Red Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,0)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 1 was made."))
        elsif @maxspeed >= 105
          add_color_savour(0,1)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 2 was made."))
        end
      end
    # Blue + Gold
    elsif @flavor[0] <= 0 && @flavor[1] > 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(5,1)
        pbMessage(_INTL("Blue Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(5,0)
        pbMessage(_INTL("Blue Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,0)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,1)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 2 was made."))
        end
      end
    # Pink + Gold
    elsif @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] > 0 && @flavor[3] <= 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(6,1)
        pbMessage(_INTL("Pink Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(6,0)
        pbMessage(_INTL("Pink Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,0)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,1)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 2 was made."))
        end
      end
    # Green + Gold
    elsif @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] > 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(7,1)
        pbMessage(_INTL("Green Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(7,0)
        pbMessage(_INTL("Green Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,0)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,1)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 2 was made."))
        end
      end
    # Yellow + Gold
    elsif @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] > 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(8,1)
        pbMessage(_INTL("Yellow Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(8,0)
        pbMessage(_INTL("Yellow Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,0)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,1)
          pbMessage(_INTL("Gold Pokeblock - 1 Flavor - Level 2 was made."))
        end
      end
    # Purple + Gold
    elsif @flavor[0] > 0 && @flavor[1] > 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(9,1)
        pbMessage(_INTL("Purple Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(9,0)
        pbMessage(_INTL("Purple Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Indigo + Gold
    elsif @flavor[0] <= 0 && @flavor[1] > 0 && @flavor[2] > 0 && @flavor[3] <= 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(10,1)
        pbMessage(_INTL("Indigo Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(10,0)
        pbMessage(_INTL("Indigo Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Brown + Gold
    elsif @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] > 0 && @flavor[3] > 0 && @flavor[4] <= 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(11,1)
        pbMessage(_INTL("Brown Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(11,0)
        pbMessage(_INTL("Brown Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Lite Blue + Gold
    elsif @flavor[0] <= 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] > 0 && @flavor[4] > 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(12,1)
        pbMessage(_INTL("Lite Blue Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(12,0)
        pbMessage(_INTL("Lite Blue Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Olive + Gold
    elsif @flavor[0] > 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] > 0
      if @maxspeed <= 100 && @maxspeed >= 95 || @maxspeed > 100 && !@getreward
        # Add
        add_color_savour(13,1)
        pbMessage(_INTL("Olive Pokeblock - Level 2 was made."))
      elsif @maxspeed < 95
        # Add
        add_color_savour(13,0)
        pbMessage(_INTL("Olive Pokeblock - Level 1 was made."))
      elsif @getreward
        if @maxspeed > 100 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Gold + Black
    elsif @flavor[0] > 0 && @flavor[1] <= 0 && @flavor[2] > 0 && @flavor[3] <= 0 && @flavor[4] <= 0 ||
      @flavor[0] > 0 && @flavor[1] <= 0 && @flavor[2] <= 0 && @flavor[3] > 0 && @flavor[4] <= 0 ||
      @flavor[0] <= 0 && @flavor[1] > 0 && @flavor[2] <= 0 && @flavor[3] > 0 && @flavor[4] <= 0 ||
      @flavor[0] <= 0 && @flavor[1] > 0 && @flavor[2] <= 0 && @flavor[3] <= 0 && @flavor[4] > 0 
      if @maxspeed <= 95 || @maxspeed > 95 && !@getreward
        # Add
        add_color_savour(1,0)
        pbMessage(_INTL("Black Pokeblock was made."))
      elsif @getreward
        if @maxspeed > 95 && @maxspeed < 105
          # Add
          add_color_savour(0,2)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 1 was made."))
        elsif @maxspeed >= 105
          # Add
          add_color_savour(0,3)
          pbMessage(_INTL("Gold Pokeblock - 2 Flavors - Level 2 was made."))
        end
      end
    # Gray
    else
      if @maxspeed <= 100
        # Add
        add_color_savour(2,0)
        pbMessage(_INTL("Gray Pokeblock - Level 1 was made."))
      else
        # Add
        add_color_savour(2,1)
        pbMessage(_INTL("Gray Pokeblock - Level 2 was made."))
      end
    end  
  end
  
  def add_color_savour(num,pos)
    $game_variables[COLOR_SAVOUR[num][pos]] += 1
    $game_variables[COLOR_SAVOUR[num][pos]] = MAX_POKEBLOCK if $game_variables[COLOR_SAVOUR[num][pos]] >= MAX_POKEBLOCK
  end
  
#-------------------------------------------------------------------------------
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
    @viewport2.dispose
  end
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def dispose
    pbDisposeSpriteHash(@sprites)
  end
  
  def update_ingame
    Graphics.update
    Input.update
    self.update
  end
  
end
#-------------------------------------------------------------------------------
# Check berries
def hasBerries
  (1..PBItems.maxValue).each { |i| return true if $PokemonBag.pbQuantity(i)>0 && pbIsBerry?(i) }
  false
end
#-------------------------------------------------------------------------------
# Mode Berry Blender
def pbOneplayer
  scene = BerryBlender.new(0)
  scene.pbStart
end
def pbTwoplayers
  scene = BerryBlender.new(1)
  scene.pbStart
end
def pbThreeplayers
  scene = BerryBlender.new(2)
  scene.pbStart
end
def pbFourplayers
  scene = BerryBlender.new(3)
  scene.pbStart
end
def pbSpecialplayer
  scene = BerryBlender.new(-1)
  scene.pbStart
end