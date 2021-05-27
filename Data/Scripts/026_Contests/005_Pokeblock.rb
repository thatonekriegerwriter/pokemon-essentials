#-------------------------------------------------------------------------------
# PokeBlock && PokeNav by bo4p5687; graphics by Richard PT
#
#  References: ShiningMew (www.serebii.net) and (bulbapedia.bulbagarden.net)
#
#-------------------------------------------------------------------------------
# How to use:
#  pbPokeBlock -> open Pokeblock or you can use item PokeBlock
#  pbPokeNav_Condition -> open (Check party of PokeNav)
#-------------------------------------------------------------------------------
#
# To this script works, put it above main.
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => "PokeBlock && PokeNav",
  :credits => ["bo4p5687", "graphics by Richard PT"]
})
#-------------------------------------------------------------------------------
ItemHandlers::UseFromBag.add(:POKEBLOCK,proc{|item|
   next (pbPokeBlock) ? 1 : 0
})
#-------------------------------------------------------------------------------
ItemHandlers::UseFromBag.add(:POKENAV,proc{|item|
   next (pbPokeNav_Condition) ? 1 : 0
})
#-------------------------------------------------------------------------------
class PokeBlock
  
  def initialize
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99999
    @sprites={}
    @exit = false
    @process = 0
    @firstchoice = 0
    @secondnormal = 0
    @secondgold = 0
    @position = 0
    @pokemon = $Trainer.party[@position]
  end
#-------------------------------------------------------------------------------
# PokeBlock: Scene (Pokemon)
#-------------------------------------------------------------------------------
  def pbStart_pokemon
    # Draw
    draw_scene_pokemon
    loop do
      # Update
      update_ingame
      break if @exit == true
      appear_scene
      # Check
      check_party_pokemon
      if Input.trigger?(Input::C)
        @exit = true if @position == $Trainer.party.size
      end
      @exit = true if Input.trigger?(Input::B)
    end
    pbEndScene
  end
#-------------------------------------------------------------------------------
# PokeBlock: item
#-------------------------------------------------------------------------------
  def pbStart_item
    # Draw
    draw_scene_item
    loop do
      # Update
      update_ingame
      break if @exit == true
      case @process 
      when 0
        # Set visible
        @sprites["scene1"].visible = true
        @sprites["scene2"].visible = false
        @sprites["scene3"].visible = false
        @sprites["scene4"].visible = false
        @sprites["choice1"].visible = true
        @sprites["choice2"].visible = false
        @sprites["choice3"].visible = false
        # Set
        first_choice
        @exit = true if Input.trigger?(Input::B)
      when 1
        # Draw
        draw_title
        draw_quantity
        # Set
        if @firstchoice >= 2 && @firstchoice <= 13
          @sprites["scene1"].visible = false
          @sprites["scene2"].visible = true
          @sprites["choice1"].visible = false
          @sprites["choice2"].visible = true
          @process = 2
        elsif @firstchoice == 0
          @sprites["scene1"].visible = false
          @sprites["scene3"].visible = true
          @sprites["choice1"].visible = false
          @sprites["choice3"].visible = true
          @process = 3
        elsif @firstchoice == 1
          @sprites["scene1"].visible = false
          @sprites["scene4"].visible = true
          @sprites["choice1"].visible = false
          @process = 4
        end
      when 2
        # Set
        second_choice_normal
        if Input.trigger?(Input::B)
          @sprites["overlay_quantity"].bitmap.clear
          @sprites["overlay_title"].bitmap.clear
          @secondnormal = 0
          @process = 0
        end
        @process = 5 if Input.trigger?(Input::C)
      when 3
        # Set
        second_choice_gold
        if Input.trigger?(Input::B)
          @sprites["overlay_quantity"].bitmap.clear
          @sprites["overlay_title"].bitmap.clear
          @secondgold = 0
          @process = 0
        end
        @process = 5 if Input.trigger?(Input::C)
      when 4
        # Set
        if Input.trigger?(Input::B)
          @sprites["overlay_quantity"].bitmap.clear
          @sprites["overlay_title"].bitmap.clear
          @process = 0
        end
        @process = 5 if Input.trigger?(Input::C)
      when 5
        # Check
        check_exist_pokemon
      when 6
        # Draw
        draw_scene_pokemon
        @process = 7
      when 7
        appear_scene
        # Check
        check_party_pokemon
        if Input.trigger?(Input::C)
          if @position == $Trainer.party.size
            disappear_scene
            if @firstchoice >= 2 && @firstchoice <= 13
              @process = 2
            elsif @firstchoice == 1
              @process = 4
            elsif @firstchoice == 0
              @process = 3
            end
            @position = 0
          else
            @process = 8
          end
        end
        if Input.trigger?(Input::B)
          disappear_scene
          if @firstchoice >= 2 && @firstchoice <= 13
            @process = 2
          elsif @firstchoice == 1
            @process = 4
          elsif @firstchoice == 0
            @process = 3
          end
          @position = 0
        end
      when 8
        # Set
        increase_condition
      end
    end
    pbEndScene
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_scene_item
    (1..4).each { |i|
    @sprites["scene#{i}"] = Sprite.new(@viewport)
    @sprites["scene#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Scene_#{i}")
    @sprites["scene#{i}"].visible = false }
    
    (1..3).each { |i|
    @sprites["choice#{i}"] = Sprite.new(@viewport)
    @sprites["choice#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Choice_#{i}")
    @sprites["choice#{i}"].visible = false }
    
    @sprites["choice1"].x = 19
    @sprites["choice1"].y = 99
    
    @sprites["choice2"].x = 196
    @sprites["choice2"].y = 92
    
    @sprites["choice3"].x = 165
    @sprites["choice3"].y = 135
    
    (1..2).each { |i|
    @sprites["bitter#{i}"] = Sprite.new(@viewport)
    @sprites["bitter#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Bitter") # Green
    @sprites["bitter#{i}"].visible = false
    
    @sprites["dry#{i}"] = Sprite.new(@viewport)
    @sprites["dry#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Dry") # Blue
    @sprites["dry#{i}"].visible = false
    
    @sprites["sour#{i}"] = Sprite.new(@viewport)
    @sprites["sour#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Sour") # Yellow
    @sprites["sour#{i}"].visible = false
    
    @sprites["spicy#{i}"] = Sprite.new(@viewport)
    @sprites["spicy#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Spicy") # Red
    @sprites["spicy#{i}"].visible = false
    
    @sprites["sweet#{i}"] = Sprite.new(@viewport)
    @sprites["sweet#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Sweet") # Pink
    @sprites["sweet#{i}"].visible = false }
    
    # 1
    @sprites["spicy1"].x = 13
    @sprites["spicy1"].y = 284
    
    @sprites["dry1"].x = 13
    @sprites["dry1"].y = 315
    
    @sprites["sweet1"].x = 13
    @sprites["sweet1"].y = 348
    
    @sprites["bitter1"].x = 105
    @sprites["bitter1"].y = 284
    
    @sprites["sour1"].x = 105
    @sprites["sour1"].y = 315
    
    # 2
    @sprites["spicy2"].x = 387
    @sprites["spicy2"].y = 304
    
    @sprites["dry2"].x = 403
    @sprites["dry2"].y = 340
    
    @sprites["sweet2"].x = 444
    @sprites["sweet2"].y = 340
    
    @sprites["bitter2"].x = 426
    @sprites["bitter2"].y = 304
    
    @sprites["sour2"].x = 463
    @sprites["sour2"].y = 304
    
    @sprites["overlay_title"] = Sprite.new(@viewport)
    @sprites["overlay_title"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_title"].bitmap.clear
    
    @sprites["overlay_quantity"] = Sprite.new(@viewport)
    @sprites["overlay_quantity"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_quantity"].bitmap.clear
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def first_choice
    case @firstchoice
    when 0 # Gold
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = true
      @sprites["dry2"].visible = true
      @sprites["sour2"].visible = true
      @sprites["spicy2"].visible = true
      @sprites["sweet2"].visible = true
      
      @sprites["choice1"].x = 19
      @sprites["choice1"].y = 99
    when 1 # Black
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = true
      @sprites["dry2"].visible = true
      @sprites["sour2"].visible = true
      @sprites["spicy2"].visible = true
      @sprites["sweet2"].visible = true
      
      @sprites["choice1"].x = 19
      @sprites["choice1"].y = 179
    when 2 # Gray
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = true
      @sprites["dry2"].visible = true
      @sprites["sour2"].visible = true
      @sprites["spicy2"].visible = true
      @sprites["sweet2"].visible = true
      
      @sprites["choice1"].x = 139
      @sprites["choice1"].y = 99
    when 3 # White
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = true
      @sprites["dry2"].visible = true
      @sprites["sour2"].visible = true
      @sprites["spicy2"].visible = true
      @sprites["sweet2"].visible = true
      
      @sprites["choice1"].x = 139
      @sprites["choice1"].y = 179
    when 4 # Red
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = true
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 259
      @sprites["choice1"].y = 20
    when 5 # Blue
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = true
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 259
      @sprites["choice1"].y = 66
    when 6 # Pink
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = true
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 259
      @sprites["choice1"].y = 112
    when 7 # Green
      
      @sprites["bitter1"].visible = true
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      
      @sprites["choice1"].x = 259
      @sprites["choice1"].y = 158
    when 8 # Yellow
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = true
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 259
      @sprites["choice1"].y = 204
    when 9 # Purple
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = true
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = true
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 379
      @sprites["choice1"].y = 20
    when 10 # Indigo
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = true
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = true
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 379
      @sprites["choice1"].y = 66
    when 11 # Brown
      
      @sprites["bitter1"].visible = true
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = false
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = true
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 379
      @sprites["choice1"].y = 112
    when 12 # Lite Blue
      
      @sprites["bitter1"].visible = true
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = true
      @sprites["spicy1"].visible = false
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 379
      @sprites["choice1"].y = 158
    when 13 # Olive
      
      @sprites["bitter1"].visible = false
      @sprites["dry1"].visible = false
      @sprites["sour1"].visible = true
      @sprites["spicy1"].visible = true
      @sprites["sweet1"].visible = false
      
      @sprites["bitter2"].visible = false
      @sprites["dry2"].visible = false
      @sprites["sour2"].visible = false
      @sprites["spicy2"].visible = false
      @sprites["sweet2"].visible = false
      
      @sprites["choice1"].x = 379
      @sprites["choice1"].y = 204
    end
    if Input.trigger?(Input::UP)
      @firstchoice -= 1
      @firstchoice = 13 if @firstchoice < 0
    end
    if Input.trigger?(Input::DOWN)
      @firstchoice += 1
      @firstchoice = 0 if @firstchoice > 13
    end
    if Input.trigger?(Input::LEFT)
      if @firstchoice == 0
        @firstchoice = 13 
      elsif @firstchoice <= 13 && @firstchoice >= 9
        @firstchoice -= 5
      elsif @firstchoice <= 8 && @firstchoice >= 5
        @firstchoice += 4
      elsif @firstchoice == 4
        @firstchoice = 3
      elsif @firstchoice <= 3 && @firstchoice >= 2
        @firstchoice -= 2
      elsif @firstchoice == 1
        @firstchoice = 2
      end
    end
    if Input.trigger?(Input::RIGHT)
      if @firstchoice == 13
        @firstchoice = 0
      elsif @firstchoice <= 1 && @firstchoice >= 0
        @firstchoice += 2
      elsif @firstchoice == 2
        @firstchoice = 1
      elsif @firstchoice == 3
        @firstchoice = 4
      elsif @firstchoice <= 8 && @firstchoice >= 4
        @firstchoice += 5
      elsif @firstchoice <= 12 && @firstchoice >= 9
        @firstchoice -= 4
      end
    end
    if Input.trigger?(Input::C)
      (1..2).each { |i|
        @sprites["bitter#{i}"].visible = false
        @sprites["dry#{i}"].visible = false
        @sprites["sour#{i}"].visible = false
        @sprites["spicy#{i}"].visible = false
        @sprites["sweet#{i}"].visible = false }
      @process = 1
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Title
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def draw_title  
    bitmap = @sprites["overlay_title"].bitmap
    bitmap.clear
    # Set xy
    xposition = 326
    yposition = 8
    # Set title
    list_title = ["GOLD","BLACK","GRAY","WHITE","RED","BLUE","PINK","GREEN",
    "YELLOW","PURPLE","INDIGO","BROWN","LITE BLUE","OLIVE"]
    # Set text
    textposition = []
    (0...list_title.length).each { |i|
    textposition.push([_INTL("{1}",list_title[i]),
    xposition,yposition,2,Color.new(255,255,255),Color.new(113,113,113)]) if i == @firstchoice }
    bitmap.font.size = 40
    pbDrawTextPositions(bitmap,textposition)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Quantity
  def draw_quantity
    bitmap = @sprites["overlay_quantity"].bitmap
    bitmap.clear
    # Set xy
    xposition = 494
    yposition = 314
    # Set text
    textposition = []
    (0...COLOR_SAVOUR.length).each { |i|
    if i == @firstchoice
      if i >= 2 && i <= 13
        (0..1).each { |j|
        textposition.push([_INTL("{1}",$game_variables[COLOR_SAVOUR[i][j]]),
        xposition,yposition,1,Color.new(255,255,255),Color.new(113,113,113)]) if @secondnormal == j }
      elsif i == 1
        textposition.push([_INTL("{1}",$game_variables[COLOR_SAVOUR[1][0]]),
        xposition,yposition,1,Color.new(255,255,255),Color.new(113,113,113)])
      elsif i == 0
        (0..3).each { |j|
        textposition.push([_INTL("{1}",$game_variables[COLOR_SAVOUR[0][j]]),
        xposition,yposition,1,Color.new(255,255,255),Color.new(113,113,113)]) if @secondgold == j }
      end
    end }
    bitmap.font.size = 60
    pbDrawTextPositions(bitmap,textposition)
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def second_choice_normal  # Second page (except Gold, Black)
    case @secondnormal
    when 0
      @sprites["choice2"].x = 196
      @sprites["choice2"].y = 92
    when 1
      @sprites["choice2"].x = 196
      @sprites["choice2"].y = 197
    end
    if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
      @secondnormal = (@secondnormal == 0)? 1 : 0
      # Draw
      draw_quantity
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def second_choice_gold  # Second page (gold)
    case @secondgold
    when 0
      @sprites["choice3"].x = 165
      @sprites["choice3"].y = 135
    when 1
      @sprites["choice3"].x = 165
      @sprites["choice3"].y = 212
    when 2
      @sprites["choice3"].x = 352
      @sprites["choice3"].y = 135
    when 3
      @sprites["choice3"].x = 352
      @sprites["choice3"].y = 212
    end
    if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
      if @secondgold == 0 || @secondgold == 2
        @secondgold += 1
      elsif @secondgold == 1 || @secondgold == 3
        @secondgold -= 1
      end
      # Draw
      draw_quantity
    end
    if Input.trigger?(Input::LEFT)
      if @secondgold == 0
        @secondgold = 3
      elsif @secondgold == 3 || @secondgold == 2
        @secondgold -= 2
      elsif @secondgold == 1
        @secondgold = 2
      end
      # Draw
      draw_quantity
    end
    if Input.trigger?(Input::RIGHT)
      if @secondgold == 0 || @secondgold == 1
        @secondgold += 2
      elsif @secondgold == 2
        @secondgold = 1
      elsif @secondgold == 3
        @secondgold = 0
      end
      # Draw
      draw_quantity
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def check_exist_pokemon
    party = $Trainer.party.size
    if party == 0
      if @firstchoice >= 2 && @firstchoice <= 13
        pbMessage(_INTL("You don't have any Pokemon."))
        @process = 2
      elsif @firstchoice == 1
        pbMessage(_INTL("You don't have any Pokemon."))
        @process = 4
      elsif @firstchoice == 0
        pbMessage(_INTL("You don't have any Pokemon."))
        @process = 3
      end
    else
      (0...COLOR_SAVOUR.length).each { |j|
      if j == @firstchoice
        if j >= 2 && j <= 13
          (0..1).each { |k| 
          if @secondnormal == k
            if $game_variables[COLOR_SAVOUR[j][k]] > 0
              @process = 6
            else
              pbMessage(_INTL("You don't have any Pokeblocks."))
              @process = 2
            end
          end }
        elsif j == 1
          if $game_variables[COLOR_SAVOUR[1][0]] > 0
           @process = 6
         else
           pbMessage(_INTL("You don't have any Pokeblocks."))
           @process = 4
         end
        elsif j == 0
          (0..3).each { |k| 
          if @secondgold == k
            if $game_variables[COLOR_SAVOUR[0][k]] > 0
              @process = 6
            else
              pbMessage(_INTL("You don't have any Pokeblocks."))
              @process = 3
            end
          end }
        end
      end }
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def nature_sprite(spritename,filename,x_cor,y_cor)
    @sprites["#{spritename}"] = Sprite.new(@viewport1)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Bar_#{filename}")
    @sprites["#{spritename}"].x = x_cor
    @sprites["#{spritename}"].y = y_cor
    @sprites["#{spritename}"].visible = false
  end
#-------------------------------------------------------------------------------
  def draw_scene_pokemon
    @sprites["behind_scene_pokemon"] = Sprite.new(@viewport1)
    @sprites["behind_scene_pokemon"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Behind_pokemon")
    @sprites["behind_scene_pokemon"].visible = false
    
    # Nature
    nature_sprite("cool","Cool",-55,138)
    nature_sprite("beauty","Beauty",-55,180)
    nature_sprite("cute","Cute",-55,222)
    nature_sprite("smart","Smart",-55,264)
    nature_sprite("tough","Tough",-55,306)
    nature_sprite("sheen","Sheen",-55,348)
    
    @sprites["scene_pokemon"] = Sprite.new(@viewport1)
    @sprites["scene_pokemon"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Scene_pokemon")
    @sprites["scene_pokemon"].visible = false
    
    @sprites["overlay_pokemon"] = Sprite.new(@viewport1)
    @sprites["overlay_pokemon"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_pokemon"].bitmap.clear
    @sprites["overlay_pokemon"].visible = false
    
    @sprites["overlay_nature"] = Sprite.new(@viewport1)
    @sprites["overlay_nature"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_nature"].bitmap.clear
    @sprites["overlay_nature"].visible = false
    
    if $Trainer.party.size > 0
      (1..$Trainer.party.size).each { |i|
      @sprites["ball_opaque#{i}"] = Sprite.new(@viewport1)
      @sprites["ball_opaque#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Ball_opaque")
      @sprites["ball_opaque#{i}"].x = 474
      @sprites["ball_opaque#{i}"].y = 48 + 40*(i-1)
      @sprites["ball_opaque#{i}"].visible = false }
    end
    
    @sprites["ball"] = Sprite.new(@viewport1)
    @sprites["ball"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Ball")
    @sprites["ball"].x = 474
    @sprites["ball"].y = 48
    @sprites["ball"].visible = false
    
    @sprites["cancel"] = Sprite.new(@viewport1)
    @sprites["cancel"].bitmap = Bitmap.new("Graphics/Pictures/Pokeblock/Cancel")
    @sprites["cancel"].x = 470
    @sprites["cancel"].y = 290
    @sprites["cancel"].visible = false
    
    @sprites["pokemon"] = PokemonSprite.new(@viewport1)
    @sprites["pokemon"].setOffset(PictureOrigin::Center)
    @sprites["pokemon"].x = 82
    @sprites["pokemon"].y = 190
    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokemon"].visible = false
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def check_party_pokemon
    check_condition
    appear_ball_choice
    information_pokemon
    if Input.trigger?(Input::UP)
      @position -= 1
      @position = 0 if @position <= 0
    end
    if Input.trigger?(Input::DOWN)
      @position += 1
      @position = $Trainer.party.size if @position >= $Trainer.party.size
    end
    if @position < $Trainer.party.size && @position >= 0
      @pokemon = $Trainer.party[@position]
      @sprites["pokemon"].setPokemonBitmap(@pokemon)
    elsif @position == $Trainer.party.size
      @sprites["pokemon"].visible = false
    end
  end
#-------------------------------------------------------------------------------
  def appear_scene
    @sprites["behind_scene_pokemon"].visible = true
    @sprites["cool"].visible = true
    @sprites["beauty"].visible = true
    @sprites["cute"].visible = true
    @sprites["smart"].visible = true
    @sprites["tough"].visible = true
    @sprites["sheen"].visible = true
    @sprites["scene_pokemon"].visible = true
    @sprites["overlay_pokemon"].visible = true
    @sprites["overlay_nature"].visible = true
    # Ball && Pokemon
    (1..$Trainer.party.size).each { |i| @sprites["ball_opaque#{i}"].visible = true if @sprites["ball_opaque#{i}"] }
    @sprites["pokemon"].visible = true
  end
#-------------------------------------------------------------------------------
  def disappear_scene
    @sprites["behind_scene_pokemon"].visible = false
    @sprites["cool"].visible = false
    @sprites["beauty"].visible = false
    @sprites["cute"].visible = false
    @sprites["smart"].visible = false
    @sprites["tough"].visible = false
    @sprites["sheen"].visible = false
    @sprites["scene_pokemon"].visible = false
    @sprites["overlay_pokemon"].visible = false
    @sprites["overlay_nature"].visible = false
    # Ball && Pokemon
    (1..$Trainer.party.size).each { |i| @sprites["ball_opaque#{i}"].visible = false if @sprites["ball_opaque#{i}"] }
    @sprites["pokemon"].visible = false
    @sprites["ball"].visible = false
    @sprites["cancel"].visible = false
  end
#-------------------------------------------------------------------------------
  def check_condition
    if $Trainer.party.size > 0
      if @position <= $Trainer.party.size-1 && @position >= 0
        pos = $Trainer.party[@position]
        # Set
        @sprites["cool"].x = -55 + pos.cool
        @sprites["beauty"].x = -55 + pos.beauty
        @sprites["cute"].x = -55 + pos.cute
        @sprites["smart"].x = -55 + pos.smart
        @sprites["tough"].x = -55 + pos.tough
        @sprites["sheen"].x = -55 + pos.sheen
      end
    end
  end
#-------------------------------------------------------------------------------
  def appear_ball_choice
    if $Trainer.party.size > 0
      if @position == $Trainer.party.size
        @sprites["ball"].visible = false
        @sprites["cancel"].visible = true
      else
        @sprites["ball"].y = 48 + 40*@position
        @sprites["ball"].visible = true
        @sprites["cancel"].visible = false
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def information_pokemon
    bitmap = @sprites["overlay_nature"].bitmap
    bitmap.clear
    bitmap1 = @sprites["overlay_pokemon"].bitmap
    bitmap1.clear
    if @position != $Trainer.party.size
      pokemon = $Trainer.party[@position]
      textposition = []
      textposition.push(
        [_INTL("{1}",getConstantName(PBNatures,pokemon.nature)),
        3,317,0,Color.new(255,255,255),Color.new(113,113,113)])
      textposition1 = []
      textposition1.push(
        [_INTL("{1}",pokemon.name),
        205,39,0,Color.new(255,255,255),Color.new(113,113,113)],
        [_INTL("{1}",getConstantName(PBSpecies,pokemon.species)),
        205,7,0,Color.new(255,255,255),Color.new(113,113,113)],
        [_INTL("Level: {1}",pokemon.level),
        205,71,0,Color.new(255,255,255),Color.new(113,113,113)])
      if pokemon.isMale?
        textposition1.push([_INTL("♂"),315,71,0,Color.new(0,128,248),Color.new(168,184,184)])
      elsif pokemon.isFemale?
        textposition1.push([_INTL("♀"),315,71,0,Color.new(248,24,24),Color.new(168,184,184)])
      end
      bitmap.font.size = 35
      pbDrawTextPositions(bitmap,textposition)
      bitmap1.font.size = 25
      pbDrawTextPositions(bitmap1,textposition1)
    end
  end
  
  def full_condition
    if @position != $Trainer.party.size
      pokemon = $Trainer.party[@position]
      pokemon.beauty = 255 if pokemon.beauty >= 255
      pokemon.cute = 255 if pokemon.cute >= 255
      pokemon.smart = 255 if pokemon.smart >= 255
      pokemon.cool = 255 if pokemon.cool >= 255
      pokemon.tough = 255 if pokemon.tough >= 255
    end
  end
  
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Check increase condition
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def increase_and_check(number1,number2,nmcolor,namecolor,secondp=false,dislike=false,thirdp=false,fourp=false)
    if $game_variables[COLOR_SAVOUR[number1][number2]] > 0
      pokemon = $Trainer.party[@position]
      nat = [0,1,2,3,4]
      random = nat.shuffle
      if random[0] == 0 
        pokemon.cool += nmcolor
      elsif random[0] == 1 
        pokemon.beauty += nmcolor
      elsif random[0] == 2 
        pokemon.cute += nmcolor
      elsif random[0] == 3
        pokemon.smart += nmcolor
      elsif random[0] == 4 
        pokemon.tough += nmcolor
      end
      if secondp
        random.delete_at(0)
        if random[0] == 0 
          pokemon.cool += nmcolor
        elsif random[0] == 1 
          pokemon.beauty += nmcolor
        elsif random[0] == 2 
          pokemon.cute += nmcolor
        elsif random[0] == 3
          pokemon.smart += nmcolor
        elsif random[0] == 4 
          pokemon.tough += nmcolor
        end
      end
      if thirdp
        random.delete_at(0)
        if random[0] == 0 
          pokemon.cool += nmcolor
        elsif random[0] == 1 
          pokemon.beauty += nmcolor
        elsif random[0] == 2 
          pokemon.cute += nmcolor
        elsif random[0] == 3
          pokemon.smart += nmcolor
        elsif random[0] == 4 
          pokemon.tough += nmcolor
        end
      end
      if fourp
        random.delete_at(0)
        if random[0] == 0 
          pokemon.cool += nmcolor
        elsif random[0] == 1 
          pokemon.beauty += nmcolor
        elsif random[0] == 2 
          pokemon.cute += nmcolor
        elsif random[0] == 3
          pokemon.smart += nmcolor
        elsif random[0] == 4 
          pokemon.tough += nmcolor
        end
      end
      if !dislike
        pbMessage(_INTL("{1} ate {2} Pokeblock! It seems to enjoy the taste.",pokemon.name,namecolor))
      else
        pbMessage(_INTL("{1} ate {2} Pokeblock! It seems to dislike the taste.",pokemon.name,namecolor))
      end
      pokemon.sheen += 8.5
      # Check condition
      full_condition
      check_condition
      $game_variables[COLOR_SAVOUR[number1][number2]] -= 1
      # Draw quantity
      draw_quantity
      @process = 7
    else
      pbMessage(_INTL("You don't have any {1} Pokeblocks.",namecolor))
      @process = 7
    end
  end
#-------------------------------------------------------------------------------
  def increase_and_check_2(number1,number2,n11,n12,n13,n14,n21,n22,n23,n24,pkmnct,nmb1,nmb2,nmb3,color)
    if $game_variables[COLOR_SAVOUR[number1][number2]] > 0
      pokemon = $Trainer.party[@position]
      if pokemon.nature == n11 || pokemon.nature == n12 || pokemon.nature == n13 || pokemon.nature == n14
        case pkmnct 
        when 0; pokemon.cool += nmb1
        when 1; pokemon.beauty += nmb1
        when 2; pokemon.cute += nmb1
        when 3; pokemon.smart += nmb1
        when 4; pokemon.tough += nmb1
        end
        pbMessage(_INTL("{1} happily ate {2} Pokeblock!",pokemon.name,color))
      elsif pokemon.nature == n21 || pokemon.nature == n22 || pokemon.nature == n23 || pokemon.nature == n24
        case pkmnct 
        when 0; pokemon.cool += nmb2
        when 1; pokemon.beauty += nmb2
        when 2; pokemon.cute += nmb2
        when 3; pokemon.smart += nmb2
        when 4; pokemon.tough += nmb2
        end
        pbMessage(_INTL("{1} disdainfully ate {2} Pokeblock!",pokemon.name,color))
      else
        case pkmnct 
        when 0; pokemon.cool += nmb3
        when 1; pokemon.beauty += nmb3
        when 2; pokemon.cute += nmb3
        when 3; pokemon.smart += nmb3
        when 4; pokemon.tough += nmb3
        end
        pbMessage(_INTL("{1} ate {2} Pokeblock!",pokemon.name,color))
      end
      pokemon.sheen += 8.5
      # Check condition
      full_condition
      check_condition
      $game_variables[COLOR_SAVOUR[number1][number2]] -= 1
      # Draw quantity
      draw_quantity
      @process = 7
    else
      pbMessage(_INTL("You don't have any {1} Pokeblocks.",color))
      @process = 7
    end
  end
#-------------------------------------------------------------------------------
  def increase_and_check_3(number1,number2,n11,n12,n13,n14,n15,n16,n21,n22,n23,n24,n25,n26,n27,n28,pkmnct1,pkmnct2,nmb1,nmb2,nmb3,color)
    if $game_variables[COLOR_SAVOUR[number1][number2]] > 0
      pokemon = $Trainer.party[@position]
      if pokemon.nature == n11 || pokemon.nature == n12 || pokemon.nature == n13 || 
        pokemon.nature == n14 || pokemon.nature == n15 || pokemon.nature == n16
        case pkmnct1
        when 0; pokemon.cool += nmb1
        when 1; pokemon.beauty += nmb1
        when 2; pokemon.cute += nmb1
        when 3; pokemon.smart += nmb1
        when 4; pokemon.tough += nmb1
        end
        case pkmnct2 
        when 0; pokemon.cool += nmb1
        when 1; pokemon.beauty += nmb1
        when 2; pokemon.cute += nmb1
        when 3; pokemon.smart += nmb1
        when 4; pokemon.tough += nmb1
        end
        pbMessage(_INTL("{1} happily ate {2} Pokeblock!",pokemon.name,color))
      elsif pokemon.nature == n21 || pokemon.nature == n22 || pokemon.nature == n23 || pokemon.nature == n24 ||
        pokemon.nature == n25 || pokemon.nature == n26 || pokemon.nature == n27 || pokemon.nature == n28
        case pkmnct1
        when 0; pokemon.cool += nmb2
        when 1; pokemon.beauty += nmb2
        when 2; pokemon.cute += nmb2
        when 3; pokemon.smart += nmb2
        when 4; pokemon.tough += nmb2
        end
        case pkmnct2 
        when 0; pokemon.cool += nmb2
        when 1; pokemon.beauty += nmb2
        when 2; pokemon.cute += nmb2
        when 3; pokemon.smart += nmb2
        when 4; pokemon.tough += nmb2
        end
        pbMessage(_INTL("{1} disdainfully ate {2} Pokeblock!",pokemon.name,color))
      else
        case pkmnct1
        when 0; pokemon.cool += nmb3
        when 1; pokemon.beauty += nmb3
        when 2; pokemon.cute += nmb3
        when 3; pokemon.smart += nmb3
        when 4; pokemon.tough += nmb3
        end
        case pkmnct2 
        when 0; pokemon.cool += nmb3
        when 1; pokemon.beauty += nmb3
        when 2; pokemon.cute += nmb3
        when 3; pokemon.smart += nmb3
        when 4; pokemon.tough += nmb3
        end
        pbMessage(_INTL("{1} ate {2} Pokeblock!",pokemon.name,color))
      end
      pokemon.sheen += 8.5
      # Check condition
      full_condition
      check_condition
      $game_variables[COLOR_SAVOUR[number1][number2]] -= 1
      # Draw quantity
      draw_quantity
      @process = 7
    else
      pbMessage(_INTL("You don't have any {1} Pokeblocks.",color))
      @process = 7
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def increase_condition
    if @position != $Trainer.party.size
      pokemon = $Trainer.party[@position]
      if pokemon.sheen >= 255
        pbMessage(_INTL("{1} can't eat anymore Pokéblocks",pokemon.name))
        @process = 7
      else
        case @firstchoice
        when 0 # Gold
          case @secondgold
          when 0; increase_and_check(0,0,15,"Gold")
          when 1; increase_and_check(0,1,20,"Gold")
          when 2; increase_and_check(0,2,15,"Gold",true)
          when 3; increase_and_check(0,3,20,"Gold",true)
          end
        when 1 # Black
          increase_and_check(1,0,6,"Black",false,true)
        when 2 # Gray
          case @secondnormal
          when 0; increase_and_check(2,0,8.5,"Gray",true,false,true)
          when 1; increase_and_check(2,1,10,"Gray",true,false,true)
          end
        when 3 # White
          case @secondnormal
          when 0; increase_and_check(3,0,8.5,"White",true,false,true,true)
          when 1; increase_and_check(3,1,10,"White",true,false,true,true)
          end
         when 4 # Red
          if pokemon.cool >= 255
            pbMessage(_INTL("{1}'s coolness can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0; increase_and_check_2(4,0,5,10,15,20,1,2,3,4,0,10,6.5,8.5,"Red")
            when 1; increase_and_check_2(4,1,5,10,15,20,1,2,3,4,0,12,8.5,10,"Red")
            end
          end
        when 5 # Blue
          if pokemon.beauty >= 255
            pbMessage(_INTL("{1}'s beauty can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0; increase_and_check_2(5,0,3,8,13,23,15,16,17,19,1,10,6.5,8.5,"Blue")
            when 1; increase_and_check_2(5,1,3,8,13,23,15,16,17,19,1,12,8.5,10,"Blue")
            end
          end
        when 6 # Pink
          if pokemon.cute >= 255
            pbMessage(_INTL("{1}'s cuteness can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0; increase_and_check_2(6,0,2,7,17,22,10,11,13,14,2,10,6.5,8.5,"Pink")
            when 1; increase_and_check_2(6,1,2,7,17,22,10,11,13,14,2,12,8.5,10,"Pink")
            end
          end
        when 7 # Green
          if pokemon.smart >= 255
            pbMessage(_INTL("{1}'s intelligence can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0; increase_and_check_2(7,0,4,9,14,19,20,21,22,23,3,10,6.5,8.5,"Green")
            when 1; increase_and_check_2(7,1,4,9,14,19,20,21,22,23,3,12,8.5,10,"Green")
            end
          end
        when 8 # Yellow
          if pokemon.tough >= 255
            pbMessage(_INTL("{1}'s toughness can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0; increase_and_check_2(8,0,1,11,16,21,5,7,8,9,4,10,6.5,8.5,"Yellow")
            when 1; increase_and_check_2(8,1,1,11,16,21,5,7,8,9,4,12,8.5,10,"Yellow")
            end
          end
        when 9 # Purple
          if pokemon.cool >= 255
            pbMessage(_INTL("{1}'s coolness can't go any higher",pokemon.name))
            @process = 7
          elsif pokemon.beauty >= 255
            pbMessage(_INTL("{1}'s beauty can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0
              increase_and_check_3(9,0,5,10,20,8,23,13,1,2,3,4,15,16,17,19,0,1,10,6.5,8.5,"Purple")
            when 1
              increase_and_check_3(9,1,5,10,20,8,23,13,1,2,3,4,15,16,17,19,0,1,12,8.5,10,"Purple")
            end
          end
        when 10 # Indigo
          if pokemon.cute >= 255
            pbMessage(_INTL("{1}'s cuteness can't go any higher",pokemon.name))
            @process = 7
          elsif pokemon.beauty >= 255
            pbMessage(_INTL("{1}'s beauty can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0
              increase_and_check_3(10,0,2,7,22,3,8,23,15,16,17,19,10,11,13,14,2,1,10,6.5,8.5,"Indigo")
            when 1
              increase_and_check_3(10,1,2,7,22,3,8,23,15,16,17,19,10,11,13,14,2,1,12,8.5,10,"Indigo")
            end
          end
        when 11 # Brown
          if pokemon.cute >= 255
            pbMessage(_INTL("{1}'s cuteness can't go any higher",pokemon.name))
            @process = 7
          elsif pokemon.smart >= 255
            pbMessage(_INTL("{1}'s intelligence can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0
              increase_and_check_3(11,0,4,9,19,2,7,17,20,21,22,23,10,11,13,14,2,3,10,6.5,8.5,"Brown")
            when 1
              increase_and_check_3(11,1,4,9,19,2,7,17,20,21,22,23,10,11,13,14,2,3,12,8.5,10,"Brown")
            end
          end
        when 12 # Lite Blue
          if pokemon.tough >= 255
            pbMessage(_INTL("{1}'s toughness can't go any higher",pokemon.name))
            @process = 7
          elsif pokemon.smart >= 255
            pbMessage(_INTL("{1}'s intelligence can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0
              increase_and_check_3(12,0,1,11,16,4,14,19,20,21,22,23,5,7,8,9,4,3,10,6.5,8.5,"Litle Blue")
            when 1
              increase_and_check_3(12,1,1,11,16,4,14,19,20,21,22,23,5,7,8,9,4,3,12,8.5,10,"Litle Blue")
            end
          end
        when 13 # Olive
          if pokemon.tough >= 255
            pbMessage(_INTL("{1}'s toughness can't go any higher",pokemon.name))
            @process = 7
          elsif pokemon.cool >= 255
            pbMessage(_INTL("{1}'s coolness can't go any higher",pokemon.name))
            @process = 7
          else
            case @secondnormal
            when 0
              increase_and_check_3(13,0,11,16,21,10,15,20,1,2,3,4,5,7,8,9,4,0,10,6.5,8.5,"Olive")
            when 1
              increase_and_check_3(13,1,11,16,21,10,15,20,1,2,3,4,5,7,8,9,4,0,12,8.5,10,"Olive")
            end
          end
        end
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
  end
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def update_ingame
    Graphics.update
    Input.update
    self.update
  end
  
end
#-------------------------------------------------------------------------------
def pbPokeBlock
  scene = PokeBlock.new
  scene.pbStart_item
end
def pbPokeNav_Condition
  scene = PokeBlock.new
  scene.pbStart_pokemon
end