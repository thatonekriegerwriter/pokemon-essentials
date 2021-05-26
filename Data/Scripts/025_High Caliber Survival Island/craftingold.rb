###---craftS
class Crafts_Scene
#################################
## Configuration
  craftNAMEBASECOLOR=Color.new(88,88,80)
  craftNAMESHADOWCOLOR=Color.new(168,184,184)
#################################
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def pbStartScene(selection)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @quant=1
    @currentArray=0
    @returnItem=0
    @itemA=0
    @itemB=0
    @itemC=0
    @sprites={}
    @icons={}
    @required=[]
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/craftingPage")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=100
    @selectY=168
    @achList=CraftsList.getcrafts
    for i in 0..@achList.length
      if $game_switches[(i+100)]==true
        #@imagepos.push(["Graphics/Pictures/craft#{i}",32+64*(coord%7),36+64*(coord/7).floor,
        #     0,0,48,48])
        #coord+=1
      elsif $game_switches[(i+100)]==false
        #@imagepos.push(["Graphics/Pictures/craftEmpty",32+64*(coord%7),36+64*(coord/7).floor,
        #     0,0,48,48])
        #coord+=1
      break if coord>=2
      end
    end
    @sprites["quant"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantA"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantB"]=Window_UnformattedTextPokemon.new("")
    @sprites["quantC"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftA"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftB"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftC"]=Window_UnformattedTextPokemon.new("")
    @sprites["craftResult"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["quant"])
    @sprites["quant"].x=356
    @sprites["quant"].y=224
    @sprites["quant"].width=Graphics.width-48
    @sprites["quant"].height=Graphics.height
    @sprites["quant"].baseColor=Color.new(240,240,240)
    @sprites["quant"].shadowColor=Color.new(40,40,40)
    @sprites["quant"].visible=true
    @sprites["quant"].viewport=@viewport
    @sprites["quant"].windowskin=nil
    pbPrepareWindow(@sprites["quantA"])
    @sprites["quantA"].x=112
    @sprites["quantA"].y=224
    @sprites["quantA"].width=Graphics.width-48
    @sprites["quantA"].height=Graphics.height
    @sprites["quantA"].baseColor=Color.new(160,160,160)
    @sprites["quantA"].shadowColor=Color.new(40,40,40)
    @sprites["quantA"].visible=true
    @sprites["quantA"].viewport=@viewport
    @sprites["quantA"].windowskin=nil
    pbPrepareWindow(@sprites["quantB"])
    @sprites["quantB"].x=172
    @sprites["quantB"].y=224
    @sprites["quantB"].width=Graphics.width-48
    @sprites["quantB"].height=Graphics.height
    @sprites["quantB"].baseColor=Color.new(160,160,160)
    @sprites["quantB"].shadowColor=Color.new(40,40,40)
    @sprites["quantB"].visible=true
    @sprites["quantB"].viewport=@viewport
    @sprites["quantB"].windowskin=nil
    pbPrepareWindow(@sprites["quantC"])
    @sprites["quantC"].x=236
    @sprites["quantC"].y=224
    @sprites["quantC"].width=Graphics.width-48
    @sprites["quantC"].height=Graphics.height
    @sprites["quantC"].baseColor=Color.new(160,160,160)
    @sprites["quantC"].shadowColor=Color.new(40,40,40)
    @sprites["quantC"].visible=true
    @sprites["quantC"].viewport=@viewport
    @sprites["quantC"].windowskin=nil
    pbPrepareWindow(@sprites["craftResult"])
    @sprites["craftResult"].x=30
    @sprites["craftResult"].y=294
    @sprites["craftResult"].width=Graphics.width-48
    @sprites["craftResult"].height=Graphics.height
    @sprites["craftResult"].baseColor=Color.new(0,0,0)
    @sprites["craftResult"].shadowColor=Color.new(160,160,160)
    @sprites["craftResult"].visible=true
    @sprites["craftResult"].viewport=@viewport
    @sprites["craftResult"].windowskin=nil
    @sprites["selector"]=IconSprite.new(@selectX,@selectY,@viewport)
    @sprites["selector"].setBitmap("Graphics/Pictures/craftSelect")
    
    filenamA=sprintf("Graphics/Icons/item%03d",@itemA)
    @icons["itemA"]=IconSprite.new(100,168,@viewport)
    @icons["itemA"].setBitmap(filenamA)
    
    filenamB=sprintf("Graphics/Icons/item%03d",@itemB)
    @icons["itemB"]=IconSprite.new(164,168,@viewport)
    @icons["itemB"].setBitmap(filenamB)
    
    filenamC=sprintf("Graphics/Icons/item%03d",@itemC)
    @icons["itemC"]=IconSprite.new(228,168,@viewport)
    @icons["itemC"].setBitmap(filenamC)
    
    filenamD=sprintf("Graphics/Icons/item%03d",@returnItem)
    @icons["itemResult"]=IconSprite.new(356,168,@viewport)
    @icons["itemResult"].setBitmap(filenamD)
    
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbRefresh
    #@sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
  end
  
  def pbConvert(item)
    if item==0
      return 0
    else
      getID(PBItems,item)
    end
  end
  
# Script that manages button inputs  
  def pbSelectcraft
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    @returnItem=0
    @itemA=0
    @itemB=0
    @itemC=0
    @quantA=0
    @quantB=0
    @quantC=0
    while true
    Graphics.update
      Input.update
      self.update
      @sprites["selector"].x=@selectX
      @sprites["selector"].y=@selectY
      
      filenamA=sprintf("Graphics/Icons/item%03d",@itemA)
      @icons["itemA"].setBitmap(filenamA)
      
      filenamB=sprintf("Graphics/Icons/item%03d",@itemB)
      @icons["itemB"].setBitmap(filenamB)
      
      filenamC=sprintf("Graphics/Icons/item%03d",@itemC)
      @icons["itemC"].setBitmap(filenamC)
      
      filenamD=sprintf("Graphics/Icons/item%03d",@returnItem)
      @icons["itemResult"].setBitmap(filenamD)
      
      selectionNum=@selection
      if @currentArray!=0
        @craftA=PBItems.getName(CraftsList.getcrafts[@currentArray][1])
        @craftB=PBItems.getName(CraftsList.getcrafts[@currentArray][2])
        @craftC=PBItems.getName(CraftsList.getcrafts[@currentArray][3])
        @craftResult=PBItems.getName(CraftsList.getcrafts[@currentArray][0])
      else
        @craftA=0
        @craftB=0
        @craftC=0
        @craftResult=0
      end
      @sprites["quant"].text=_INTL("{1}",@quant)
      @sprites["quantA"].text=_INTL("{1}",@quantA)
      @sprites["quantB"].text=_INTL("{1}",@quantB)
      @sprites["quantC"].text=_INTL("{1}",@quantC)
      if @craftA==0
        @sprites["craftResult"].text=_INTL("No items selected.")
      elsif @craftA!=0 && @craftResult==0
        @sprites["craftResult"].text=_INTL("Incorrect crafting recipe.")
      elsif CraftsList.getcrafts[@currentArray][2]==0
        @sprites["craftResult"].text=_INTL("{1} = {2}",@craftA,@craftResult)
      elsif CraftsList.getcrafts[@currentArray][3]==0
        @sprites["craftResult"].text=_INTL("{1} + {2} = {3}",@craftA,@craftB,@craftResult)
      else
        @sprites["craftResult"].text=_INTL("{1} + {2} + {3} = {4}",@craftA,@craftB,@craftC,@craftResult)
      end
      if Input.trigger?(Input::LEFT)
        if @selection==0
          @selectX=356
          @selection+=3
        elsif @selection==3
          @selectX=228
          @selection=2
        else
          @selectX-=64
          @selection-=1
        end
      elsif Input.trigger?(Input::RIGHT)
        if @selection==3
          @selectX=100
          @selection-=3
        elsif @selection==2
          @selectX=356
          @selection=3
        else
          @selectX+=64
          @selection+=1
        end
      end
      if Input.trigger?(Input::UP)
        if @quant>99
          @quant=1
        else
          @quant+=1
        end
      end
      if Input.trigger?(Input::DOWN)
        if @quant==1
          @quant=100
        else
          @quant-=1
        end
      end
      if Input.trigger?(Input::C)
        if @selection==3 && @returnItem!=0
          if CraftsList.getcrafts[@currentArray][2]==0 #If slot 2 is empty, don't read it
            if $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][1])>=@quant
              #if CraftsList.getcrafts[@currentArray][1]==@itemA
                @recipe=[@returnItem,@itemA,0,0]
                if pbCheckRecipe(@recipe)
                  Kernel.pbReceiveItem(@returnItem,@quant)
                  $PokemonBag.pbDeleteItem(@itemA,@quant)
                  @itemA=0
                  @returnItem=0
                  @quant=1
                  @quantA=0
                  @quantB=0
                  @quantC=0
                end
              #end
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items!"))
            end
          elsif CraftsList.getcrafts[@currentArray][3]==0&&CraftsList.getcrafts[@currentArray][2]!=0
            if $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][1])>=@quant &&
              $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][2])>=@quant
                Kernel.pbReceiveItem(@returnItem,@quant)
                $PokemonBag.pbDeleteItem(@itemA,@quant)
                $PokemonBag.pbDeleteItem(@itemB,@quant)
                @itemA=0
                @itemB=0
                @returnItem=0
                @quant=1
                @quantA=0
                @quantB=0
                @quantC=0
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items!"))
            end
          else
            if $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][1])>=@quant &&
            $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][2])>=@quant &&
            $PokemonBag.pbQuantity(CraftsList.getcrafts[@currentArray][3])>=@quant
              Kernel.pbReceiveItem(@returnItem,@quant)
              $PokemonBag.pbDeleteItem(@itemA,@quant)
              $PokemonBag.pbDeleteItem(@itemB,@quant)
              $PokemonBag.pbDeleteItem(@itemC,@quant)
              @itemA=0
              @itemB=0
              @itemC=0
              @returnItem=0
              @quant=1
              @quantA=0
              @quantB=0
              @quantC=0
            else
              Kernel.pbMessage(_INTL("You don't have the ingredients to craft this many items!"))
            end
          end
        elsif @selection==0
          @returnItem=0
          @itemA=Kernel.pbChooseItem
          for i in 0..45
            if CraftsList.getcrafts[i][1]==@itemA &&
            CraftsList.getcrafts[i][2]==@itemB &&
            CraftsList.getcrafts[i][3]==@itemC
              @currentArray=i
              @returnItem=CraftsList.getcrafts[i][0]
              @required[1]=CraftsList.getcrafts[i][1]
            end
            if CraftsList.getcrafts[i][2]!=@itemB && @itemB==0
              @itemB=0
              @quantB=0
            end
            if CraftsList.getcrafts[i][2]!=@itemC && @itemC==0
              @itemC=0
              @quantC=0
            end
          end
          
        elsif @selection==1
          @returnItem=0
          @itemB=Kernel.pbChooseItem
          for i in 0..45
            if CraftsList.getcrafts[i][1]==@itemA &&
            CraftsList.getcrafts[i][2]==@itemB &&
            CraftsList.getcrafts[i][3]==@itemC
              @currentArray=i
              @returnItem=CraftsList.getcrafts[i][0]
              @required[2]=CraftsList.getcrafts[i][2]
            end
            if CraftsList.getcrafts[i][2]!=@itemA && @itemA==0
              @itemA=0
              @quantA=0
            end
            if CraftsList.getcrafts[i][2]!=@itemC && @itemC==0
              @itemC=0
              @quantC=0
            end
          end

        elsif @selection==2
          @returnItem=0
          @itemC=Kernel.pbChooseItem
          for i in 0..45
            if CraftsList.getcrafts[i][1]==@itemA &&
            CraftsList.getcrafts[i][2]==@itemB &&
            CraftsList.getcrafts[i][3]==@itemC
              @currentArray=i
              @returnItem=CraftsList.getcrafts[i][0]
              @required[3]=CraftsList.getcrafts[i][3]
            end
            if CraftsList.getcrafts[i][2]!=@itemA && @itemA==0
              @itemA=0
              @quantA=0
            end
            if CraftsList.getcrafts[i][2]!=@itemB && @itemB==0
              @itemB=0
              @quantB=0
            end
          end
        else
          Kernel.pbMessage(_INTL("You must first select an item!"))
        end
        @quantA=$PokemonBag.pbQuantity(@itemA)
        @quantB=$PokemonBag.pbQuantity(@itemB)
        @quantC=$PokemonBag.pbQuantity(@itemC)
      end
       #Cancel
      if Input.trigger?(Input::B)
        return -1
      end     
    end
  end
  
  def pbCheckRecipe(recipe)
    for i in 0..45
      if recipe[1]==CraftsList.getcrafts[i][1] &&
         recipe[2]==CraftsList.getcrafts[i][2] &&
         recipe[3]==CraftsList.getcrafts[i][3]
       return true
      end
    end
   return false
   Kernel.pbMessage(_INTL("Nope! {1}",recipe[0]))
  end
  
end



class PokemoncraftSelect
  attr_accessor :lastcraft
  attr_reader :crafts
  def numChars()
    return Crafts_Scene.CraftsList().length-1
  end
  def initialize
    @lastcraft=1
    @crafts=[]
    @choices=[]
    # Initialize each playerCharacter of the array
    for i in 0..Crafts_Scene.CraftsList
      @crafts[i]=[]
      @choices[i]=0
    end
  end
  def crafts
    rearrange()
    return @crafts
  end

  def rearrange()
    if @crafts.length==6 && Crafts_Scene.CraftsList==28
      newcrafts=[]
      for i in 0..28
        newcrafts[i]=[]
        @choices[i]=0 if !@choices[i]
      end
      @crafts=newcrafts
    end
  end
end

module CraftsList
  def self.getcrafts
    empty=0
    @CraftsList=[
    [0,0,0,0], #Empty
    #RECIPE 1: 
	#Spelon Curry (ATK) =BOWL,SPELON,LIECHI
    [1826,1834,419,441],     
    [1826,1834,441,419],   
    [1826,419,1834,441],      
    [1826,419,441,1834],   
    [1826,441,419,1834], 
    [1826,441,1834,419], 
    #RECIPE 2:
	#Kelpsy Curry (S. ATK)=BOWL,KELPSY,PETAYABERRY 
    [1827,1834,410,444],    
    [1827,1834,444,410],   
    [1827,444,1834,410],   
    [1827,444,1834,410],    
    [1827,410,444,1834], 
    [1827,410,1834,444], 
    #RECIPE 3:
	#Watmel Curry (SPD)=BOWL,WATMEL,SALACBERRY
    [1828,1834,421,443],    
    [1828,1834,443,421],   
    [1828,443,1834,421],   
    [1828,443,421,1834],   
    [1828,421,443,1834],   
    [1828,421,1834,443],   
    #RECIPE 4:
	#Durin Curry (S. DEF)=BOWL,DURIN,APICOTBERRY
    [1829,1834,422,445],  
    [1829,1834,445,422],  
    [1829,445,1834,422],  
    [1829,445,422,1834],   
    [1829,422,445,1834],   
    [1829,422,1834,445],    
    #RECIPE 5:
	#Micle Curry (ACC)=BOWL,MICLEBERRY,PAMTREBERRY
    [1830,1834,449,420],  
    [1830,1834,420,449], 
    [1830,420,1834,449], 
    [1830,420,449,1834], 
    [1830,449,420,1834], 
    [1830,449,1834,420], 
    #RECIPE 6:
    #Belue Curry (DEF)=BOWL,BELUEBERRY,HONDEWBERRY 
    [1831,1834,423,412],
    [1831,1834,412,423],
    [1831,412,1834,423],
    [1831,412,423,1834],
    [1831,423,412,1834],
    [1831,423,1834,412],
    #RECIPE 7:
    #Lansat Curry (CRIT)=BOWL,LANSATBERRY,RAZZBERRY 
    [1832,1834,446,404],
    [1832,1834,404,446],
    [1832,446,1834,404],
    [1832,446,404,1834],
    [1832,404,446,1834],
    [1832,404,1834,446],
    #RECIPE 8:
    #Starf Curry (Prevent Stat Reduction)=BOWL,STARFBERRY,NANABBERRY 
    [1833,1834,447,406],    
    [1833,1834,406,447],  
    [1833,447,1834,406],  
    [1833,447,406,1834],  
    [1833,406,1834,447],  
    [1833,406,447,1834],
    #RECIPE 9:
    #CHOCOLATE =BOWL,SUGAR,COCOABEANS 
    [1904,1903,1905],    
    [1904,1905,1903],
    #RECIPE 10:
    #BREAD =WHEAT,WHEAT,WHEAT 
    [1918,1916,1916,1916],    
    #RECIPE 11:
    #TEA =FRESHWATER,TEALEAF 
    [1919,237,1917],    
    [1919,1917,237],  
    #RECIPE 12:
    #SWEETHEART =BOWL,SUGAR,COCOABEANS 
    [236,1904,1905],    
    [236,1905,1904],
    #RECIPE 13:
    #CARROTCAKE =BOWL,SUGAR,COCOABEANS 
    [1921,1915,1905,240],    
    [1921,1915,240,1905],  
    [1921,240,1915,1905],  
    [1921,240,1905,1915],  
    [1921,1905,240,1915],  
    [1921,1905,1915,240],  
    #RECIPE 14:
    #LEMONADE =LEMON,SUGAR,WATERBOTTLE 
    [1921,1895,1905,1711],    
    [1921,1895,1711,1905],  
    [1921,1711,1895,1905],  
    [1921,1711,1905,1895],  
    [1921,1905,1711,1895],  
    [1921,1905,1895,1711],  
    ]
    return @CraftsList
  end
end

#Call Crafts.craftWindow
module Crafts  
  def self.craftWindow()
  craftScene=Crafts_Scene.new
  craftScene.pbStartScene($PokemoncraftSelect)
  craft=craftScene.pbSelectcraft
  craftScene.pbEndScene
 end
end