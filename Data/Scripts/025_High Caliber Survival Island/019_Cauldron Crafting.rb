#===============================================================================
#                              *Item Crafter
# *Item Crafter scene created by TheKrazyGamer/kcgcrazy/TheKraazyGamer
# *Please Give Credit if used
#
# *to add an item of your own just add it to the RECIPECAUL array.
#   Add The ITEMID,AMOUNT to be crafted,required MATERIALS and COSTS
#   and also BOOLEAN values for it being unlocked or not.
#   If a Second Material is not being used, enter nil.
#
#   Here is an example!
#
# RECIPECAUL=[
#  [:ITEMID,CRAFT_AMOUNT,[:MATERIAL1,COST],[:MATERIAL2,COST],IS_UNLOCKED?]
#  ]
############################################################
# RECIPECAUL=[
# [:ATKCURRY,1,[:SPELONBERRY,5],[:BOWL,1],true],
# [:SATKCURRY,1,[:KELPSYBERRY,5],[:BOWL,1],true],
# [:SPEEDCURRY,1,[:WATMELBERRY,5],[:BOWL,1],true],
# [:SPDEFCURRY,1,[:DURINBERRY,5],[:BOWL,1],true],
# [:ACCCURRY,1,[:MICLEBERRY,5],[:BOWL,1],true],
# [:DEFCURRY,1,[:BELUEBERRY,5],[:BOWL,1],true],
# [:CRITCURRY,1,[:LANSATBERRY,5],[:BOWL,1],true],
# [:GSCURRY,1,[:STARFBERRY,5],[:BOWL,1],true]
# ]
#
############################################################
#
#  *To call put CauldCrafterScene.new in an event 
#   or create an item like this
#
# #Item Crafter
# ItemHandlers::UseFromBag.add(:ITEMCRAFTER,proc{|item|
#     Kernel.pbMessage(_INTL("{1} used the {2}.",$Trainer.name,PBItems.getName(item)))
#       CauldCrafterScene.new
#     next 1
#  })
#
# and add this to the Items.txt
# XXX,ITEMCRAFTER,Item Crafter,8,0,"Lets you craft items.",2,0,6,
# XXX - This is the number you can use in items.txt
# Create an item in icons folder with that number.
#
# To unlock an item that was set as false, just add the following after an event:
# $game_variables[CRAFTVAR][x]=true # x being the item index (count from 0 for the first etc)
#
# And Finally...
#
# Add setupCraftUnlocks to an event in the Intro Event to initialize
# The $game_variables.
#
#
#===============================================================================

CRAFTVAR = 100 # number used for available $game_variable.

$exit = 0
$isUnlocked = []
###############################################################################
# This is your Items, Material etc.
###############################################################################

RECIPECAUL=[
[:ATKCURRY,1,[:SPELONBERRY,3],[:BOWL,1], true],
[:SATKCURRY,1,[:KELPSYBERRY,3],[:BOWL,1], true],
[:SPEEDCURRY,1,[:WATMELBERRY,3],[:BOWL,1], true],
[:SPDEFCURRY,1,[:DURINBERRY,3],[:BOWL,1], true],
[:ACCCURRY,1,[:MICLEBERRY,3],[:BOWL,1], true],
[:DEFCURRY,1,[:BELUEBERRY,3],[:BOWL,1], true],
[:CRITCURRY,1,[:LANSATBERRY,3],[:BOWL,1], true],
[:GSCURRY,1,[:STARFBERRY,3],[:BOWL,1], true]
]
###############################################################################

# This goes through the RECIPECAUL array and adds the true or false value from it
# to the $game_variables[CRAFTVAR] array
    for i in 0...RECIPECAUL.length
     $isUnlocked[i] = RECIPECAUL[i][4]
    end
   
  def setupCraftUnlocks
   $game_variables[CRAFTVAR] = $isUnlocked
  end

#From here onwards you DO NOT change anything.
class BrewCrafterScene

  def initialize
    @close = $exit
    @select=3
    @item=0
    @mat1=RECIPECAUL[@item][2]? RECIPECAUL[@item][2][0] : -1 # the amount for first item
    @mat2=RECIPECAUL[@item][3]? RECIPECAUL[@item][3][0] : -1 # the amount for first item
    @cost1=RECIPECAUL[@item][2]? RECIPECAUL[@item][2][1] : 0 # the amount for first item
    @cost2=RECIPECAUL[@item][3]? RECIPECAUL[@item][3][1] : 0 # the amount for first item
    @amount=RECIPECAUL[@item][1] # the amount for the first item made
                  
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}

    @sprites["bg"]=IconSprite.new(0,0,@viewport)    
    @sprites["bg"].setBitmap("Graphics/Pictures/ItemCrafter/BG")
    
    @sprites["Item"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item"].setBitmap("Graphics/Pictures/ItemCrafter/Item_BG")
    @sprites["Item"].x=210+10
    @sprites["Item"].y=30
     
    @sprites["Item_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/ItemHov_BG")
    @sprites["Item_Hov"].x=210+10
    @sprites["Item_Hov"].y=30
    @sprites["Item_Hov"].opacity=0
    
    @sprites["Item_icon"]=IconSprite.new(0,0,@viewport)   
    @sprites["Item_icon"].setBitmap(pbItemIconFile(getID(PBItems,RECIPECAUL[@item][0])))
    @sprites["Item_icon"].x=220+10
    @sprites["Item_icon"].y=40
    @sprites["Item_icon"].opacity=0
    
    @sprites["unknown"]=IconSprite.new(0,0,@viewport)    
    @sprites["unknown"].setBitmap("Graphics/Pictures/ItemCrafter/unknown")
    @sprites["unknown"].x=220
    @sprites["unknown"].y=30
    
    @sprites["Item_1"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1"].setBitmap("Graphics/Pictures/ItemCrafter/ItemR_BG")
    @sprites["Item_1"].x=65
    @sprites["Item_1"].y=100
    
    @sprites["Item_1_icon"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1_icon"].setBitmap((@mat1!=-1) ? pbItemIconFile(getID(PBItems,@mat1)) : "")
    @sprites["Item_1_icon"].x=65+10
    @sprites["Item_1_icon"].y=100+10
    @sprites["Item_1_icon"].opacity=0
    
    @sprites["Item_1_name"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_1_name"].setBitmap("Graphics/Pictures/ItemCrafter/Item_Name")
    @sprites["Item_1_name"].x=140
    @sprites["Item_1_name"].y=110
    
    @sprites["Item_2"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2"].setBitmap("Graphics/Pictures/ItemCrafter/ItemR_BG")
    @sprites["Item_2"].x=65
    @sprites["Item_2"].y=185
    
    @sprites["Item_2_icon"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2_icon"].setBitmap((@mat2!=-1) ? pbItemIconFile(getID(PBItems,@mat2)) : "")
    @sprites["Item_2_icon"].x=65+10
    @sprites["Item_2_icon"].y=185+10
    @sprites["Item_2_icon"].opacity=0
    
    @sprites["Item_2_name"]=IconSprite.new(0,0,@viewport)    
    @sprites["Item_2_name"].setBitmap("Graphics/Pictures/ItemCrafter/Item_Name")
    @sprites["Item_2_name"].x=140
    @sprites["Item_2_name"].y=198
    
    @sprites["Confirm"]=IconSprite.new(0,0,@viewport)    
    @sprites["Confirm"].setBitmap("Graphics/Pictures/ItemCrafter/Selection")
    @sprites["Confirm"].x=115
    @sprites["Confirm"].y=280
    
    @sprites["Confirm_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Confirm_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/Selection_1")
    @sprites["Confirm_Hov"].x=115
    @sprites["Confirm_Hov"].y=280
    @sprites["Confirm_Hov"].opacity=0
    
    @sprites["Cancel"]=IconSprite.new(0,0,@viewport)    
    @sprites["Cancel"].setBitmap("Graphics/Pictures/ItemCrafter/Selection")
    @sprites["Cancel"].x=115
    @sprites["Cancel"].y=330
    
    @sprites["Cancel_Hov"]=IconSprite.new(0,0,@viewport)    
    @sprites["Cancel_Hov"].setBitmap("Graphics/Pictures/ItemCrafter/Selection_1")
    @sprites["Cancel_Hov"].x=115
    @sprites["Cancel_Hov"].y=330

    @sprites["overlay"]=BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    
    self.openCauldscene
  end
  
  def openCauldscene
    self.CheckAbleToCraft
    pbFadeInAndShow(@sprites) {self.text}
    self.input
    self.action
  end
  
  def closeCauldscene
    pbFadeOutAndHide(@sprites)  
  end
    
    def input
      case @select
      when 1
        @sprites["Confirm"].opacity=255
        @sprites["Confirm_Hov"].opacity=0
        @sprites["Cancel"].opacity=0
        @sprites["Cancel_Hov"].opacity=255
        @sprites["Item"].opacity=255
        @sprites["Item_Hov"].opacity=0
      when 2
        @sprites["Confirm"].opacity=0
        @sprites["Confirm_Hov"].opacity=255
        @sprites["Cancel"].opacity=255
        @sprites["Cancel_Hov"].opacity=0
        @sprites["Item"].opacity=255
        @sprites["Item_Hov"].opacity=0
      when 3
        @sprites["Confirm"].opacity=255
        @sprites["Confirm_Hov"].opacity=0
        @sprites["Cancel"].opacity=255
        @sprites["Cancel_Hov"].opacity=0
        @sprites["Item"].opacity=0
        @sprites["Item_Hov"].opacity=255
        @sprites["Item_icon"].setBitmap(pbItemIconFile(getID(PBItems,RECIPECAUL[@item][0])))
        if $game_variables[CRAFTVAR][@item]
            @sprites["unknown"].opacity=0
            @sprites["Item_icon"].opacity=255
            @sprites["Item_1_icon"].setBitmap(RECIPECAUL[@item][2]? pbItemIconFile(getID(PBItems,RECIPECAUL[@item][2][0])) : "") # Vendily
            @sprites["Item_2_icon"].setBitmap(RECIPECAUL[@item][3]? pbItemIconFile(getID(PBItems,RECIPECAUL[@item][3][0])) : "") # Vendily
            @sprites["Item_1_icon"].opacity= RECIPECAUL[@item][2] ? 255 : 0
            @sprites["Item_2_icon"].opacity=RECIPECAUL[@item][3] ? 255 : 0
            @mat1=RECIPECAUL[@item][2]? RECIPECAUL[@item][2][0] : -1
            @mat2=RECIPECAUL[@item][3]? RECIPECAUL[@item][3][0] : -1
            @cost1=RECIPECAUL[@item][2]? RECIPECAUL[@item][2][1] : 0
            @cost2=RECIPECAUL[@item][3]? RECIPECAUL[@item][3][1] : 0
            @amount=RECIPECAUL[@item][1]
          else
            @sprites["unknown"].opacity=255
            @sprites["Item_icon"].opacity=0
            @sprites["Item_1_icon"].opacity=0
            @sprites["Item_2_icon"].opacity=0
          end
          self.text
          
        # When pressing Right
        if Input.trigger?(Input::RIGHT)  && @item < RECIPECAUL.length-1
          @item+=1
        elsif Input.trigger?(Input::RIGHT)  && @item ==RECIPECAUL.length-1 # Make it run though the selection after last item.
          @item = 0
        end
        if Input.trigger?(Input::LEFT) && @item >0
          @item-=1
        elsif Input.trigger?(Input::LEFT) && @item ==0 # Make it run though the selection after first item.
          @item = RECIPECAUL.length-1
        end
      end    
      # When pressing Left.
      if Input.trigger?(Input::UP)  && @select <3
        @select+=1
      end
      if Input.trigger?(Input::DOWN) && @select >1
        @select-=1
      end
      
      if Input.trigger?(Input::C) 
        case @select
        when 2 
          if $game_variables[CRAFTVAR][@item]
            if $PokemonBag.pbQuantity(@mat1)<@cost1 || (@mat2!=-1 && $PokemonBag.pbQuantity(@mat2) <@cost2) #Seth Edited 
              Kernel.pbMessage(_INTL("Unable to craft item, you do not meet the required materials."))
            else
              $PokemonBag.pbStoreItem(RECIPECAUL[@item][0],@amount)
              $PokemonBag.pbDeleteItem(@mat1,@cost1)
              if @mat2!=-1
                $PokemonBag.pbDeleteItem(@mat2,@cost2)
              end
              self.text
              Kernel.pbMessage(_INTL("{1} {2}'s were crafted.", @amount, PBItems.getName(getID(PBItems,RECIPECAUL[@item][0]))))
            end
          else
            Kernel.pbMessage(_INTL("You do not know this items recipe.."))
          end
        when 1
          @close=@select
          self.closeCauldscene
        end       
      end
      
      if Input.trigger?(Input::B)
        @close=@select
        self.closeCauldscene  
      end
      
    end
    
  def action
    while @close==0
      Graphics.update
      Input.update
      self.input
    end
  end
  
  def text
    overlay= @sprites["overlay"].bitmap
    overlay.clear
    baseColor=Color.new(255, 255, 255)
    shadowColor=Color.new(0,0,0)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    textos=[]
    if $game_variables[CRAFTVAR][@item]
      @text1=_INTL("{1}/{2} - {3}", $PokemonBag.pbQuantity(@mat1),@cost1, PBItems.getName(getID(PBItems,@mat1)))
      if @mat2==-1
        @text2=_INTL("")
      else
        @text2=_INTL("{1}/{2} - {3}", $PokemonBag.pbQuantity(@mat2),@cost2 , PBItems.getName(getID(PBItems,@mat2)))
      end
    else
      @text1=_INTL("UNKNOWN")
      @text2=_INTL("UNKNOWN")
    end
    @text3=_INTL("{1} / {2}", @item + 1, RECIPECAUL.length)
    textos.push([@text1,175,115,false,baseColor,shadowColor])
    textos.push([@text2,175,198+5,false,baseColor,shadowColor])
    textos.push([@text3,75,30,false,baseColor,shadowColor])
    textos.push(["Craft",230,280+5,false,baseColor,shadowColor])
    textos.push(["Cancel",230,330+5,false,baseColor,shadowColor])
    pbDrawTextPositions(overlay,textos)
  end
  
  def CheckAbleToCraft
    if $game_variables[CRAFTVAR][0]
      @sprites["Item_icon"].opacity=255
      @sprites["Item_1_icon"].opacity=255
      @sprites["unknown"].opacity=0
    else
      @sprites["Item_icon"].opacity=0
      @sprites["Item_1_icon"].opacity=0
      @sprites["unknown"].opacity=255
    end
  end
  
    
end