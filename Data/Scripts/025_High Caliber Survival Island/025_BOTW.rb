# BOTW-Like Item Gathering by: Kyu
################################################################################
# How to install:
#   Add Object.png to the Graphics/Pictures folder.
#   Add this script over main.
#
# CREDITS MUST BE GIVEN TO EVERYONE LISTED ON THE POST
################################################################################
# CONSTANTS
################################################################################
NEWPICKBERRY = true # if true, berries will be picked directly with the new anim. 
ITEMGETSE = "Voltorb Flip point" # ME that will play after obtaining an item.
################################################################################

if defined?(PluginManager)
  PluginManager.register({
    :name => "BOTW-Like Item Gathering",
    :version => "1.0",
    :credits => "Kyu"
  })
end
  
#UI Object with timer, animation and other relevant data
class UISprite < SpriteWrapper
  attr_accessor :scroll
  attr_accessor :timer

  def initialize(x, y, bitmap, viewport)
    super(viewport)
    self.bitmap = bitmap
    self.x = x
    self.y = y
    @scroll = false
    @timer = 0
  end

  def update
    return if self.disposed?
    @timer += 1
    case @timer
    when (0..10)
      self.x += self.bitmap.width/10
    when (100..110)
      self.x -= self.bitmap.width/10
    when 111
      self.dispose
    end
  end
end


class Spriteset_Map
  # Handles all UI objects in order to control their positions on screen, timing 
  # and disposal. Acts like a Queue.
  class UIHandler
    def initialize
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height) # Uses its own viewport to make it compatible with both v16 and v17.
      @viewport.z = 9999
      @sprites = []
    end

    def addSprite(x, y, bitmap)
      @sprites.each{|sprite|
        sprite.scroll = true
      }
      index = @sprites.length
      @sprites[index] = UISprite.new(x, y, bitmap, @viewport)
    end

    def update
      removed = []
      @sprites.each_index{|key|
        sprite = @sprites[key]
        if sprite.scroll
          sprite2 = @sprites[key + 1]
          if sprite.x >= sprite2.x && sprite.x <= sprite2.bitmap.width + sprite2.x
            if sprite.y >= sprite2.y && sprite.y <= sprite2.bitmap.height + sprite2.y + 5
              sprite.y += 5
            end
          else
            sprite.scroll = false
          end
        end
        sprite.update
        if sprite.disposed?
          removed.push(sprite)
        end
      }
      
      removed.each{|sprite|
        @sprites.delete(sprite)
      }
    end
        
    def dispose
      @sprites.each{|sprite|
        if !sprite.disposed?
          sprite.dispose
        end
      }
      @viewport.dispose
    end
  end
  
  alias :disposeOld :dispose
  alias :updateOld :update

  def dispose
    @ui.dispose if @ui
    disposeOld
  end

  def update
    @ui = UIHandler.new if !@ui
    @ui.update
    updateOld
  end

  def ui
    return @ui
  end
end


class Scene_Map
  def addSprite(x, y, bitmap)
    self.spriteset.ui.addSprite(x, y, bitmap)
  end
end


def itemAnim(item,qty)
  bitmap = Bitmap.new("Graphics/Pictures/Object")
  pbSetSystemFont(bitmap)
  base = Color.new(248,248,248)
  shadow = Color.new(72,80,88)
  
  if qty > 1
    textpos = [[_INTL("{1} x{2}",PBItems.getNamePlural(item),qty),5,15,false,base,shadow]]
  else
    textpos = [[_INTL("{1}",PBItems.getName(item)),5,15,false,base,shadow]]
  end
  pbDrawTextPositions(bitmap,textpos)
  
  if pbResolveBitmap(sprintf("Graphics/Icons/Item%03d",item))
    bitmap.blt(274,5,Bitmap.new(sprintf("Graphics/Icons/Item%03d",item)),Rect.new(0,0,48,48))
  end
  pbSEPlay(ITEMGETSE)
  $scene.addSprite(-bitmap.width,200,bitmap)
end


def Kernel.pbItemBall(item,quantity=1)
  if item.is_a?(String) || item.is_a?(Symbol)
    item=getID(PBItems,item)
  end
  return false if !item || item<=0 || quantity<1
  itemname=(quantity>1) ? PBItems.getNamePlural(item) : PBItems.getName(item)
  pocket=pbGetPocket(item)
  if $PokemonBag.pbStoreItem(item,quantity)   # If item can be picked up 
    itemAnim(item,quantity)
    return true
  else   # Can't add the item
    if $ItemData[item][ITEMUSE]==3 || $ItemData[item][ITEMUSE]==4
      Kernel.pbMessage(_INTL("\\l[2]¡{1} found \\c[1]{2}\\c[0]!\\wtnp[20]",$Trainer.name,itemname))
    elsif isConst?(item,PBItems,:LEFTOVERS)
      Kernel.pbMessage(_INTL("\\l[2]¡{1} found some \\c[1]{2}\\c[0]!\\wtnp[20]",$Trainer.name,itemname))
    elsif quantity>1
      Kernel.pbMessage(_INTL("\\l[2]¡{1} found {2} \\c[1]{3}\\c[0]!\\wtnp[20]",$Trainer.name,quantity,itemname))
    else
      Kernel.pbMessage(_INTL("\\l[2]¡{1} found \\c[1]{2}\\c[0]!\\wtnp[20]",$Trainer.name,itemname))
    end
    Kernel.pbMessage(_INTL("\\l[2]But your bag is full..."))
    return false
  end
end

#Compatibility with Essentials v18.1
def pbItemBall(item,quantity=1)
  Kernel.pbItemBall(item,quantity)
end

alias :oldBerry :pbPickBerry
def pbPickBerry(berry,qty=1)
  if !NEWPICKBERRY # Old Animation
    oldBerry(berry,qty)
  else # New Animation
    interp=pbMapInterpreter
    thisEvent=interp.get_character(0)
    berryData=interp.getVariable
    if berry.is_a?(String) || berry.is_a?(Symbol)
      berry=getID(PBItems,berry)
    end
    itemname=(qty>1) ? PBItems.getNamePlural(berry) : PBItems.getName(berry)
    if !$PokemonBag.pbCanStore?(berry,qty)
      Kernel.pbMessage(_INTL("Too bad...\nThe bag is full."))
      return
    end
    $PokemonBag.pbStoreItem(berry,qty)
    pocket=pbGetPocket(berry)
    itemAnim(berry,qty)
    if defined?(NEWBERRYPLANTS) #Compatibility with essentials v18.1
      if NEWBERRYPLANTS
        berryData=[0,0,0,0,0,0,0,0]
      else
        berryData=[0,0,false,0,0,0]
      end
    else
      berryData=[0,0,false,0,0,0]
    end
    interp.setVariable(berryData)
    pbSetSelfSwitch(thisEvent.id,"A",true)
  end
end