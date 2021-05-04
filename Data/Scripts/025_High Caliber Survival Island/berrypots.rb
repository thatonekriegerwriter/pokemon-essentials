################################################################################
# "BerryPots for Essentials"
# By Caruban
#-------------------------------------------------------------------------------
# Run with:      pbBerryPots
#
# item BerryPots for PBS (change the xxx to the new number in items.txt)
# xxx,BERRYPOTS,Berry Pots,Berry Pots,8,0,"Handy containers for cultivating Berries wherever you go.",2,0,6,
################################################################################
begin
PluginManager.register({
  :name    => "BerryPots for Essentials",
  :version => "1.0",
  :link    => "https://reliccastle.com/resources/458/",
  :credits => "Caruban"
})
rescue
  raise "This script only funtions in v18."
end


#===============================================================================
# SETTINGS
#===============================================================================

# WateringCan items array
WATERINGCAN=[getConst(PBItems,:SPRAYDUCK),
             getConst(PBItems,:SQUIRTBOTTLE),
             getConst(PBItems,:WAILMERPAIL),
             getConst(PBItems,:SPRINKLOTAD)
            ]
            
# Maximum times for berry to replant itself
REPLANTS  = 9 

#===============================================================================
# PokemonGlobalMetadata
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :berrypots
end            

#===============================================================================
# Pots Scene
#===============================================================================

def pbBerryPots
  pbFadeOutIn{
    scene = ItemBerryPots_Scene.new
    screen = ItemBerryPots_Screen.new(scene)
    ret = screen.pbStartScreen
  }
end
  
class ItemBerryPots_Screen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret
  end
end

class ItemBerryPots_Scene
  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @index = 0
    @frame = 0
    @anim = 0
    $PokemonGlobal.berrypots=[] if !$PokemonGlobal.berrypots
    @berryData=$PokemonGlobal.berrypots
    for i in 0..3
      @berryData[i] = pbUpdatePlantDetailsVar(@berryData[i])
    end
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/BerryPots/bg_pot"))
    @sprites["cursor"] = IconSprite.new(24,166,@viewport)
    @sprites["cursor"].setBitmap(_INTL("Graphics/Pictures/BerryPots/cursor-anim"))
    @sprites["cursor"].src_rect = Rect.new(0,0,64,64)
    
    for i in 0..3
      @sprites["soil#{i}"] = IconSprite.new(38 + 54*i,182,@viewport)
      @sprites["soil#{i}"].setBitmap(_INTL("Graphics/Characters/berrytreeDry"))
      
      @sprites["plant#{i}"] = IconSprite.new(70,102,@viewport)
      @sprites["plant#{i}"].setBitmap("Graphics/Characters/berrytreeplanted")
      charwidth  = @sprites["plant#{i}"].bitmap.width
      charheight = @sprites["plant#{i}"].bitmap.height
      @sprites["plant#{i}"].x = (54-charwidth/8) + 54*i
      @sprites["plant#{i}"].y = 172-charheight/8
      @sprites["plant#{i}"].src_rect = Rect.new(0,charheight*3/4,charwidth/4,charheight/4)
    end
    watering=WATERINGCAN
    @item = "squirtbottle"
    for i in watering
      @item = PBItems.getName(i) if $PokemonBag.pbHasItem?(i)
    end
    @sprites["spray"] = IconSprite.new(24,80,@viewport)
    @sprites["spray"].setBitmap(_INTL("Graphics/Pictures/BerryPots/#{@item}-stop"))
    @sprites["spray"].visible = false
    
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport) 
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
  def pbUpdateCursor
    @sprites["cursor"].x = 24 + 54*@index
    @sprites["cursor"].y = 166
  end

  def pbUpdate
    for i in 0..3
      pbUpdateSoilSprite(@berryData[i],i)
      pbUpdatePlantSprite(@berryData[i],i)
    end
    pbUpdateAnim
    pbUpdateCursor
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbUpdateSoilSprite(berryData,i)
    #oldmoisture=-1
    newmoisture=-1
    if berryData && berryData.length>6 && berryData[1]>0
    # Berry was planted, show moisture patch
      newmoisture=(berryData[4]>50) ? 2 : (berryData[4]>0) ? 1 : 0
    end
    case newmoisture
    when -1; @sprites["soil#{i}"].setBitmap("")
    when 0; @sprites["soil#{i}"].setBitmap("Graphics/Characters/berrytreeDry")
    when 1; @sprites["soil#{i}"].setBitmap("Graphics/Characters/berrytreeDamp")
    when 2; @sprites["soil#{i}"].setBitmap("Graphics/Characters/berrytreeWet")
    end
  end
  
  def pbUpdatePlantSprite(berryData,i)
    if !berryData || berryData==0 || berryData==[]
      if NEW_BERRY_PLANTS
        berryData=[0,0,0,0,0,0,0,0]
      else
        berryData=[0,0,false,0,0,0]
      end
    end
    case berryData[0]
    when 0 ; nama=""
    when 1 ; nama="berrytreeplanted"
    else
      filename=sprintf("berrytree%s",getConstantName(PBItems,berryData[1])) rescue nil
      filename=sprintf("berrytree%03d",berryData[1]) if !pbResolveBitmap("Graphics/Characters/"+filename)
      if pbResolveBitmap("Graphics/Characters/"+filename)
        nama=filename
      else
        nama="Object ball"
      end
    end
    @sprites["plant#{i}"].setBitmap("Graphics/Characters/#{nama}")
    charwidth  = @sprites["plant#{i}"].bitmap.width
    charheight = @sprites["plant#{i}"].bitmap.height
    if berryData[0]>1
      @sprites["plant#{i}"].src_rect = Rect.new(0,charheight*(berryData[0]-2)/4,charwidth/4,charheight/4)
    else
      @sprites["plant#{i}"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)
    end
  end
  
    
  def pbWateringAnim(i)
    @sprites["spray"].x = 24 + 54*i
    @sprites["spray"].visible = true
    charwidth  = @sprites["spray"].bitmap.width
    charheight = @sprites["spray"].bitmap.height
    frame=0 ; anim=0
    animtree = @anim
    charwidthtree  = @sprites["plant#{i}"].bitmap.width
    charwidthcursor  = @sprites["cursor"].bitmap.width
    loop do
      if frame == 10
        @sprites["spray"].setBitmap("Graphics/Pictures/BerryPots/#{@item}-play")
        @sprites["spray"].src_rect = Rect.new(0,0,charwidth,charheight)
      end
      if frame>10 && frame<80
        anim += 1 if frame%10==0
        anim = 0 if anim > 1
        @sprites["spray"].src_rect.x = charwidth*anim
        pbSEPlay("Anim/sand",50,120) if anim == 1
      end
      if frame == 80
        @sprites["spray"].setBitmap("Graphics/Pictures/BerryPots/#{@item}-stop")
        @sprites["spray"].src_rect = Rect.new(0,0,charwidth,charheight)
      end
      # anim tree
      animtree += 1 if frame%10==0
      animtree=0 if animtree>3
      for i in 0..3
        @sprites["plant#{i}"].src_rect.x = charwidthtree*animtree/4
      end
      # anim cursor
      @sprites["cursor"].src_rect.x = charwidthcursor*(@anim%2)/2
      pbWait(1)
      break if frame == 90
      frame += 1
    end
    @anim = animtree
    @sprites["spray"].visible = false
  end
  
  def pbUpdateAnim
    @frame +=1
    if @frame>10
      @frame=0
      @anim+=1
      @anim=0 if @anim>3
    end
    for i in 0..3
      charwidth  = @sprites["plant#{i}"].bitmap.width
      @sprites["plant#{i}"].src_rect.x = charwidth*@anim/4
        #@sprites["plant#{i}"].src_rect.x = 0 if @sprites["plant#{i}"].src_rect.x >= charwidth
    end
    charwidthcursor  = @sprites["cursor"].bitmap.width
    @sprites["cursor"].src_rect.x = charwidthcursor*(@anim%2)/2
  end
  
  def pbScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::C)
        pbPlayDecisionSE
        pbBerryPlantVar(@index)
      elsif Input.trigger?(Input::B)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::UP)
      elsif Input.trigger?(Input::DOWN)
      elsif Input.trigger?(Input::LEFT)
        @index -= 1
        @index = 3 if @index < 0
        pbSEPlay("GUI sel cursor",80)
      elsif Input.trigger?(Input::RIGHT)
        @index += 1
        @index = 0 if @index > 3
        pbSEPlay("GUI sel cursor",80)
      end
    end
    return @index
  end
  
  def pbBerryPlantVar(idx)
    #interp=pbMapInterpreter
    #thisEvent=interp.get_character(0)
    berryData=$PokemonGlobal.berrypots[idx]
    if !berryData || berryData==0 || berryData==[]
      if NEW_BERRY_PLANTS
        berryData=[0,0,0,0,0,0,0,0]
      else
        berryData=[0,0,false,0,0,0]
      end
    end
    berryData=pbUpdatePlantDetailsVar(berryData) if berryData.length>6
    watering=WATERINGCAN
    berry=berryData[1]
    case berryData[0]
    when 0  # empty
      if NEW_BERRY_PLANTS
        # Gen 4 planting mechanics
        if !berryData[7] || berryData[7]==0 # No mulch used yet
          cmd=pbMessage(_INTL("It's soft, earthy soil."),[
                              _INTL("Fertilize"),
                              _INTL("Plant Berry"),
                              _INTL("Exit")],-1)
          if cmd==0 # Fertilize
            ret=0
            pbFadeOutIn {
              scene = PokemonBag_Scene.new
              screen = PokemonBagScreen.new(scene,$PokemonBag)
              ret = screen.pbChooseItemScreen(Proc.new { |item| pbIsMulch?(item) })
            }
            if ret>0
              if pbIsMulch?(ret)
                berryData[7]=ret
                pbMessage(_INTL("The {1} was scattered on the soil.\1",PBItems.getName(ret)))
                if pbConfirmMessage(_INTL("Want to plant a Berry?"))
                  pbFadeOutIn {
                    scene = PokemonBag_Scene.new
                    screen = PokemonBagScreen.new(scene,$PokemonBag)
                    berry = screen.pbChooseItemScreen(Proc.new { |item| pbIsBerry?(item) })
                  }
                  if berry>0
                    timenow=pbGetTimeNow
                    berryData[0]=1             # growth stage (1-5)
                    berryData[1]=berry         # item ID of planted berry
                    berryData[2]=0             # seconds alive
                    berryData[3]=timenow.to_i  # time of last checkup (now)
                    berryData[4]=100           # dampness value
                    berryData[5]=0             # number of replants
                    berryData[6]=0             # yield penalty
                    $PokemonBag.pbDeleteItem(berry,1)
                    pbMessage(_INTL("The {1} was planted in the soft, earthy soil.",
                       PBItems.getName(berry)))
                  end
                end
                #interp.setVariable(berryData)
                $PokemonGlobal.berrypots[idx] = berryData
              else
                pbMessage(_INTL("That won't fertilize the soil!"))
              end
              return
            end
          elsif cmd==1 # Plant Berry
            pbFadeOutIn {
              scene = PokemonBag_Scene.new
              screen = PokemonBagScreen.new(scene,$PokemonBag)
              berry = screen.pbChooseItemScreen(Proc.new { |item| pbIsBerry?(item) })
            }
            if berry>0
              timenow=pbGetTimeNow
              berryData[0]=1             # growth stage (1-5)
              berryData[1]=berry         # item ID of planted berry
              berryData[2]=0             # seconds alive
              berryData[3]=timenow.to_i  # time of last checkup (now)
              berryData[4]=100           # dampness value
              berryData[5]=0             # number of replants
              berryData[6]=0             # yield penalty
              $PokemonBag.pbDeleteItem(berry,1)
              pbMessage(_INTL("The {1} was planted in the soft, earthy soil.",
                 PBItems.getName(berry)))
              #interp.setVariable(berryData)
              $PokemonGlobal.berrypots[idx] = berryData
            end
            return
          end
        else
          pbMessage(_INTL("{1} has been laid down.\1",PBItems.getName(berryData[7])))
          if pbConfirmMessage(_INTL("Want to plant a Berry?"))
            pbFadeOutIn {
              scene = PokemonBag_Scene.new
              screen = PokemonBagScreen.new(scene,$PokemonBag)
              berry = screen.pbChooseItemScreen(Proc.new { |item| pbIsBerry?(item) })
            }
            if berry>0
              timenow=pbGetTimeNow
              berryData[0]=1             # growth stage (1-5)
              berryData[1]=berry         # item ID of planted berry
              berryData[2]=0             # seconds alive
              berryData[3]=timenow.to_i  # time of last checkup (now)
              berryData[4]=100           # dampness value
              berryData[5]=0             # number of replants
              berryData[6]=0             # yield penalty
              $PokemonBag.pbDeleteItem(berry,1)
              pbMessage(_INTL("The {1} was planted in the soft, earthy soil.",
                 PBItems.getName(berry)))
              #interp.setVariable(berryData)
              $PokemonGlobal.berrypots[idx] = berryData
            end
            return
          end
        end
      else
        # Gen 3 planting mechanics
        if pbConfirmMessage(_INTL("It's soft, loamy soil.\nPlant a berry?"))
          pbFadeOutIn {
            scene = PokemonBag_Scene.new
            screen = PokemonBagScreen.new(scene,$PokemonBag)
            berry = screen.pbChooseItemScreen(Proc.new { |item| pbIsBerry?(item) })
          }
          if berry>0
            timenow=pbGetTimeNow
            berryData[0]=1             # growth stage (1-5)
            berryData[1]=berry         # item ID of planted berry
            berryData[2]=false         # watered in this stage?
            berryData[3]=timenow.to_i  # time planted
            berryData[4]=0             # total waterings
            berryData[5]=0             # number of replants
            berryData[6]=nil; berryData[7]=nil; berryData.compact! # for compatibility
            $PokemonBag.pbDeleteItem(berry,1)
            pbMessage(_INTL("{1} planted a {2} in the soft loamy soil.",
               $Trainer.name,PBItems.getName(berry)))
            #interp.setVariable(berryData)
            $PokemonGlobal.berrypots[idx] = berryData
          end
          return
        end
      end
    when 1 # X planted
      pbMessage(_INTL("A {1} was planted here.",PBItems.getName(berry)))
    when 2  # X sprouted
      pbMessage(_INTL("The {1} has sprouted.",PBItems.getName(berry)))
    when 3  # X taller
      pbMessage(_INTL("The {1} plant is growing bigger.",PBItems.getName(berry)))
    when 4  # X flowering
      if NEW_BERRY_PLANTS
        pbMessage(_INTL("This {1} plant is in bloom!",PBItems.getName(berry)))
      else
        case berryData[4]
        when 4
          pbMessage(_INTL("This {1} plant is in fabulous bloom!",PBItems.getName(berry)))
        when 3
          pbMessage(_INTL("This {1} plant is blooming very beautifully!",PBItems.getName(berry)))
        when 2
          pbMessage(_INTL("This {1} plant is blooming prettily!",PBItems.getName(berry)))
        when 1
          pbMessage(_INTL("This {1} plant is blooming cutely!",PBItems.getName(berry)))
        else
          pbMessage(_INTL("This {1} plant is in bloom!",PBItems.getName(berry)))
        end
      end
    when 5  # X berries
      berryvalues=pbGetBerryPlantData(berryData[1])
      # Get berry yield (berrycount)
      berrycount=1
      if berryData.length>6
        # Gen 4 berry yield calculation
        berrycount=[berryvalues[3]-berryData[6],berryvalues[2]].max
      else
        # Gen 3 berry yield calculation
        if berryData[4]>0
          randomno=rand(1+berryvalues[3]-berryvalues[2])
          berrycount=(((berryvalues[3]-berryvalues[2])*(berryData[4]-1)+randomno)/4).floor+berryvalues[2]
        else
          berrycount=berryvalues[2]
        end
      end
      itemname=(berrycount>1) ? PBItems.getNamePlural(berry) : PBItems.getName(berry)
      if berrycount>1
        message=_INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?",berrycount,itemname)
      else
        message=_INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?",itemname)
      end
      if pbConfirmMessage(message)
        if !$PokemonBag.pbCanStore?(berry,berrycount)
          pbMessage(_INTL("Too bad...\nThe Bag is full..."))
          return
        end
        $PokemonBag.pbStoreItem(berry,berrycount)
        if berrycount>1
          pbMessage(_INTL("You picked the {1} \\c[1]{2}\\c[0].\\wtnp[30]",berrycount,itemname))
        else
          pbMessage(_INTL("You picked the \\c[1]{1}\\c[0].\\wtnp[30]",itemname))
        end
        pocket = pbGetPocket(berry)
        pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
           $Trainer.name,itemname,pocket,PokemonBag.pocketNames()[pocket]))
        if NEW_BERRY_PLANTS
          pbMessage(_INTL("The soil returned to its soft and earthy state."))
          berryData=[0,0,0,0,0,0,0,0]
        else
          pbMessage(_INTL("The soil returned to its soft and loamy state."))
          berryData=[0,0,false,0,0,0]
        end
        #interp.setVariable(berryData)
        $PokemonGlobal.berrypots[idx] = berryData
      end
    end
    case berryData[0]
    when 1, 2, 3, 4
      for i in watering
        if i !=0 && $PokemonBag.pbHasItem?(i)
          if pbConfirmMessage(_INTL("Want to sprinkle some water with the {1}?",PBItems.getName(i)))
            if berryData.length>6
              # Gen 4 berry watering mechanics
              berryData[4]=100
            else
              # Gen 3 berry watering mechanics
              if berryData[2]==false
                berryData[4]+=1
                berryData[2]=true
              end
            end
            #interp.setVariable(berryData)
            pbWateringAnim(idx)
            pbUpdateSoilSprite(berryData,idx)
            $PokemonGlobal.berrypots[idx] = berryData
            pbMessage(_INTL("{1} watered the plant.\\wtnp[40]",$Trainer.name))
            if NEW_BERRY_PLANTS
              pbMessage(_INTL("There! All happy!"))
            else
              pbMessage(_INTL("The plant seemed to be delighted."))
            end
          end
          break
        end
      end
    end
  end
  
  def pbUpdatePlantDetailsVar(berryData)
    if !berryData || berryData==0 || berryData==[]
      if NEW_BERRY_PLANTS
        berryData=[0,0,0,0,0,0,0,0]
      else
        berryData=[0,0,false,0,0,0]
      end
    end
    return berryData if berryData[0]==0
    berryvalues=pbGetBerryPlantData(berryData[1])
    timeperstage=berryvalues[0]*3600
    timenow=pbGetTimeNow
    if berryData.length>6
      # Gen 4 growth mechanisms
      # Check time elapsed since last check
      timeDiff=(timenow.to_i-berryData[3])   # in seconds
      return berryData if timeDiff<=0
      berryData[3]=timenow.to_i   # last updated now
      # Mulch modifiers
      dryingrate=berryvalues[1]
      maxreplants=REPLANTS
      ripestages=4
      if isConst?(berryData[7],PBItems,:GROWTHMULCH)
        timeperstage=(timeperstage*0.75).to_i
        dryingrate=(dryingrate*1.5).ceil
      elsif isConst?(berryData[7],PBItems,:DAMPMULCH)
        timeperstage=(timeperstage*1.25).to_i
        dryingrate=(dryingrate*0.5).floor
      elsif isConst?(berryData[7],PBItems,:GOOEYMULCH)
        maxreplants=(maxreplants*1.5).ceil
      elsif isConst?(berryData[7],PBItems,:STABLEMULCH)
        ripestages=6
      end
      # Cycle through all replants since last check
      loop do
        secondsalive=berryData[2]
        growinglife=(berryData[5]>0) ? 3 : 4 # number of growing stages
        numlifestages=growinglife+ripestages # number of growing + ripe stages
        # Should replant itself?
        if secondsalive+timeDiff>=timeperstage*numlifestages
          # Should replant
          if berryData[5]>=maxreplants   # Too many replants
            return [0,0,0,0,0,0,0,0]
          end
          # Replant
          berryData[0]=2   # replants start in sprouting stage
          berryData[2]=0   # seconds alive
          berryData[5]+=1  # add to replant count
          berryData[6]=0   # yield penalty
          timeDiff-=(timeperstage*numlifestages-secondsalive)
        else
          break
        end
      end
      # Update current stage and dampness
      if berryData[0]>0
        # Advance growth stage
        oldlifetime=berryData[2]
        newlifetime=oldlifetime+timeDiff
        if berryData[0]<5
          berryData[0]=1+(newlifetime/timeperstage).floor
          berryData[0]+=1 if berryData[5]>0   # replants start at stage 2
          berryData[0]=5 if berryData[0]>5
        end
        # Update the "seconds alive" counter
        berryData[2]=newlifetime
        # Reduce dampness, apply yield penalty if dry
        growinglife=(berryData[5]>0) ? 3 : 4 # number of growing stages
        oldhourtick=(oldlifetime/3600).floor
        newhourtick=(([newlifetime,timeperstage*growinglife].min)/3600).floor
        (newhourtick-oldhourtick).times do
          if berryData[4]>0
            berryData[4]=[berryData[4]-dryingrate,0].max
          else
            berryData[6]+=1
          end
        end
      end
    else
      # Gen 3 growth mechanics
      loop do
        if berryData[0]>0 && berryData[0]<5
          levels=0
          # Advance time
          timeDiff=(timenow.to_i-berryData[3]) # in seconds
          if timeDiff>=timeperstage
            levels+=1
            if timeDiff>=timeperstage*2
              levels+=1
              if timeDiff>=timeperstage*3
                levels+=1
                if timeDiff>=timeperstage*4
                  levels+=1
                end
              end
            end
          end
          levels=5-berryData[0] if levels>5-berryData[0]
          break if levels==0
          berryData[2]=false                  # not watered this stage
          berryData[3]+=levels*timeperstage   # add to time existed
          berryData[0]+=levels                # increase growth stage
          berryData[0]=5 if berryData[0]>5
        end
        if berryData[0]>=5
          # Advance time
          timeDiff=(timenow.to_i-berryData[3])   # in seconds
          if timeDiff>=timeperstage*4   # ripe for 4 times as long as a stage
            # Replant
            berryData[0]=2                      # replants start at stage 2
            berryData[2]=false                  # not watered this stage
            berryData[3]+=timeperstage*4        # add to time existed
            berryData[4]=0                      # reset total waterings count
            berryData[5]+=1                     # add to replanted count
            if berryData[5]>REPLANTS   # Too many replants
              berryData=[0,0,false,0,0,0]
              break
            end
          else
            break
          end
        end
      end
      # Check auto-watering
      if berryData[0]>0 && berryData[0]<5
        # Reset watering
        if $game_screen && 
           ($game_screen.weather_type==PBFieldWeather::Rain ||
           $game_screen.weather_type==PBFieldWeather::HeavyRain ||
           $game_screen.weather_type==PBFieldWeather::Storm)
          # If raining, plant is already watered
          if berryData[2]==false
            berryData[2]=true
            berryData[4]+=1
          end
        end
      end
    end
    return berryData
  end
  
end

#===============================================================================
# Item Handlers
#===============================================================================
ItemHandlers::UseInField.add(:BERRYPOTS,proc { |item|
  pbBerryPots
  next 1
})