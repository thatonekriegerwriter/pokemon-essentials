#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                         Simple 2v1 Boss/Totem Battles                        #
#                                     v1.5                                     #
#                               By Golisopod User                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
# Implements Functionality for easily setting up 1v1 or 2v1 Boss/Totem Battles #
# Allows highly customizable boss battles which can be called through special  #
# Boss Battle script commands or by setting up the parameters mentioned below. #
# The script overrides regular wild encounters so Grass,Fishing and even other #
# Event Encounters will change based on the parameters set up. Other than the  #
# SOS chaining, everything else should work just like the regular games, but   #
# with more personalization.                                                   #
#                                                                              #
# This Script is meant for the default Essentials battle system. The upcoming  #
# EBDX already has this functionality inbuilt. It should theoretically be      #
# compatible with EBS but this hasn't been tested with it so do keep that in   #
# mind when using this.                                                        #
#                                                                              #
#==============================================================================#
#                              INSTRUCTIONS                                    #
#------------------------------------------------------------------------------#
# 1. Place the script.txt from the ZIP in a new section above Main             #
#                                                                              #
# 2. Install Luka's Utilities from here https://luka-sj.com/res/luts           #
#                                                                              #
# 3. Use Ctrl+Shift+F and look for "if transformed". Below that, look for:     #
#    @battle.pbDisplay(_INTL("{1} transformed!",pbThis))                       #
#    and replace that with:                                                    #
#    @battle.pbDisplay(_INTL("{1} transformed!",pbThis)) if !BossBattleData.getPokemonData[:forcedForm]
#                                                                              #
# 4. Add the Adrenaline Orb Item to your game for the SOS Chaining
#    XXX,ADRENALINEORB,Adrenaline Orb,Adrenaline Orbs,1,300,"An item to be held by a Pokémon. It boosts the holder's speed when it is intimidated. Can only be used once.",0,0,0,
#                                                                              #
# 5. Edit the Customizable Options                                             #
#                                                                              #
# 6. Edit the default text from the constants below. (Not Nescessary)          #
#                                                                              #
# 7. Start a new save (Not nescessary, but just to be on the safe side)        #
#------------------------------------------------------------------------------#
#          INFO ABOUT THE PARAMETERS AND METHODS FOR BOSS BATTLES              #
#------------------------------------------------------------------------------#
#                                                                              #
# All the info has been mentioned clearly in the Main Post. Please read all of #
# it thoroughly and don't skip any parts. 90% of errors you'll get while       #
# starting a Boss Battle are gonna be Syntax Errors you get when you don't use #
# the Battle Overides properly.                                                #
#                                                                              #
#------------------------------------------------------------------------------#
#                          CUSTOMIZABLE OPTIONS                                #
#==============================================================================#


USING_DYNAMAX    = false # https://www.pokecommunity.com/showthread.php?t=437985
                         # If you have the Dynamax and Max Raid Battles coded 
                         # in your game from the above link, set this to true

USING_BALL_FETCH = false # https://www.pokecommunity.com/showthread.php?t=422817
                         # If you have Yamper's Ability Ball Fetch Coded into
                         # your game from the above link, set this to true
                         
USING_SOS_CHAINING = false # https://www.pokecommunity.com/showthread.php?p=10198226
                         # If you have SOS Battles Coded into your game from the
                         # above link, and you plan to use it apart from Boss/
                         # Totem Battles, set this to true

# The default values the script uses. DON'T REMOVE ANY OF THE VALUES. JUST MAKE
# EDITS TO THEM
module BossBattleData
  # Default Text Displayed when the Boss Faints
  FaintedText="The Totem {1} fainted!" # {1} is the name of the Pokemon 
  
  # Default Text Displayed when the Boss deflects a PokéBall
  DeflectText="{1} deflected the {2}" # {1} is the name of the Pokemon,
                                      # {2} is the name of the ball
                                      
  # Default Text Displayed when the Boss deflects a PokéBall
  AppearText="The Totem {1} would like to battle!" # {1} is the name of the Pokemon
  
  # Default Text Displayed when the Boss is about to gain a Totem Stat Boost
  AuraText="{1}'s aura flared to life" # {1} is the name of the Pokemon
  
  # Default Text Displayed after the Boss gains a Totem Stat Boost
  StatBoostText="{1}'s stats sharply rose!" # {1} is the name of the Pokemon
  
  # Default Common Animation played when the Boss gains a Totem Stat Boost
  StatAnim=["MegaEvolution","StatUp"] # This can be a String or an Array
  
  # Default Text Displayed when recruiting a Boss Pokemon (when CatchStyle is not 1)
  RecruitText="{1} would like to join the team! Do you accept?" # {1} is the name of the Pokemon
  
  # Default Text Displayed when choosing a battle command
  WarnText="{1} awaits\nyour instructions?" # {1} is the name of the Pokemon
                                            # {2} is the name of the Boss Pokemon
                                            
  # Default Text Displayed when Boss Pokemon calls for an SOS Partner
  CallText="{1} called for help!" # {1} is the name of the Boss Pokemon
  
  # Default Text Displayed when successfully recruited a Boss Pokemon (when CatchStyle is not 1)
  RecruitedText="{1} joined the team!" # {1} is the name of the Pokemon
  
  # Default Text Displayed when Boss Pokemon is weakened (when CatchStyle is 1)
  WeakenedText="{1} is weakened. Throw a Pokeball Now!" # {1} is the name of the Pokemon
  
  # Default Choices Displayed when catching/recruiting a Boss Pokemon(For both catchStyles)
  FaintedChoices=["Yes","No"] # Has 2 be an Array with 2 String Elements
end

#==============================================================================#
#//////////////////////////////////////////////////////////////////////////////#
#==============================================================================#

#===============================================================================
# Main Script begins. Don't edit anything beyond this point.
#===============================================================================

#===============================================================================
# A useful Method. Credits Luka SJ
#===============================================================================
class ::Hash
  def LukaMerge(hash)
    # failsafe
    return if !hash.is_a?(Hash)
    for key in hash.keys
      if self[key].is_a?(Hash)
        if hash[key].is_a?(Hash)
          self[key].LukaMerge(hash[key])
        else
          self[key] = hash[key]
        end
      else
        self[key] = hash[key]
      end
    end
  end
end

#===============================================================================
# Overriding the Wild Pokemon Data before a Boss Battle
#===============================================================================
def pbGenerateWildPokemon(species,level,isroamer=false)
  pokeData=BossBattleData.getPokemonData
  if BossBattleData.isBossBattle?
    if pokeData[:species] && pokeData[:species].is_a?(Symbol)
      species=pokeData[:species]
    end
  end
  genwildpoke = PokeBattle_Pokemon.new(species,level,$Trainer)
  items = genwildpoke.wildHoldItems
  firstpoke = $Trainer.firstPokemon
  chances = [50,5,1]
  chances = [60,20,5] if firstpoke && isConst?(firstpoke.ability,PBAbilities,:COMPOUNDEYES)
  if USENEWBATTLEMECHANICS
    chances = [50,50,50] if firstpoke && isConst?(firstpoke.ability,PBAbilities,:SUPERLUCK) 
  end
  itemrnd = rand(100)
  if itemrnd<chances[0] || (items[0]==items[1] && items[1]==items[2])
    genwildpoke.setItem(items[0])
  elsif itemrnd<(chances[0]+chances[1])
    genwildpoke.setItem(items[1])
  elsif itemrnd<(chances[0]+chances[1]+chances[2])
    genwildpoke.setItem(items[2])
  end
  if hasConst?(PBItems,:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
    for i in 0...2   # 3 times as likely
      break if genwildpoke.isShiny?
      genwildpoke.personalID = rand(65536)|(rand(65536)<<16)
    end
  end
  if rand(65536)<POKERUSCHANCE
    genwildpoke.givePokerus
  end
  if firstpoke && !firstpoke.egg?
    if isConst?(firstpoke.ability,PBAbilities,:CUTECHARM) && !genwildpoke.isSingleGendered?
      if firstpoke.isMale?
        (rand(3)<2) ? genwildpoke.makeFemale : genwildpoke.makeMale
      elsif firstpoke.isFemale?
        (rand(3)<2) ? genwildpoke.makeMale : genwildpoke.makeFemale
      end
    elsif isConst?(firstpoke.ability,PBAbilities,:SYNCHRONIZE)
      genwildpoke.setNature(firstpoke.nature) if USENEWBATTLEMECHANICS || rand(10)<5
    end
  end
  if BossBattleData.isBossBattle? 
    if pokeData[:shiny].is_a?(Numeric)
      genwildpoke.makeShiny if rand(pokeData[:shiny])<0
    elsif pokeData[:shiny]==true
      genwildpoke.makeShiny
    end
    if pokeData[:gender]
      genwildpoke.setGender(pokeData[:gender])
    end
    if pokeData[:moves]
      for i in 0...pokeData[:moves].length
        if pokeData[:moves][i].is_a?(Symbol)
          genwildpoke.pbLearnMove(getConst(PBMoves,pokeData[:moves][i]))
        end
      end
    end
    if pokeData[:ability]
      abils = genwildpoke.getAbilityList
      if pokeData[:ability]>abils.length || pokeData[:ability]<0
        genwildpoke.setAbility(0)
      else
        genwildpoke.setAbility(pokeData[:ability])
      end
    end
    if pokeData[:pokerus].is_a?(Numeric)
      genwildpoke.givePokerus if rand(pokeData[:pokerus])<0
    elsif pokeData[:pokerus]==true
      genwildpoke.givePokerus
    end
    if pokeData[:level]
      genwildpoke.level=pokeData[:level]
    end
    if pokeData[:form]
      genwildpoke.form=pokeData[:form]
    end
    if pokeData[:forcedForm] && !pokeData[:form]
      genwildpoke.forcedForm=pokeData[:forcedForm]
    end
    if pokeData[:nature]
      genwildpoke.setNature(getConst(PBNatures,pokeData[:nature]))
    end
    if pokeData[:item]
      genwildpoke.setItem(getConst(PBItems,pokeData[:item]))
    end
    if pokeData[:iv] && pokeData[:iv].length==6
      for i in 0...pokeData[:iv].length
        val=pokeData[:iv]
        if !val[i]
          genwildpoke.iv[i]=rand(32)
        else
          genwildpoke.iv[i]=val[i]
          genwildpoke.iv[i]=31 if val[i]>31
          genwildpoke.iv[i]=0 if val[i]<0
        end
      end
    end
    if pokeData[:ev] && pokeData[:ev].length==6
      sum=0
      for i in 0..6
        if !pokeData[:ev][i]
          genwildpoke.ev[i]=0
        else
          next if sum >= PokeBattle_Pokemon::EVLIMIT
          genwildpoke.ev[i]=pokeData[:ev][i]
          if sum+pokeData[:ev][i]>PokeBattle_Pokemon::EVLIMIT
            genwildpoke.ev[i]=PokeBattle_Pokemon::EVLIMIT-sum
          end
          genwildpoke.ev[i]=PokeBattle_Pokemon::EVSTATLIMIT if pokeData[:ev][i]>PokeBattle_Pokemon::EVSTATLIMIT
          genwildpoke.ev[i]=0 if pokeData[:ev][i]<0
          sum+=genwildpoke.ev[i]
        end
      end
    end
  end
  genwildpoke.calcStats
  Events.onWildPokemonCreate.trigger(nil,genwildpoke)
  return genwildpoke
end

#===============================================================================
# Rewrite of PokéBall Throwing Method to accomodate for Boss Battles
#===============================================================================
module PokeBattle_BattleCommon
  def pbThrowPokeBall(idxPokemon,ball,rareness=nil,showplayer=false)
    itemname=PBItems.getName(ball)
    battler=nil
    if pbIsOpposing?(idxPokemon)
      battler=self.battlers[idxPokemon]
    else
      battler=self.battlers[idxPokemon].pbOppositeOpposing
    end
    if battler.fainted?
      battler=battler.pbPartner
    end
    captureData=0
    canCatch=false
    catchLine=BossBattleData::DeflectText
    if BossBattleData.isBossBattle?
      if BossBattleData.getFaintedCatchData
        if battler.hp>1
          captureData=BossBattleData.getFaintedCatchData
          if captureData.is_a?(Hash) && captureData[:catchStyle]>=0 
            if captureData[:blockDialogue].is_a?(String)
              catchLine=captureData[:blockDialogue]
            end
          end
          canCatch=true
        end
      else
        catchRate=BossBattleData.getCatchRate
        if !catchRate || (catchRate.is_a?(Numeric) && catchRate<0)
          canCatch=true# if !(BossBattleData.getFaintedCatchData && battler.hp<=1)
        else
          rareness=catchRate
        end
      end
    end
    pbDisplayBrief(_INTL("{1} threw one {2}!",self.pbPlayer.name,itemname))
    if canCatch == true 
      @scene.pbThrowAndDeflect(ball,1)
      pbDisplay(_INTL(catchLine,battler.pbThis,itemname))
      pbBallFetch(ball) if USING_BALL_FETCH
      return
    end
    if battler.fainted?
      pbDisplay(_INTL("But there was no target..."))
      pbBallFetch(ball) if USING_BALL_FETCH
      return
    end
    if @opponent && (!pbIsSnagBall?(ball) || !battler.isShadow?)
      @scene.pbThrowAndDeflect(ball,1)
      pbDisplay(_INTL("The Trainer blocked the Ball!\nDon't be a thief!"))
      pbBallFetch(ball) if USING_BALL_FETCH
    else
      pokemon=battler.pokemon
      species=pokemon.species
      if $DEBUG && Input.press?(Input::CTRL)
        shakes=4
      else
        if !rareness
          dexdata=pbOpenDexData
          pbDexDataOffset(dexdata,pokemon.fSpecies,16)
          rareness=dexdata.fgetb # Get rareness from dexdata file
          dexdata.close
        end
        a=battler.totalhp
        b=battler.hp
        rareness=BallHandlers.modifyCatchRate(ball,rareness,self,battler)
        x=(((a*3-b*2)*rareness)/(a*3)).floor
        if battler.status==PBStatuses::SLEEP || battler.status==PBStatuses::FROZEN
          x=(x*2.5).floor
        elsif battler.status!=0
          x=(x*1.5).floor
        end
        c=0
        if $Trainer
          if $Trainer.pokedexOwned>600
            c=(x*2.5/6).floor
          elsif $Trainer.pokedexOwned>450
            c=(x*2/6).floor
          elsif $Trainer.pokedexOwned>300
            c=(x*1.5/6).floor
          elsif $Trainer.pokedexOwned>150
            c=(x*1/6).floor
          elsif $Trainer.pokedexOwned>30
            c=(x*0.5/6).floor
          end
        end
        shakes=0; critical=false
        if x>255 || BallHandlers.isUnconditional?(ball,self,battler)
          shakes=4
        else
          x=1 if x<1
          y = ( 65536 / ((255.0/x)**0.1875) ).floor
          if USECRITICALCAPTURE && pbRandom(256)<c
            critical=true
            shakes=4 if pbRandom(65536)<y
          else
            shakes+=1 if pbRandom(65536)<y
            shakes+=1 if pbRandom(65536)<y && shakes==1
            shakes+=1 if pbRandom(65536)<y && shakes==2
            shakes+=1 if pbRandom(65536)<y && shakes==3
          end
        end
      end
      PBDebug.log("[Threw Poké Ball] #{itemname}, #{shakes} shakes (4=capture)")
      @scene.pbThrow(ball,shakes,critical,battler.index,showplayer)
      case shakes
      when 0
        pbDisplay(_INTL("Oh no! The Pokémon broke free!"))
        BallHandlers.onFailCatch(ball,self,battler)
        pbBallFetch(ball) if USING_BALL_FETCH
      when 1
        pbDisplay(_INTL("Aww... It appeared to be caught!"))
        BallHandlers.onFailCatch(ball,self,battler)
        pbBallFetch(ball) if USING_BALL_FETCH
      when 2
        pbDisplay(_INTL("Aargh! Almost had it!"))
        BallHandlers.onFailCatch(ball,self,battler)
        pbBallFetch(ball) if USING_BALL_FETCH
      when 3
        pbDisplay(_INTL("Gah! It was so close, too!"))
        BallHandlers.onFailCatch(ball,self,battler)
        pbBallFetch(ball) if USING_BALL_FETCH
      when 4
        pbDisplayBrief(_INTL("Gotcha! {1} was caught!",pokemon.name))
        @scene.pbThrowSuccess
        if pbIsSnagBall?(ball) && @opponent
          pbRemoveFromParty(battler.index,battler.pokemonIndex)
          battler.pbReset
          battler.participants=[]
        else
          @decision=4
        end
        if pbIsSnagBall?(ball)
          pokemon.ot=self.pbPlayer.name
          pokemon.trainerID=self.pbPlayer.id
        end
        BallHandlers.onCatch(ball,self,pokemon)
        pokemon.ballused=pbGetBallType(ball)
        ((pokemon.makeUnmega if pokemon.isMega?) rescue nil)
        pokemon.makeUnprimal rescue nil
        # pokemon.pbUndynamax if pokemon.isDynamax? rescue nil
        pokemon.pbRecordFirstMoves
        if GAINEXPFORCAPTURE
          battler.captured=true
          pbGainEXP
          battler.captured=false
        end
        if !self.pbPlayer.hasOwned?(species)
          self.pbPlayer.setOwned(species)
          if $Trainer.pokedex
            pbDisplayPaused(_INTL("{1}'s data was added to the Pokédex.",pokemon.name))
            @scene.pbShowPokedex(species)
          end
        end
        pokemon.forcedForm = nil if MultipleForms.hasFunction?(pokemon.species,"getForm")
        @scene.pbHideCaptureBall
        if pbIsSnagBall?(ball) && @opponent
          pokemon.pbUpdateShadowMoves rescue nil
          @snaggedpokemon.push(pokemon)
        else
          pbStorePokemon(pokemon)
        end
      end
    end
  end
end

#===============================================================================
# Reset all Boss Battle Overrides after the Boss Battle
#===============================================================================
alias pbAfterBattleOld pbAfterBattle

def pbAfterBattle(decision,canlose)
   BossBattleData.resetAll if BossBattleData.getResetData
  pbAfterBattleOld(decision,canlose)
end


  
#===============================================================================
# Rewrite of PokeBattle_Scene to override the Battle Scene
#===============================================================================
class PokeBattle_Scene
  def pbBackdrop
    environ=@battle.environment
    # Choose backdrop
    backdrop="Field"
    if environ==PBEnvironment::Cave
      backdrop="Cave"
    elsif environ==PBEnvironment::MovingWater || environ==PBEnvironment::StillWater
      backdrop="Water"
    elsif environ==PBEnvironment::Underwater
      backdrop="Underwater"
    elsif environ==PBEnvironment::Rock
      backdrop="Mountain"
    else
      if !$game_map || !pbGetMetadata($game_map.map_id,MetadataOutdoor)
        backdrop="IndoorA"
      end
    end
    if $game_map
      back=pbGetMetadata($game_map.map_id,MetadataBattleBack)
      if back && back!=""
        backdrop=back
      end
    end
    if $PokemonGlobal && $PokemonGlobal.nextBattleBack
      backdrop=$PokemonGlobal.nextBattleBack
    end
    # Choose bases
    base=""
    trialname=""
    if environ==PBEnvironment::Grass || environ==PBEnvironment::TallGrass
      trialname="Grass"
    elsif environ==PBEnvironment::Sand
      trialname="Sand"
    elsif $PokemonGlobal.surfing
      trialname="Water"
    end
    if pbResolveBitmap(sprintf("Graphics/Battlebacks/playerbase"+backdrop+trialname))
      base=trialname
    end
    # Choose time of day
    time=""
    if ENABLESHADING
      trialname=""
      timenow=pbGetTimeNow
      if PBDayNight.isNight?(timenow)
        trialname="Night"
      elsif PBDayNight.isEvening?(timenow)
        trialname="Eve"
      end
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/battlebg"+backdrop+trialname))
        time=trialname
      end
    end
    # Apply graphics
    battlebg="Graphics/Battlebacks/battlebg"+backdrop+time
    enemybase="Graphics/Battlebacks/enemybase"+backdrop+base+time
    playerbase="Graphics/Battlebacks/playerbase"+backdrop+base+time
    bgVar=BossBattleData.getBattleBGData
    if bgVar.is_a?(Hash)
      if bgVar[:backdrop].is_a?(String)
        battlebg="Graphics/Battlebacks/battlebg"+bgVar[:backdrop]
      else
        battlebg="Graphics/Battlebacks/battlebg"+backdrop+time
      end
      if bgVar[:playerBase].is_a?(String)
        playerbase="Graphics/Battlebacks/playerbase"+bgVar[:playerBase]
      else
        playerbase="Graphics/Battlebacks/playerbase"+backdrop+base+time
      end
      if bgVar[:enemyBase].is_a?(String)
        enemybase="Graphics/Battlebacks/enemybase"+bgVar[:enemyBase]
      else
        enemybase="Graphics/Battlebacks/enemybase"+backdrop+base+time
      end
    elsif bgVar.is_a?(String)
      backdrop=bgVar
      battlebg="Graphics/Battlebacks/battlebg"+backdrop+time
      enemybase="Graphics/Battlebacks/enemybase"+backdrop+base+time
      playerbase="Graphics/Battlebacks/playerbase"+backdrop+base+time
    end
    pbAddPlane("battlebg",battlebg,@viewport)
    pbAddSprite("playerbase",
       PokeBattle_SceneConstants::PLAYERBASEX,
       PokeBattle_SceneConstants::PLAYERBASEY,playerbase,@viewport)
    @sprites["playerbase"].x-=@sprites["playerbase"].bitmap.width/2 if @sprites["playerbase"].bitmap!=nil
    @sprites["playerbase"].y-=@sprites["playerbase"].bitmap.height if @sprites["playerbase"].bitmap!=nil
    pbAddSprite("enemybase",
       PokeBattle_SceneConstants::FOEBASEX,
       PokeBattle_SceneConstants::FOEBASEY,enemybase,@viewport)
    @sprites["enemybase"].x-=@sprites["enemybase"].bitmap.width/2 if @sprites["enemybase"].bitmap!=nil
    @sprites["enemybase"].y-=@sprites["enemybase"].bitmap.height/2 if @sprites["enemybase"].bitmap!=nil
    @sprites["battlebg"].z=0
    @sprites["playerbase"].z=1
    @sprites["enemybase"].z=1
  end
  
  def pbThrowSuccess
    if !@battle.opponent
      @briefmessage=false
      mePlayer="Battle capture success"
      if BossBattleData.getFaintedCatchData[:joinME].is_a?(String) && BossBattleData.getFaintedCatchData[:joinME] != ""
        mePlayer=BossBattleData.getFaintedCatchData[:joinME]
      end
      pbMEPlay(mePlayer)
      frames=(3.5*Graphics.frame_rate).to_i
      frames.times do
        pbGraphicsUpdate
        pbInputUpdate
        pbFrameUpdate
      end
    end
  end
  
  def pbChangeSpecies(attacker,species)
    pkmn=@sprites["pokemon#{attacker.index}"]
    shadow=@sprites["shadow#{attacker.index}"]
    back=!@battle.pbIsOpposing?(attacker.index)
    pkmn.setPokemonBitmapSpecies(attacker.pokemon,species,back)
    pkmn.x=-pkmn.bitmap.width/2
    pkmn.y=adjustBattleSpriteY(pkmn,species,attacker.index)
    if @battle.doublebattle
      case attacker.index
      when 0
        pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLERD1_X
        pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLERD1_Y
      when 1
        var=PokeBattle_SceneConstants::FOEBATTLERD1_X
        var=PokeBattle_SceneConstants::FOEBATTLER_X if BossBattleData.isBossBattle?
        pkmn.x+=var
        pkmn.y+=PokeBattle_SceneConstants::FOEBATTLERD1_Y
      when 2
        pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLERD2_X
        pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLERD2_Y
      when 3
        pkmn.x+=PokeBattle_SceneConstants::FOEBATTLERD2_X
        pkmn.y+=PokeBattle_SceneConstants::FOEBATTLERD2_Y
      end
    else
      pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLER_X if attacker.index==0
      pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLER_Y if attacker.index==0
      pkmn.x+=PokeBattle_SceneConstants::FOEBATTLER_X if attacker.index==1
      pkmn.y+=PokeBattle_SceneConstants::FOEBATTLER_Y if attacker.index==1
    end
    if shadow && !back
      shadow.visible=showShadow?(species)
    end
  end

  def pbChangePokemon(attacker,pokemon)
    pkmn=@sprites["pokemon#{attacker.index}"]
    shadow=@sprites["shadow#{attacker.index}"]
    back=!@battle.pbIsOpposing?(attacker.index)
    pkmn.setPokemonBitmap(pokemon,back)
    pkmn.x=-pkmn.bitmap.width/2
    pkmn.y=adjustBattleSpriteY(pkmn,pokemon.species,attacker.index)
    if @battle.doublebattle
      case attacker.index
      when 0
        pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLERD1_X
        pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLERD1_Y
      when 1
        var=PokeBattle_SceneConstants::FOEBATTLERD1_X
        var=PokeBattle_SceneConstants::FOEBATTLER_X if BossBattleData.isBossBattle?
        pkmn.x+=var
        pkmn.y+=PokeBattle_SceneConstants::FOEBATTLERD1_Y
      when 2
        pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLERD2_X
        pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLERD2_Y
      when 3
        pkmn.x+=PokeBattle_SceneConstants::FOEBATTLERD2_X
        pkmn.y+=PokeBattle_SceneConstants::FOEBATTLERD2_Y
      end
    else
      pkmn.x+=PokeBattle_SceneConstants::PLAYERBATTLER_X if attacker.index==0
      pkmn.y+=PokeBattle_SceneConstants::PLAYERBATTLER_Y if attacker.index==0
      pkmn.x+=PokeBattle_SceneConstants::FOEBATTLER_X if attacker.index==1
      pkmn.y+=PokeBattle_SceneConstants::FOEBATTLER_Y if attacker.index==1
    end
    if shadow && !back
      shadow.visible=showShadow?(pokemon.species)
    end
  end
  
  def pbCommandMenu(index)
    shadowTrainer=(hasConst?(PBTypes,:SHADOW) && @battle.opponent)
    warn="What will\n{1} do?"
    if BossBattleData.isBossBattle?
      warnData=BossBattleData.getWarnText ? BossBattleData.getWarnText : BossBattleData::WarnText
      warn=warnData.is_a?(Array)? warnData[rand(warnData.length)] : warnData
    end
    ret=pbCommandMenuEx(index,[
       _INTL(warn,@battle.battlers[index].name,@battle.battlers[1].name),
       _INTL("Fight"),
       _INTL("Bag"),
       _INTL("Pokémon"),
       shadowTrainer ? _INTL("Call") : _INTL("Run")
    ],(shadowTrainer ? 1 : 0))
    ret=4 if ret==3 && shadowTrainer   # Convert "Run" to "Call"
    return ret
  end
end

#===============================================================================
# Rewrite of PokeBattle_Battler to override the fainting dialogue
#===============================================================================
class PokeBattle_Battler
  
  def setBoss
    @boss=true
  end
  
  def isBoss?
    return @boss
  end
  
  def initialize(btl,index)
    @battle       = btl
    @index        = index
    @hp           = 0
    @totalhp      = 0
    @fainted      = true
    @captured     = false
    @stages       = []
    @effects      = []
    @boss         =false
    @damagestate  = PokeBattle_DamageState.new
    pbInitBlank
    pbInitEffects(false)
    pbInitPermanentEffects
  end
  
  def pbFaint(showMessage=true)
    var1=BossBattleData.getCatchRate
    var2=BossBattleData.getFaintedCatchData
    var3=false
    if BossBattleData.isBossBattle? && self.isBoss? && !@fainted
      self.hp=1
      if pbBossCapture(self)
        var3=true
      end
      @fainted=true
    elsif USING_DYNAMAX && $game_switches[MAXRAID_SWITCH] && @effects[PBEffects::MaxRaidBoss]
      self.hp=1
      pbCatchRaidPokemon(self) 
      return false
    else
      unless fainted?
        PBDebug.log("!!!***Can't faint with HP greater than 0")
        return true
      end
      if @fainted
#       PBDebug.log("!!!***Can't faint if already fainted")
        return true
      end
    end
    @battle.scene.pbFainted(self) if !var3
    pbInitEffects(false)
    # Reset status
    self.status=0
    self.statusCount=0
    if @pokemon && @battle.internalbattle
      @pokemon.changeHappiness("faint")
    end
    @pokemon.makeUnmega if self.isMega?
    @pokemon.makeUnprimal if self.isPrimal?
    @fainted=true
    @pokemon.makeUnmax if USING_DYNAMAX && self.isDynamax?
    if defined?(@pokemon.makeUnUltra)
      @pokemon.makeUnUltra if self.isUltra?
    end
    # reset choice
    @battle.choices[@index]=[0,0,nil,-1]
    pbOwnSide.effects[PBEffects::LastRoundFainted]=@battle.turncount
    faintedText=BossBattleData::FaintedText
    textVar=BossBattleData.getFaintedText
    if BossBattleData.isBossBattle? && self.isBoss?
      faintedText=textVar if textVar.is_a?(String) && textVar != ""
      @battle.pbDisplayPaused(_INTL(faintedText,pbThis)) if !var3
    else
      @battle.pbDisplayPaused(_INTL("{1} fainted!",pbThis)) if showMessage 
    end
    PBDebug.log("[Pokémon fainted] #{pbThis}")
    self.hp=0
    return true
  end
  
  def pbThis(lowercase=false)
    if @battle.pbIsOpposing?(@index)
      if @battle.opponent
        return lowercase ? _INTL("the opposing {1}",self.name) : _INTL("The opposing {1}",self.name)
      else
        if BossBattleData.isBossBattle? && self.isBoss?
          if BossBattleData.getTitleData.is_a?(String)
            return lowercase ? _INTL("the {2} {1}",self.name,BossBattleData.getTitleData) : _INTL("The {2} {1}",self.name,BossBattleData.getTitleData)
          else
            return lowercase ? _INTL("{1}",self.name) : _INTL("{1}",self.name)
          end
        else
          return lowercase ? _INTL("the wild {1}",self.name) : _INTL("The wild {1}",self.name)
        end
      end
    elsif @battle.pbOwnedByPlayer?(@index)
      return self.name
    else
      return lowercase ? _INTL("the ally {1}",self.name) : _INTL("The ally {1}",self.name)
    end
  end
end

#===============================================================================
# Rewrite of PokeBattle_Battle for Totem Boosts and other stuff
#===============================================================================
class PokeBattle_Battle
  
  def pbFindBoss
    for i in 0...4
      return @battlers[i] if @battlers[i] && @battlers[i].isBoss? 
    end
    return -1
  end
  
  def pbStartBattleCore(canlose)
    if !@fullparty1 && @party1.length>MAXPARTYSIZE
      raise ArgumentError.new(_INTL("Party 1 has more than {1} Pokémon.",MAXPARTYSIZE))
    end
    if !@fullparty2 && @party2.length>MAXPARTYSIZE
      raise ArgumentError.new(_INTL("Party 2 has more than {1} Pokémon.",MAXPARTYSIZE))
    end
#========================
# Initialize wild Pokémon
#========================
    if !@opponent
      if @party2.length==1
        if @doublebattle && !BossBattleData.is2v1BossBattle?
          raise _INTL("Only two wild Pokémon are allowed in double battles")
        end
        wildpoke=@party2[0]
        @battlers[1].pbInitialize(wildpoke,0,false)
        @peer.pbOnEnteringBattle(self,wildpoke)
        pbSetSeen(wildpoke)
        @scene.pbStartBattle(self)
        if BossBattleData.isBossBattle?
          battleText=BossBattleData.getBattleText
          battleText=BossBattleData::AppearText if !battleText
        else
          battleText="Wild {1} appeared!"
        end
        pbDisplayPaused(_INTL(battleText,wildpoke.name))
      elsif @party2.length==2
        if !@doublebattle
          raise _INTL("Only one wild Pokémon is allowed in single battles")
        end
        if BossBattleData.isBossBattle?
          raise _INTL("You can't have a Double Battle as a Boss Battle")
        end
        @battlers[1].pbInitialize(@party2[0],0,false)
        @battlers[3].pbInitialize(@party2[1],1,false)
        @peer.pbOnEnteringBattle(self,@party2[0])
        @peer.pbOnEnteringBattle(self,@party2[1])
        pbSetSeen(@party2[0])
        pbSetSeen(@party2[1])
        @scene.pbStartBattle(self)
        pbDisplayPaused(_INTL("Wild {1} and\r\n{2} appeared!",
           @party2[0].name,@party2[1].name))
      else
        raise _INTL("Only one or two wild Pokémon are allowed")
      end
#=======================================
# Initialize opponents in double battles
#=======================================
    elsif @doublebattle
      if @opponent.is_a?(Array)
        if @opponent.length==1
          @opponent=@opponent[0]
        elsif @opponent.length!=2
          raise _INTL("Opponents with zero or more than two people are not allowed")
        end
      end
      if @player.is_a?(Array)
        if @player.length==1
          @player=@player[0]
        elsif @player.length!=2
          raise _INTL("Player trainers with zero or more than two people are not allowed")
        end
      end
      @scene.pbStartBattle(self)
      if @opponent.is_a?(Array)
        pbDisplayPaused(_INTL("{1} and {2} want to battle!",@opponent[0].fullname,@opponent[1].fullname))
        sendout1=pbFindNextUnfainted(@party2,0,pbSecondPartyBegin(1))
        raise _INTL("Opponent 1 has no unfainted Pokémon") if sendout1<0
        sendout2=pbFindNextUnfainted(@party2,pbSecondPartyBegin(1))
        raise _INTL("Opponent 2 has no unfainted Pokémon") if sendout2<0
        @battlers[1].pbInitialize(@party2[sendout1],sendout1,false)
        pbDisplayBrief(_INTL("{1} sent\r\nout {2}!",@opponent[0].fullname,@battlers[1].name))
        pbSendOut(1,@party2[sendout1])
        @battlers[3].pbInitialize(@party2[sendout2],sendout2,false)
        pbDisplayBrief(_INTL("{1} sent\r\nout {2}!",@opponent[1].fullname,@battlers[3].name))
        pbSendOut(3,@party2[sendout2])
      else
        pbDisplayPaused(_INTL("{1}\r\nwould like to battle!",@opponent.fullname))
        sendout1=pbFindNextUnfainted(@party2,0)
        sendout2=pbFindNextUnfainted(@party2,sendout1+1)
        if sendout1<0 || sendout2<0
          sendout2 = nil
          pbDisplayBrief(_INTL("{1} sent\r\nout {2}!",@opponent.fullname,@party2[sendout1].name))
          @battlers[1].pbInitialize(@party2[sendout1],sendout1,false)
          @battlers[3].pbInitBlank
          @battlers[3].fainted = true
          pbSendOut(1,@party2[sendout1])
        else
          pbDisplayBrief(_INTL("{1} sent\r\nout {2} and {3}!",
          @opponent.fullname,@party2[sendout1].name,@party2[sendout2].name))
          @battlers[1].pbInitialize(@party2[sendout1],sendout1,false)
          @battlers[3].pbInitialize(@party2[sendout2],sendout2,false)
          pbSendOut(1,@party2[sendout1])
          pbSendOut(3,@party2[sendout2])
        end
      end
#======================================
# Initialize opponent in single battles
#======================================
    else
      if BossBattleData.isBossBattle? || BossBattleData.is2v1BossBattle?
        raise _INTL("You can't have Boss Battle Data set up and then start a Trainer Battle")
      end
      sendout=pbFindNextUnfainted(@party2,0)
      raise _INTL("Trainer has no unfainted Pokémon") if sendout<0
      if @opponent.is_a?(Array)
        raise _INTL("Opponent trainer must be only one person in single battles") if @opponent.length!=1
        @opponent=@opponent[0]
      end
      if @player.is_a?(Array)
        raise _INTL("Player trainer must be only one person in single battles") if @player.length!=1
        @player=@player[0]
      end
      trainerpoke=@party2[sendout]
      @scene.pbStartBattle(self)
      pbDisplayPaused(_INTL("{1}\r\nwould like to battle!",@opponent.fullname))
      @battlers[1].pbInitialize(trainerpoke,sendout,false)
      pbDisplayBrief(_INTL("{1} sent\r\nout {2}!",@opponent.fullname,@battlers[1].name))
      pbSendOut(1,trainerpoke)
    end
#=====================================
# Initialize players in double battles
#=====================================
    if @doublebattle
      if @player.is_a?(Array)
        sendout1=pbFindNextUnfainted(@party1,0,pbSecondPartyBegin(0))
        raise _INTL("Player 1 has no unfainted Pokémon") if sendout1<0
        sendout2=pbFindNextUnfainted(@party1,pbSecondPartyBegin(0))
        raise _INTL("Player 2 has no unfainted Pokémon") if sendout2<0
        @battlers[0].pbInitialize(@party1[sendout1],sendout1,false)
        @battlers[2].pbInitialize(@party1[sendout2],sendout2,false)
        pbDisplayBrief(_INTL("{1} sent\r\nout {2}! Go! {3}!",
           @player[1].fullname,@battlers[2].name,@battlers[0].name))
        pbSetSeen(@party1[sendout1])
        pbSetSeen(@party1[sendout2])
      else
        sendout1=pbFindNextUnfainted(@party1,0)
        sendout2=pbFindNextUnfainted(@party1,sendout1+1)
        if sendout1<0 || sendout2<0
          raise _INTL("Player doesn't have two unfainted Pokémon")
        end
        @battlers[0].pbInitialize(@party1[sendout1],sendout1,false)
        @battlers[2].pbInitialize(@party1[sendout2],sendout2,false)
        pbDisplayBrief(_INTL("Go! {1} and {2}!",@battlers[0].name,@battlers[2].name))
      end
      pbSendOut(0,@party1[sendout1])
      pbSendOut(2,@party1[sendout2])
#====================================
# Initialize player in single battles
#====================================
    else
      sendout=pbFindNextUnfainted(@party1,0)
      if sendout<0
        raise _INTL("Player has no unfainted Pokémon")
      end
      @battlers[0].pbInitialize(@party1[sendout],sendout,false)
      pbDisplayBrief(_INTL("Go! {1}!",@battlers[0].name))
      pbSendOut(0,@party1[sendout])
    end
#==================
# Initialize battle
#==================
    if BossBattleData.isBossBattle?
      @battlers[1].setBoss
    end
    if BossBattleData.isBossBattle? && BossBattleData.getBattleWeatherData
      @weather=getConst(PBWeather,BossBattleData.getBattleWeatherData)
      @weatherduration=-1
    end
    if @weather==PBWeather::SUNNYDAY
      pbCommonAnimation("Sunny",nil,nil)
      pbDisplay(_INTL("The sunlight is strong."))
    elsif @weather==PBWeather::RAINDANCE
      pbCommonAnimation("Rain",nil,nil)
      pbDisplay(_INTL("It is raining."))
    elsif @weather==PBWeather::SANDSTORM
      pbCommonAnimation("Sandstorm",nil,nil)
      pbDisplay(_INTL("A sandstorm is raging."))
    elsif @weather==PBWeather::HAIL
      pbCommonAnimation("Hail",nil,nil)
      pbDisplay(_INTL("Hail is falling."))
    elsif @weather==PBWeather::HEAVYRAIN
      pbCommonAnimation("HeavyRain",nil,nil)
      pbDisplay(_INTL("It is raining heavily."))
    elsif @weather==PBWeather::HARSHSUN
      pbCommonAnimation("HarshSun",nil,nil)
      pbDisplay(_INTL("The sunlight is extremely harsh."))
    elsif @weather==PBWeather::STRONGWINDS
      pbCommonAnimation("StrongWinds",nil,nil)
      pbDisplay(_INTL("The wind is strong."))
    end
    if BossBattleData.isBossBattle?
      done=false
      for i in 0...4
        next if !@battlers[0].pbIsOpposing?(i)
        next if done
        statArr=BossBattleData.getStatData
        next if !statArr
        currentStat=[]
        boosted=false
        for j in 0...statArr.length
          if statArr[j].is_a?(Numeric)
            for k in 0...currentStat.length
              @battlers[i].stages[getConst(PBStats,currentStat[k])] = statArr[j]
            end
            currentStat=[]
            boosted=true
          else
            currentStat.push(statArr[j])
          end
        end
        if boosted
          displayData=BossBattleData.getStatDisplayData
          if !displayData
            displayData={:beforeAnim=>BossBattleData::AuraText,
                         :anim=>BossBattleData::StatAnim,
                         :afterAnim=>BossBattleData::StatBoostText}
          end
          if displayData[:beforeAnim].is_a?(String) && displayData[:beforeAnim]!="" 
            pbDisplay(_INTL(displayData[:beforeAnim],@battlers[i].pbThis))
          else
            pbDisplay(_INTL(BossBattleData::AuraText,@battlers[i].pbThis))
          end
          if displayData[:anim]
            if displayData[:anim].is_a?(String) && displayData[:anim]!="" 
              pbCommonAnimation(displayData[:anim],@battlers[i],nil)
            elsif displayData[:anim].is_a?(Array)
              for j in 0...displayData[:anim].length
                pbCommonAnimation(displayData[:anim][j],@battlers[i],nil)
              end
            end
          else
            pbCommonAnimation(BossBattleData::StatAnim,@battlers[i],nil)
          end
          if displayData[:afterAnim].is_a?(String) && displayData[:afterAnim]!=""
            pbDisplayPaused(_INTL(displayData[:afterAnim],@battlers[i].pbThis))
          else
            pbDisplayPaused(_INTL(BossBattleData::StatBoostText,@battlers[i].pbThis))
          end
          done=true
        end
      end
    end
    if BossBattleData.isBossBattle? && BossBattleData.getBattleProcData.is_a?(Proc)
      BossBattleData.getBattleProcData.call(self,pbFindBoss)
    end
    pbOnActiveAll   # Abilities
    @turncount=0
    loop do   # Now begin the battle loop
      PBDebug.log("")
      PBDebug.log("***Round #{@turncount+1}***")
      if @debug && @turncount>=100
        @decision=pbDecisionOnTime()
        PBDebug.log("")
        PBDebug.log("***Undecided after 100 rounds, aborting***")
        pbAbort
        break
      end
      if BossBattleData.isBossBattle? && BossBattleData.getBattleProcData.is_a?(Hash)
        BossBattleData.getBattleProcData["turnStart#{@turncount}"].call(self,pbFindBoss) if BossBattleData.getBattleProcData["turnStart#{@turncount}"].is_a?(Proc)
      end
      break if @decision>0
      PBDebug.logonerr{
         pbCommandPhase
      }
      break if @decision>0
      PBDebug.logonerr{
         pbAttackPhase
      }
      break if @decision>0
      PBDebug.logonerr{
         pbEndOfRoundPhase
      }
      if BossBattleData.isBossBattle? && BossBattleData.getBattleProcData.is_a?(Hash)
        if BossBattleData.getBattleProcData["turnEnd#{@turncount}"].is_a?(Proc)
          BossBattleData.getBattleProcData["turnEnd#{@turncount}"].call(self,pbFindBoss) 
        else
          for key in BossBattleData.getBattleProcData.keys
            if key.starts_with?("rand") && rand(key.last?.to_i)<1 && BossBattleData.getBattleProcData["rand#{key.last?}"].is_a?(Proc)
              BossBattleData.getBattleProcData[key].call(self,pbFindBoss)
              break
            end
          end
        end
      end
      break if @decision>0
      @turncount+=1
    end
    return pbEndOfBattle(canlose)
  end

  def pbRegisterItem(idxPokemon,idxItem,idxTarget=nil)
    if idxTarget!=nil && idxTarget>=0
      for i in 0...4
        if !@battlers[i].pbIsOpposing?(idxPokemon) &&
           @battlers[i].pokemonIndex==idxTarget &&
           @battlers[i].effects[PBEffects::Embargo]>0
          pbDisplay(_INTL("Embargo's effect prevents the item's use on {1}!",@battlers[i].pbThis(true)))
          if pbBelongsToPlayer?(@battlers[i].index)
            if $PokemonBag.pbCanStore?(idxItem)
              $PokemonBag.pbStoreItem(idxItem)
            else
              raise _INTL("Couldn't return unused item to Bag somehow.")
            end
          end
          return false
        end
      end
    end
    if ItemHandlers.hasUseInBattle(idxItem)
      if idxPokemon==0 # Player's first Pokémon
        if ItemHandlers.triggerBattleUseOnBattler(idxItem,@battlers[idxPokemon],self)
          # Using Poké Balls or Poké Doll only
          ItemHandlers.triggerUseInBattle(idxItem,@battlers[idxPokemon],self)
          if @doublebattle
            @battlers[idxPokemon].pbPartner.effects[PBEffects::SkipTurn]=true
          end
        else
          if $PokemonBag.pbCanStore?(idxItem)
            $PokemonBag.pbStoreItem(idxItem)
          else
            raise _INTL("Couldn't return unusable item to Bag somehow.")
          end
          return false
        end
      els
        if ItemHandlers.triggerBattleUseOnBattler(idxItem,@battlers[idxPokemon],self) && !BossBattleData.is2v1BossBattle? && !sosbattle
          pbDisplay(_INTL("It's impossible to aim without being focused!"))
        end
        return false
      end
    end
    @choices[idxPokemon][0]=3         # "Use an item"
    @choices[idxPokemon][1]=idxItem   # ID of item to be used
    @choices[idxPokemon][2]=idxTarget # Index of Pokémon to use item on
    side=(pbIsOpposing?(idxPokemon)) ? 1 : 0
    owner=pbGetOwnerIndex(idxPokemon)
    if @megaEvolution[side][owner]==idxPokemon
      @megaEvolution[side][owner]=-1
    end
    return true
  end
end
#===============================================================================
# Method for the Boss Battle Capturing
#===============================================================================
def pbBossCapture(opponent)
  value = BossBattleData.getFaintedCatchData
  ret = 0
  if value.is_a?(Hash)
    showChoices=false
    mePlayer=""
      valArr=[BossBattleData::RecruitText,BossBattleData::RecruitedText,-1,BossBattleData::FaintedChoices]
    if value[:catchStyle]==1
      valArr=[BossBattleData::WeakenedText,BossBattleData::WeakenedText,-1,BossBattleData::FaintedChoices]
    end
    if value[:dialogue].is_a?(String)
      valArr[0]=value[:dialogue]
    end
    if value[:afterJoin].is_a?(String)
      valArr[1]=value[:afterJoin]
    end
    if value[:catchRate].is_a?(Numeric)
      valArr[2]=value[:catchRate]
      valArr[2]=-1 #if !valArr[2]<0 || valArr[2]<0
    end
    if value[:joinME].is_a?(String) && value[:joinME] != ""
      mePlayer=value[:joinME]
    end
    if (value[:choices].is_a?(Array) && value[:choices].length==2)
      valArr[3]=value[:choices]
      valArr[3]=BossBattleData::FaintedChoices if !valArr[3][0].is_a?(String) || !valArr[3][1].is_a?(String)
    end
    if valArr[3].is_a?(Array)  && valArr[3].length==2
      showChoices=true
    end
  end
  if value[:catchStyle]==1
    @battle.pbDisplayPaused(_INTL(valArr[0],opponent.pbThis))
    command = Kernel.pbShowCommands(nil,valArr[3])
    if command!=1
      pbFadeOutIn(99999){
        scene = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene,$PokemonBag)
        ret = screen.pbChooseItemScreen(Proc.new{|item| pbIsPokeBall?(item) })
      }
      if ret>0 && pbIsPokeBall?(ret)
        $PokemonBag.pbDeleteItem(ret,1)
        if valArr[2]<0 || ret==getID(PBItems,:MASTERBALL) || rand(valArr[2])<1
          @battle.pbThrowPokeBall(1,ret,900)
          return true
        else
          @battle.pbThrowPokeBall(1,ret,0)
        end
      end
    end
  elsif value[:catchStyle]==0
    if valArr[2]<0 || rand(valArr[2])<1
      @battle.pbDisplayPaused(_INTL(valArr[0],opponent.pbThis))
      if showChoices
        command = Kernel.pbShowCommands(nil,valArr[3])
        if command==1
          return false
        end
      end
      pbMEPlay(mePlayer) if mePlayer != ""
      @battle.pbDisplayPaused(_INTL(valArr[1],opponent.name))
      opponent.pokemon.heal
      pbStorePokemon(opponent.pokemon)
      return true
    end
  end
  return false
end

#===============================================================================
# Rewrite to Trainer Battles to for 2v1 Boss Battle Method. Credits to Nyaruko
#===============================================================================
def pbTrainerBattle(trainerid,trainername,endspeech,
                    doublebattle=false,trainerparty=0,canlose=false,variable=nil)
  if $Trainer.pokemonCount==0
    Kernel.pbMessage(_INTL("SKIPPING BATTLE...")) if $DEBUG
    return false
  end
  if !$PokemonTemp.waitingTrainer && pbMapInterpreterRunning? &&
     ($Trainer.ablePokemonCount>1 || $Trainer.ablePokemonCount>0 && $PokemonGlobal.partner)
    thisEvent = pbMapInterpreter.get_character(0)
    triggeredEvents = $game_player.pbTriggeredTrainerEvents([2],false)
    otherEvent = []
    for i in triggeredEvents
      if i.id!=thisEvent.id && !$game_self_switches[[$game_map.map_id,i.id,"A"]]
        otherEvent.push(i)
      end
    end
    if otherEvent.length==1
      trainer = pbLoadTrainer(trainerid,trainername,trainerparty)
      Events.onTrainerPartyLoad.trigger(nil,trainer)
      if !trainer
        pbMissingTrainer(trainerid,trainername,trainerparty)
        return false
      end
      if trainer[2].length<=6
        $PokemonTemp.waitingTrainer=[trainer,thisEvent.id,endspeech]
        return false
      end
    end
  end
  trainer = pbLoadTrainer(trainerid,trainername,trainerparty)
  Events.onTrainerPartyLoad.trigger(nil,trainer)
  if !trainer
    pbMissingTrainer(trainerid,trainername,trainerparty)
    return false
  end
  if $PokemonGlobal.partner && ($PokemonTemp.waitingTrainer || doublebattle)
    othertrainer = PokeBattle_Trainer.new($PokemonGlobal.partner[1],$PokemonGlobal.partner[0])
    othertrainer.id    = $PokemonGlobal.partner[2]
    othertrainer.party = $PokemonGlobal.partner[3]
    playerparty = []
    for i in 0...$Trainer.party.length
      playerparty[i] = $Trainer.party[i]
    end
    for i in 0...othertrainer.party.length
      playerparty[6+i] = othertrainer.party[i]
    end
    playertrainer = [$Trainer,othertrainer]
    fullparty1    = true
    doublebattle  = true
  else
    playerparty   = $Trainer.party
    playertrainer = $Trainer
    fullparty1    = false
  end
  if $PokemonTemp.waitingTrainer
    combinedParty = []
    fullparty2 = false
    if $PokemonTemp.waitingTrainer[0][2].length>3 || trainer[2].length>3
      for i in 0...$PokemonTemp.waitingTrainer[0][2].length
        combinedParty[i] = $PokemonTemp.waitingTrainer[0][2][i]
      end
      for i in 0...trainer[2].length
        combinedParty[6+i] = trainer[2][i]
      end
      fullparty2 = true
    else
      for i in 0...$PokemonTemp.waitingTrainer[0][2].length
        combinedParty[i] = $PokemonTemp.waitingTrainer[0][2][i]
      end
      for i in 0...trainer[2].length
        combinedParty[3+i] = trainer[2][i]
      end
    end
    scene = pbNewBattleScene
    battle = PokeBattle_Battle.new(scene,playerparty,combinedParty,playertrainer,
                                   [$PokemonTemp.waitingTrainer[0][0],trainer[0]])
    battle.fullparty1   = fullparty1
    battle.fullparty2   = fullparty2
    battle.doublebattle = battle.pbDoubleBattleAllowed?
    battle.endspeech    = $PokemonTemp.waitingTrainer[2]
    battle.endspeech2   = endspeech
    battle.items        = [$PokemonTemp.waitingTrainer[0][1],trainer[1]]
    trainerbgm = pbGetTrainerBattleBGM([$PokemonTemp.waitingTrainer[0][0],trainer[0]])
  else
    scene = pbNewBattleScene
    battle = PokeBattle_Battle.new(scene,playerparty,trainer[2],playertrainer,trainer[0])
    battle.fullparty1   = fullparty1
    battle.doublebattle = doublebattle
    battle.endspeech    = endspeech
    battle.items        = trainer[1]
    trainerbgm = pbGetTrainerBattleBGM(trainer[0])
  end
  if Input.press?(Input::CTRL) && $DEBUG
    Kernel.pbMessage(_INTL("SKIPPING BATTLE..."))
    Kernel.pbMessage(_INTL("AFTER LOSING..."))
    Kernel.pbMessage(battle.endspeech)
    Kernel.pbMessage(battle.endspeech2) if battle.endspeech2
    if $PokemonTemp.waitingTrainer
      pbMapInterpreter.pbSetSelfSwitch($PokemonTemp.waitingTrainer[1],"A",true)
      $PokemonTemp.waitingTrainer = nil
    end
    return true
  end
  Events.onStartBattle.trigger(nil,nil)
  battle.internalbattle = true
  pbPrepareBattle(battle)
  restorebgm = true
  decision = 0
  Audio.me_stop
  tr = [trainer]; tr.push($PokemonTemp.waitingTrainer[0]) if $PokemonTemp.waitingTrainer
  pbBattleAnimation(trainerbgm,(battle.doublebattle) ? 3 : 1,tr) {
    pbSceneStandby {
      decision = battle.pbStartBattle(canlose)
    }
    pbAfterBattle(decision,canlose)
    if decision==1
      if $PokemonTemp.waitingTrainer
        pbMapInterpreter.pbSetSelfSwitch($PokemonTemp.waitingTrainer[1],"A",true)
      end
    end
  }
  Input.update
  pbSet(variable,decision)
  $PokemonTemp.waitingTrainer = nil
  return (decision==1)
end

#===============================================================================
# 2v1 Boss Battle Method. Credits to Nyaruko
#===============================================================================
def pbBossFight(species1,level1,variable=nil,canescape=true,canlose=false)
  if (Input.press?(Input::CTRL) && $DEBUG) || $Trainer.pokemonCount==0
    if $Trainer.pokemonCount>0
      Kernel.pbMessage(_INTL("Skipping Battle..."))
    end
    pbSet(variable,1)
    $PokemonGlobal.nextBattleBGM=nil
    $PokemonGlobal.nextBattleME=nil
    $PokemonGlobal.nextBattleBack=nil
    return true
  end
  if species1.is_a?(String) || species1.is_a?(Symbol)
    species1=getID(PBSpecies,species1)
  end
  currentlevels=[]
  for i in $Trainer.party
    currentlevels.push(i.level)
  end
  genwildpoke=pbGenerateWildPokemon(species1,level1)
  Events.onStartBattle.trigger(nil,genwildpoke)
  scene=pbNewBattleScene
  if $PokemonGlobal.partner
    othertrainer=PokeBattle_Trainer.new(
       $PokemonGlobal.partner[1],$PokemonGlobal.partner[0])
    othertrainer.id=$PokemonGlobal.partner[2]
    othertrainer.party=$PokemonGlobal.partner[3]
    combinedParty=[]
    for i in 0...$Trainer.party.length
      combinedParty[i]=$Trainer.party[i]
    end
    for i in 0...othertrainer.party.length
      combinedParty[6+i]=othertrainer.party[i]
    end
    battle=PokeBattle_Battle.new(scene,combinedParty,[genwildpoke],
       [$Trainer,othertrainer],nil)
    battle.fullparty1=true
  else
    battle=PokeBattle_Battle.new(scene,$Trainer.party,[genwildpoke],
       $Trainer,nil)
    battle.fullparty1=false
  end
  battle.internalbattle=true
  battle.doublebattle=battle.pbDoubleBattleAllowed?()
  battle.doublebattle=true if $Trainer.party.length>1
  battle.cantescape=!canescape
  pbPrepareBattle(battle)
  decision=0
#  pbAfterBattle(decision,canlose)
  pbBattleAnimation(pbGetWildBattleBGM(species1)) { 
     pbSceneStandby {
        decision=battle.pbStartBattle(canlose)
     }
     pbAfterBattle(decision,canlose)
  }
  Input.update
  pbSet(variable,decision)
  return (decision !=2 && decision !=5)
end

#===============================================================================
# Rewrite to the VictoryME to play Proper ME when Battling
#===============================================================================
def pbGetWildVictoryME
  ret = nil
  if !ret && $game_map
    # Check map-specific metadata
    music = pbGetMetadata($game_map.map_id,MetadataMapWildVictoryME)
    if music && music!=""
      ret = pbStringToAudioFile(music)
    end
  end
  if !ret
    # Check global metadata
    music = pbGetMetadata(0,MetadataWildVictoryME)
    if $PokemonGlobal.nextBattleME
      music = $PokemonGlobal.nextBattleME.clone
    end
    if music && music!=""
      ret = pbStringToAudioFile(music)
    end
  end
  ret = pbStringToAudioFile("Battle victory") if !ret
  ret.name = "../../Audio/ME/"+ret.name
  return ret
end

#===============================================================================
# Rewrite to the Trainer Loading to apply Muliple Form Fix
#===============================================================================
def pbLoadTrainer(trainerid,trainername,partyid=0)
  if trainerid.is_a?(String) || trainerid.is_a?(Symbol)
    if !hasConst?(PBTrainers,trainerid)
      raise _INTL("Trainer type does not exist ({1}, {2}, ID {3})",trainerid,trainername,partyid)
    end
    trainerid=getID(PBTrainers,trainerid)
  end
  success=false
  items=[]
  party=[]
  opponent=nil
  trainers=load_data("Data/trainers.dat")
  for trainer in trainers
    name=trainer[1]
    thistrainerid=trainer[0]
    thispartyid=trainer[4]
    next if trainerid!=thistrainerid || name!=trainername || partyid!=thispartyid
    items=trainer[2].clone
    name=pbGetMessageFromHash(MessageTypes::TrainerNames,name)
    for i in RIVALNAMES
      if isConst?(trainerid,PBTrainers,i[0]) && $game_variables[i[1]]!=0
        name=$game_variables[i[1]]
      end
    end
    opponent=PokeBattle_Trainer.new(name,thistrainerid)
    opponent.setForeignID($Trainer) if $Trainer
    for poke in trainer[3]
      species=poke[TPSPECIES]
      level=poke[TPLEVEL]
      pokemon=PokeBattle_Pokemon.new(species,level,opponent)
      pokemon.forcedForm = poke[TPFORM] if poke[TPFORM]!=0 && MultipleForms.hasFunction?(pokemon.species,"getForm")
      pokemon.resetMoves
      pokemon.setItem(poke[TPITEM])
      if poke[TPMOVE1]>0 || poke[TPMOVE2]>0 || poke[TPMOVE3]>0 || poke[TPMOVE4]>0
        k=0
        for move in [TPMOVE1,TPMOVE2,TPMOVE3,TPMOVE4]
          pokemon.moves[k]=PBMove.new(poke[move])
          k+=1
        end
        pokemon.moves.compact!
      end
      pokemon.setAbility(poke[TPABILITY])
      pokemon.setGender(poke[TPGENDER])
      if poke[TPSHINY]   # if this is a shiny Pokémon
        pokemon.makeShiny
      else
        pokemon.makeNotShiny
      end
      pokemon.setNature(poke[TPNATURE])
      iv=poke[TPIV]
      for i in 0...6
        pokemon.iv[i]=iv&0x1F
        pokemon.ev[i]=[85,level*3/2].min
      end
      pokemon.happiness=poke[TPHAPPINESS]
      pokemon.name=poke[TPNAME] if poke[TPNAME] && poke[TPNAME]!=""
      if poke[TPSHADOW]   # if this is a Shadow Pokémon
        pokemon.makeShadow rescue nil
        pokemon.pbUpdateShadowMoves(true) rescue nil
        pokemon.makeNotShiny
      end
      pokemon.ballused=poke[TPBALL]
      pokemon.calcStats
      party.push(pokemon)
    end
    success=true
    break
  end
  return success ? [opponent,items,party] : nil
end

#===============================================================================
# SOS Chaining Credits: Vendlily
#===============================================================================

class PokeBattle_Battle
  attr_accessor :adrenalineorb
  attr_accessor :lastturncalled
  attr_accessor :lastturnanswered
  attr_accessor :soschain
  attr_accessor :sosbattle
  attr_accessor :wasdoublebattle
  
  def soschain
    return @soschain || 0
  end
  
  def pbSpecialSOSMons(caller,mons)
    return mons
  end
  
  
  def pbCallForHelp(index,caller,forceMon=[])
    cspecies=getConstantName(PBSpecies,caller.species).to_sym
    if BossBattleData.isBossBattle?
      if BossBattleData.getSOSData.is_a?(Hash) 
        if BossBattleData.getSOSData[:rate].is_a?(Numeric)
          rate=BossBattleData.getSOSData[:rate]
        else
          rate=0
        end
      else
        rate=0
      end
    elsif USING_SOS_CHAINING
      rate=SOS_CALL_RATES[cspecies] || 0
    end
    if forceMon != []
      rate=100
    end
    return if rate==0 # should never trigger anyways but you never know.
    if BossBattleData.getSOSData.is_a?(Hash) 
      if BossBattleData.getSOSData[:message].is_a?(String)
        message=BossBattleData.getSOSData[:message] 
      else
        message=BossBattleData::CallText
      end
      if BossBattleData.getSOSData[:appear].is_a?(String)
        appear=BossBattleData.getSOSData[:appear] 
      else
        appear="{1} appeared!"
      end
    else
      message=BossBattleData::CallText
      appear="{1} appeared!"
    end
    pbDisplay(_INTL(message,caller.pbThis))
    rate*=4 # base rate
    rate=rate.to_f # don't want to lose decimal points
    pbattler=@battlers[0]
    if pbattler.hasWorkingAbility(:INTIMIDATE) ||
       pbattler.hasWorkingAbility(:UNNERVE) ||
       pbattler.hasWorkingAbility(:PRESSURE)
      rate*=1.2
    end
    if @lastturncalled==@turncount-1
      rate*=1.5
    end
    if !@lastturnanswered
      rate*=3.0
    end
    rate=rate.round # rounding it off.
    pbDisplayBrief(_INTL("... ... ..."))
    if pbRandom(100)<rate
      @lastturnanswered=true
      @lastturncalled=@turncount
      if BossBattleData.isBossBattle?
        if BossBattleData.getSOSData.is_a?(Hash) 
          if BossBattleData.getSOSData[:ally].is_a?(Array) 
            mons=BossBattleData.getSOSData[:ally] 
          else
            mons=[caller.species]
          end
        else
          mons=[caller.species]
        end
      elsif USING_SOS_CHAINING
        mons=SOS_CALL_MONS[cspecies] || [caller.species]
        mons=pbSpecialSOSMons(caller,mons)
      end
      if forceMon != []
        mons=forceMon
      end
      mon=mons[pbRandom(mons.length)]
      alevel=caller.level-1
      alevel=1 if alevel<1
      ally=pbGenerateSOSPokemon(getID(PBSpecies,mon),alevel)
      @battlers[index].pbInitialize(ally,(index>>1),false)
      @wasdoublebattle=@doublebattle if @wasdoublebattle.nil?
      @doublebattle=true if !@doublebattle
      @sosbattle=true
      @scene.pbSOSJoin(index,ally)
      pbDisplayBrief(_INTL(appear,@battlers[index].name,caller.name))
      caller.pbPartner.effects[PBEffects::SkipTurn]=true
      caller.effects[PBEffects::SkipTurn]=true
      @party2.push(ally)
    else
      @lastturnanswered=false
      pbDisplay(_INTL("Its help didn't appear!"))
    end
  end
  
  def pbGenerateSOSPokemon(species,level)
    genwildpoke = PokeBattle_Pokemon.new(species,level,$Trainer)
    items = genwildpoke.wildHoldItems
    firstpoke = @battlers[0]
    chances = [50,5,1]
    chances = [60,20,5] if firstpoke.hasWorkingAbility(:COMPOUNDEYES)
    itemrnd = rand(100)
    if itemrnd<chances[0] || (items[0]==items[1] && items[1]==items[2])
      genwildpoke.setItem(items[0])
    elsif itemrnd<(chances[0]+chances[1])
      genwildpoke.setItem(items[1])
    elsif itemrnd<(chances[0]+chances[1]+chances[2])
      genwildpoke.setItem(items[2])
    end
    if hasConst?(PBItems,:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
      for i in 0...2   # 3 times as likely
        break if genwildpoke.isShiny?
        genwildpoke.personalID = rand(65536)|(rand(65536)<<16)
      end
    end
    chain=self.soschain
    shinychain=(chain/10)
    shinychain-=1 if chain%10==0
    if shinychain>0
      for i in 0...shinychain
        break if genwildpoke.isShiny?
        genwildpoke.personalID = rand(65536)|(rand(65536)<<16)
      end
    end
    ivchain=(chain/10)
    ivchain+=1 if chain>=5
    ivs=(0..5).to_a
    ivs.shuffle!
    if ivchain>0
      for i in 0...ivchain
        break if ivs.length==0
        iv=ivs.shift
        genwildpoke.ivs[iv]=31
      end
    end
    hachain=(chain/10)
    if hachain>0
      genwildpoke.setAbility(2) if pbRandom(100)<hachain*5
    end
    if rand(65536)<POKERUSCHANCE
      genwildpoke.givePokerus
    end
    if firstpoke.hasWorkingAbility(:CUTECHARM) && !genwildpoke.isSingleGendered?
      if firstpoke.gender==0
        (rand(3)<2) ? genwildpoke.makeFemale : genwildpoke.makeMale
      elsif firstpoke.gender==1
        (rand(3)<2) ? genwildpoke.makeMale : genwildpoke.makeFemale
      end
    elsif firstpoke.hasWorkingAbility(:SYNCHRONIZE)
      genwildpoke.setNature(firstpoke.nature) if rand(10)<5
    end
    Events.onWildPokemonCreate.trigger(nil,genwildpoke)
    return genwildpoke
  end
  
  def pbSwitch(favorDraws=false)
    if !favorDraws
      return if @decision>0
    else
      return if @decision==5
    end
    pbJudge()
    return if @decision>0
    firstbattlerhp=@battlers[0].hp
    switched=[]
    for index in 0...4
      next if !@doublebattle && pbIsDoubleBattler?(index)
      next if @battlers[index] && !@battlers[index].fainted?
      next if !pbCanChooseNonActive?(index)
      if !pbOwnedByPlayer?(index)
        if !pbIsOpposing?(index) || (@opponent && pbIsOpposing?(index))
          newenemy=pbSwitchInBetween(index,false,false)
          newenemyname=newenemy
          if newenemy>=0 && isConst?(pbParty(index)[newenemy].ability,PBAbilities,:ILLUSION)
            newenemyname=pbGetLastPokeInTeam(index)
          end
          opponent=pbGetOwner(index)
          if !@doublebattle && firstbattlerhp>0 && @shiftStyle && @opponent &&
              @internalbattle && pbCanChooseNonActive?(0) && pbIsOpposing?(index) &&
              @battlers[0].effects[PBEffects::Outrage]==0
            pbDisplayPaused(_INTL("{1} is about to send in {2}.",opponent.fullname,pbParty(index)[newenemyname].name))
            if pbDisplayConfirm(_INTL("Will {1} change Pokémon?",self.pbPlayer.name))
              newpoke=pbSwitchPlayer(0,true,true)
              if newpoke>=0
                newpokename=newpoke
                if isConst?(@party1[newpoke].ability,PBAbilities,:ILLUSION)
                  newpokename=pbGetLastPokeInTeam(0)
                end
                pbDisplayBrief(_INTL("{1}, that's enough! Come back!",@battlers[0].name))
                pbRecallAndReplace(0,newpoke,newpokename)
                switched.push(0)
              end
            end
          end
          pbRecallAndReplace(index,newenemy,newenemyname,false,false)
          switched.push(index)
        end
      elsif @opponent
        newpoke=pbSwitchInBetween(index,true,false)
        newpokename=newpoke
        if isConst?(@party1[newpoke].ability,PBAbilities,:ILLUSION)
          newpokename=pbGetLastPokeInTeam(index)
        end
        pbRecallAndReplace(index,newpoke,newpokename)
        switched.push(index)
      else
        next if @sosbattle && !@wasdoublebattle
        switch=false
        if !pbDisplayConfirm(_INTL("Use next Pokémon?"))
          switch=(pbRun(index,true)<=0)
        else
          switch=true
        end
        if switch
          newpoke=pbSwitchInBetween(index,true,false)
          newpokename=newpoke
          if isConst?(@party1[newpoke].ability,PBAbilities,:ILLUSION)
            newpokename=pbGetLastPokeInTeam(index)
          end
          pbRecallAndReplace(index,newpoke,newpokename)
          switched.push(index)
        end
      end
    end
    if switched.length>0
      priority=pbPriority
      for i in priority
        i.pbAbilitiesOnSwitchIn(true) if switched.include?(i.index)
      end
    end
  end
  
end
 
class PokeBattle_Battler
  def pbCanCall?(forced=false)
    if !BossBattleData.isBossBattle? && USING_SOS_CHAINING
      return false if NO_SOS_BATTLES>0 &&  $game_switches[NO_SOS_BATTLES]
    end
    if BossBattleData.isBossBattle?
      return false if !self.isBoss?
    end
    # only wild battles
    return false if @opponent
    # only wild mons
    return false if !@battle.pbIsOpposing?(self.index)
    # can't call if partner already in
    return false if !self.pbPartner.fainted?
    # just to be safe
    return false if self.fainted?
    # no call if status
    return false if self.status!=0
    # no call if multiturn attack
    return false if self.effects[PBEffects::TwoTurnAttack]>0
    return false if self.effects[PBEffects::HyperBeam]>0
    return false if self.effects[PBEffects::Rollout]>0
    return false if self.effects[PBEffects::Outrage]>0
    return false if self.effects[PBEffects::Uproar]>0
    return false if self.effects[PBEffects::Bide]>0
    rate=0
    species=getConstantName(PBSpecies,self.species).to_sym
    if BossBattleData.isBossBattle?
      if BossBattleData.getSOSData.is_a?(Hash)
        if BossBattleData.getSOSData[:rate].is_a?(Numeric)
          rate=BossBattleData.getSOSData[:rate]
        else
          rate=0
        end
      else
        rate=0
      end
    elsif USING_SOS_CHAINING
      rate=SOS_CALL_RATES[species] || 0
    end
    if forced
      rate=100
    end
    # not a species that calls
    return false if rate==0
    rate*=3 if self.hp>(self.totalhp/4) && self.hp<=(self.totalhp/2)
    rate*=5 if self.hp<=(self.totalhp/4)
    rate*=2 if @battle.adrenalineorb
    return @battle.pbRandom(100)<rate
  end
  
  def pbProcessTurn(choice)
    # Can't use a move if fainted
    return false if fainted?
    # Wild roaming Pokémon always flee if possible
    if !@battle.opponent && @battle.pbIsOpposing?(self.index) &&
       @battle.rules["alwaysflee"] && @battle.pbCanRun?(self.index)
      pbBeginTurn(choice)
      @battle.pbDisplay(_INTL("{1} fled!",self.pbThis))
      @battle.decision=3
      pbEndTurn(choice)
      PBDebug.log("[Escape] #{pbThis} fled")
      return true
    end
    if pbCanCall?
      pbCancelMoves
      @battle.pbCallForHelp(self.pbPartner.index,self)
      pbEndTurn(choice)
      return true
    end
    # If this battler's action for this round wasn't "use a move"
    if choice[0]!=1
      # Clean up effects that end at battler's turn
      pbBeginTurn(choice)
      pbEndTurn(choice)
      return false
    end
    # Turn is skipped if Pursuit was used during switch
    if @effects[PBEffects::Pursuit]
      @effects[PBEffects::Pursuit]=false
      pbCancelMoves
      pbEndTurn(choice)
      @battle.pbJudge #      @battle.pbSwitch
      return false
    end
    # Use the move
#   @battle.pbDisplayPaused("Before: [#{@lastMoveUsedSketch},#{@lastMoveUsed}]")
    PBDebug.log("#{pbThis} used #{choice[2].name}")
    PBDebug.logonerr{
       pbUseMove(choice,choice[2]==@battle.struggle)
    }
#   @battle.pbDisplayPaused("After: [#{@lastMoveUsedSketch},#{@lastMoveUsed}]")
    return true
  end
end
 
class PokeBattle_Scene
  def pbSelectBattler(index,selectmode=1)
    numwindows=@battle.doublebattle ? 4 : 2
    for i in 0...numwindows
      next if @battle.sosbattle && !@battle.wasdoublebattle && i == 2
      sprite=@sprites["battlebox#{i}"]
      sprite.selected=(i==index) ? selectmode : 0
      sprite=@sprites["pokemon#{i}"]
      sprite.selected=(i==index) ? selectmode : 0
    end
  end
  
  def pbUpdateSelected(index)
    numwindows=@battle.doublebattle ? 4 : 2
    for i in 0...numwindows
      next if @battle.sosbattle && !@battle.wasdoublebattle && (i == 2)
      if i==index
        @sprites["battlebox#{i}"].selected=2
        @sprites["pokemon#{i}"].selected=2
      else
        @sprites["battlebox#{i}"].selected=0
        @sprites["pokemon#{i}"].selected=0
      end
    end
    pbFrameUpdate
  end
  
  def pbSOSJoin(battlerindex,pkmn)
    @briefmessage=false
    frame=0
    if !@sprites["pokemon#{battlerindex}"]
      @sprites["pokemon#{battlerindex}"]=PokemonBattlerSprite.new(@battle.doublebattle,battlerindex,@viewport)
      @sprites["pokemon#{battlerindex}"].z=(battlerindex==3)? 11 : 26
      if battlerindex&1==1
        pbAddSprite("shadow#{battlerindex}",0,0,"Graphics/Pictures/Battle/object_shadow",@viewport)
      else
        @sprites["shadow#{battlerindex}"]=IconSprite.new(0,0,@viewport)
      end
      @sprites["shadow#{battlerindex}"].z=3
      @sprites["shadow#{battlerindex}"].visible=false
    end
    @sprites["pokemon#{battlerindex}"].setPokemonBitmap(pkmn,false)
    sendout=SOSJoinAnimation.new(@sprites["pokemon#{battlerindex}"],
       @sprites,@battle.battlers[battlerindex],@battle.doublebattle,@battle)
    partnerindex=-1
    if !@sprites["battlebox#{battlerindex}"]
      partnerindex=(battlerindex&1)|((battlerindex&2)^2)
      @sprites["battlebox#{battlerindex}"]=PokemonDataBox.new(@battle.battlers[battlerindex],@battle.doublebattle,@viewport)
      @sprites["battlebox#{partnerindex}"].dispose
      @sprites["battlebox#{partnerindex}"]=PokemonDataBox.new(@battle.battlers[partnerindex],@battle.doublebattle,@viewport)
    end
    loop do
      frame+=1    
      if frame==1
        @sprites["battlebox#{battlerindex}"].appear
        if partnerindex>=0
          @sprites["battlebox#{partnerindex}"].appear
        end
      end
      if frame>=6
        sendout.update
      end
      pbGraphicsUpdate
      pbInputUpdate
      pbFrameUpdate
      break if sendout.animdone? &&
         !@sprites["battlebox#{battlerindex}"].appearing
    end
    if @battle.battlers[battlerindex].isShiny? && @battle.battlescene
      pbCommonAnimation("Shiny",@battle.battlers[battlerindex],nil)
    end
    sendout.dispose
    pbRefresh
  end
end
 
class SOSJoinAnimation
  def initialize(sprite,spritehash,pkmn,doublebattle,battle)
    @disposed=false
    @PokemonBattlerSprite=sprite
    @PokemonBattlerSprite.visible=false
    @PokemonBattlerSprite.src_rect.height=@PokemonBattlerSprite.bitmap.height
    @PokemonBattlerSprite.oy=0
    @PokemonBattlerSprite.tone=Tone.new(0,0,0,248)
    if doublebattle
      @spritex=PokeBattle_SceneConstants::FOEBATTLERD1_X if pkmn.index==1
      @spritex=PokeBattle_SceneConstants::FOEBATTLERD2_X if pkmn.index==3
    else
      @spritex=PokeBattle_SceneConstants::FOEBATTLER_X
    end
    @spritey=adjustBattleSpriteY(sprite,pkmn.species,pkmn.index)
    if doublebattle
      @spritey+=PokeBattle_SceneConstants::FOEBATTLERD1_Y if pkmn.index==1
      @spritey+=PokeBattle_SceneConstants::FOEBATTLERD2_Y if pkmn.index==3
    else
      @spritey+=PokeBattle_SceneConstants::FOEBATTLER_Y
    end
    
    @spritehash=spritehash
    @pkmn=pkmn
    @shadowX=@spritex
    @shadowY=@spritey/2
    if @spritehash["shadow#{@pkmn.index}"] && @spritehash["shadow#{@pkmn.index}"].bitmap!=nil
      @shadowX-=@spritehash["shadow#{@pkmn.index}"].bitmap.width/2
      @shadowY-=@spritehash["shadow#{@pkmn.index}"].bitmap.height/2
    end
    if @spritehash["pokemon#{@pkmn.pbPartner.index}"]
      pindex=@pkmn.pbPartner.index
      pmon=battle.battlers[pindex]
      case pindex
      when 1
        @spritehash["pokemon#{pindex}"].x=PokeBattle_SceneConstants::FOEBATTLERD1_X
        @spritehash["pokemon#{pindex}"].y=PokeBattle_SceneConstants::FOEBATTLERD1_Y
      when 3
        @spritehash["pokemon#{pindex}"].x=PokeBattle_SceneConstants::FOEBATTLERD2_X
        @spritehash["pokemon#{pindex}"].y=PokeBattle_SceneConstants::FOEBATTLERD2_Y
      end
      @spritehash["pokemon#{pindex}"].x-=@spritehash["pokemon#{pindex}"].bitmap.width/2
      @spritehash["pokemon#{pindex}"].y+=adjustBattleSpriteY(@spritehash["pokemon#{pindex}"],pmon.species,pmon.index)
      if @spritehash["shadow#{@pkmn.index}"] && @spritehash["shadow#{@pkmn.index}"].bitmap!=nil
        @spritehash["shadow#{@pkmn.index}"].x=@spritehash["pokemon#{pindex}"].x
        @spritehash["shadow#{@pkmn.index}"].x-=@spritehash["shadow#{@pkmn.index}"].bitmap.width/2
        @spritehash["shadow#{@pkmn.index}"].y=@spritehash["pokemon#{pindex}"].y/2
        @spritehash["shadow#{@pkmn.index}"].y-=@spritehash["shadow#{@pkmn.index}"].bitmap.height/2
      end
    end
    @shadowVisible=showShadow?(pkmn.species)
    @animdone=false
    @frame=0
  end
 
  def disposed?
    return @disposed
  end
 
  def animdone?
    return @animdone
  end
 
  def dispose
    return if disposed?
    @disposed=true
  end
 
  def update
    return if disposed?
    @frame+=1
    if @frame==4
      if @spritehash["shadow#{@pkmn.index}"]
        @spritehash["shadow#{@pkmn.index}"].x=@shadowX
        @spritehash["shadow#{@pkmn.index}"].y=@shadowY
        @spritehash["shadow#{@pkmn.index}"].visible=@shadowVisible
      end
      @PokemonBattlerSprite.visible=true
      pbSpriteSetCenter(@PokemonBattlerSprite,@spritex,@spritey)
      @PokemonBattlerSprite.y=@spritey
      if @pkmn.pokemon
        pbPlayCry(@pkmn.pokemon)
      else
        pbPlayCrySpecies(@pkmn.species,@pkmn.form)
      end
    end
    if @frame>8 && @frame<=24
      tone=(16-@frame)*32
      @PokemonBattlerSprite.tone=Tone.new(0,0,0,tone)
    end
    if @PokemonBattlerSprite.tone.gray<=0
      @animdone=true
    end
  end
end
 
ItemHandlers::BattleUseOnBattler.add(:ADRENALINEORB,proc{|item,battler,scene|
   battle=battler.battle
   if battle.adrenalineorb
     scene.pbDisplay(_INTL("Already used that."))
     return false
   end
   playername=battle.pbPlayer.name
   scene.pbDisplay(_INTL("{1} used the {2}.",playername,PBItems.getName(item)))
   return true
})
 
ItemHandlers::UseInBattle.add(:ADRENALINEORB,proc{|item,battler,battle|
   battle.adrenalineorb=true
   battle.pbDisplayPaused(_INTL("The {1} makes the wild Pokémon nervous!",PBItems.getName(item)))
})

#===============================================================================
# Main Boss Battle Module
#===============================================================================
module BossBattleData
  def self.set(data={})
    if data[:BOSS_BATTLE] || data[:BOSS_2V1]
      raise _INTL("Can't Manually set the Boss Battle Condition to true. Let the script handle it")
    end
    if $BossBattleVar[:BOSS_BATTLE] || $BossBattleVar[:BOSS_2V1]
      $BossBattleVar.LukaMerge(data)
    else
      data[:BOSS_BATTLE]=true
      $BossBattleVar=data
    end
  end
  
  def self.setBattleProc(data={}) # To Explain
    $BossBattleVar[:BOSS_BATTLE]=true
    if $BossBattleVar[:BATTLE_PROC] && $BossBattleVar[:BATTLE_PROC].is_a?(Hash)
      $BossBattleVar[:BATTLE_PROC].LukaMerge(data)
    else
      $BossBattleVar[:BATTLE_PROC]=data
    end
  end
  
  def self.startBossBattle(data={})
    if data[:BOSS_BATTLE] || data[:BOSS_2V1]
      raise _INTL("Can't Manually set the Boss Battle Condition to true. Let the script handle it")
    end
    if $BossBattleVar[:BOSS_BATTLE] || $BossBattleVar[:BOSS_2V1]
      $BossBattleVar.LukaMerge(data)
    else
      data[:BOSS_BATTLE]=true
      $BossBattleVar=data
    end
    canRun=false
    canLose=false
    if $BossBattleVar[:BATTLE_BGM]
      $PokemonGlobal.nextBattleBGM=$BossBattleVar[:BATTLE_BGM]
    end
    if $BossBattleVar[:BATTLE_ME]
      $PokemonGlobal.nextBattleME=$BossBattleVar[:BATTLE_ME]
    end
    if $BossBattleVar[:CAN_RUN]
      canRun=$BossBattleVar[:CAN_RUN]
    end
    if $BossBattleVar[:CAN_LOSE]
      canRun=$BossBattleVar[:CAN_LOSE]
    end
    pbWildBattle(:BULBASAUR,1,variable=nil,canRun,canLose)
  end
  
  def self.start2v1BossBattle(data={},variable=nil)
    if data[:BOSS_BATTLE] || data[:BOSS_2V1]
      raise _INTL("Can't Manually set the Boss Battle Condition to true. Let the script handle it")
    end
    if $BossBattleVar[:BOSS_BATTLE] || $BossBattleVar[:BOSS_2V1]
      $BossBattleVar.LukaMerge(data)
    else
      data[:BOSS_BATTLE]=true
      $BossBattleVar=data
    end
    $BossBattleVar[:BOSS_2V1]=true
    canRun=false
    canLose=false
    if $BossBattleVar[:BATTLE_BGM]
      $PokemonGlobal.nextBattleBGM=$BossBattleVar[:BATTLE_BGM]
    end
    if $BossBattleVar[:BATTLE_ME]
      $PokemonGlobal.nextBattleME=$BossBattleVar[:BATTLE_ME]
    end
    if $BossBattleVar[:CAN_RUN]
      canRun=$BossBattleVar[:CAN_RUN]
    end
    if $BossBattleVar[:CAN_LOSE]
      canLose=$BossBattleVar[:CAN_LOSE]
    end
    pbBossFight(:BULBASAUR,1,variable,canRun,canLose)
    return variable
  end
  
  def self.resetAll
    $BossBattleVar={:BOSS_BATTLE=>false,:BOSS_2V1=>false}
  end
  
  def self.getStatData
    if !$BossBattleVar[:STAT_RAISE]
      return false
    end
    return $BossBattleVar[:STAT_RAISE]
  end
  
  def self.getStatDisplayData
    if !$BossBattleVar[:STAT_DISPLAY]
      return false
    end
    return $BossBattleVar[:STAT_DISPLAY]
  end
  
  def self.getBattleText
    return $BossBattleVar[:BATTLE_TEXT]
  end
  
  def self.getBattleBGData
    return $BossBattleVar[:BATTLE_BG]
  end
  
  def self.getFaintedText
    return $BossBattleVar[:FAINTED_TEXT]
  end
  
  def self.getCatchRate
    if $BossBattleVar[:CATCH_RATE].is_a?(Numeric)
      return $BossBattleVar[:CATCH_RATE]
    else
      return -1
    end
  end
  
  def self.getFaintedCatchData
      data = $BossBattleVar[:CATCH_DATA]
      if data
        if !(data[:catchStyle]==0 || data[:catchStyle]==1)
          data[:catchStyle]=-1
        end
      else
        data={:catchStyle=>-1}
      end
      return data
  end

  def self.getResetData
    if $BossBattleVar[:NO_RESET]
      return $BossBattleVar[:NO_RESET]
    else
      return true
    end
  end
  
  def self.getWarnText
    return $BossBattleVar[:WARN_TEXT] 
  end
  
  def self.getTitleData
    return $BossBattleVar[:TITLE] 
  end
  
  def self.getSOSData
    return $BossBattleVar[:SOS_DATA] 
  end
  
  def self.getBattleProcData
    return $BossBattleVar[:BATTLE_PROC]
  end
  
  def self.getBattleWeatherData
    return $BossBattleVar[:BATTLE_WEATHER]
  end
  
  def self.getTotemHueData
    return $BossBattleVar[:TOTEM_HUE]
  end
  
  def self.getFaintAnimationData
    return $BossBattleVar[:TOTEM_HUE]
  end
  
  def self.getBattleBoxData
    return $BossBattleVar[:TOTEM_HUE]
  end

  def self.isBossBattle?
    if $BossBattleVar[:BOSS_BATTLE]
      return true
    end
    return false
  end
  
  def self.is2v1BossBattle?
    if $BossBattleVar[:BOSS_2V1]
      return true
    end
    return false
  end
  
  def self.getPokemonData
    if $BossBattleVar[:WILD_SPECIES]
      return $BossBattleVar[:WILD_SPECIES]
    else
      return {:WILD_SPECIES=>""}
    end
  end
end

$BossBattleVar={:BOSS_BATTLE=>false,:BOSS_2V1=>false}