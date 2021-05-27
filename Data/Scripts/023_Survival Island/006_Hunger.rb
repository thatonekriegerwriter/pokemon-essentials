#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#                                                                              #
#                             Survival Mode                                    #
#                          By thatonekriegerwriter                             #
#                 Original Hunger Script by Maurili and Vendily                #
#                                                                              #
#                                                                              #
#                                                                              #
#==============================================================================#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\#
#==============================================================================#
#Thanks Maurili and Vendily for the Original Hunger Script                     #
#It will run just fine like this, but you can also crack open "PField_Visuals" #
#and around line 634 you will find "def pbStartOver"                           #
#You can add                                                                   #
#                                                                              #
#  if $Trainer.money < 5 || $game_switches[54] == true                         #
#      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]Game Over"))                      #
#      pbCancelVehicles                                                        #
#      pbRemoveDependencies()                                                  #
#      pbEndGame                                                               #
#      return                                                                  #
#  end                                                                         #
#To make this script activate upon loss.                                       #
#Player Health in this script is regarded as the Trainer.money, as that is     #
#what it was in Pokemon Survival Island, I am absolutely positive variables    #
#can be used instead. I used:                                                  #
#------------------------------------------------------------------------------#
# $game_switches[54] for the Survival Mode Switch, and put it in the options   #
# menu personally.                                                             #
#------------------------------------------------------------------------------#
# $game_variables[208] what I used to track sleep.                             #
#------------------------------------------------------------------------------#
# $game_variables[247] also related to sleep, due to my Game using FLs Unreal  #
#Time, I gave the option to sleep X amount of hours using an Input Number menu,#
#it could be done without FLs perhaps?                                         #
#Honestly, never not had Unreal Time in my game to know.                       #
#If it's a problem, tab it out, RAGECANDYBAR,LEMONADE,SODAPOP, and SWEETHEART  #
#all restore Sleep.                                                            #
#------------------------------------------------------------------------------#
# $game_variables[205] is Maurili's hunger.                                    #
#------------------------------------------------------------------------------#
# $game_variables[206] is thirst.                                              #
#------------------------------------------------------------------------------#
# $game_variables[207] is Maurili's Saturation.                                #
#------------------------------------------------------------------------------#
# $game_variables[247] is the variable I used to restore sleep.                #
#------------------------------------------------------------------------------#
# $game_switch[249] is used to give a one time message about starving,         #
#then turn itself off to take away health.                                     #
# This has to be placed at the start of your game.                             #
#------------------------------------------------------------------------------#
# Again, $Trainer.money is used as health by default.                          #
#------------------------------------------------------------------------------#
# I used the Trainer Card to display all this information.                     #
#------------------------------------------------------------------------------#
#Beyond that, the Eating and Drinking (pbFillUp) and Medicine (pbMedicine)     #
#scripts could be attached to anything, I attached them to items called        #
#"Medicine Bag" and "Food Bag"                                                 #
#------------------------------------------------------------------------------#
#At the bottom is "pbEndGame"                                                  #
#     This should lead to a map with an autorun event that has:                #
#                                                                              #
#$scene = pbCallTitle                                                          #
#    while $scene != nil                                                       #
#      $scene.main                                                             #
#    end                                                                       #
#    Graphics.transition(20)                                                   #
# As it's script. I do not know if it still functions in 18.1, as I have not   #
#tested it, but End Games function is to well                                  #
#Cause a game over.                                                            #
#------------------------------------------------------------------------------#
#When I learn how to, I will make customizable fill ins.                       #
#------------------------------------------------------------------------------#
#Installation:                                                                 #
#I don't think it particularly has to be anywhere, mine is a good bit          #
#above main to little issue.                                                   #
#------------------------------------------------------------------------------#
#                                                                              #
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
Events.onStepTakenTransferPossible+=proc {

if $game_variables[205]>100
  $game_variables[205]=100 
  $game_switches[250]=true
end

if $game_variables[206]>100
  $game_variables[206]=100 
end

if $game_variables[207]>100
 $game_variables[207]=100 
 $game_switches[273]=true
end
 
if $game_variables[208]>100
 $game_variables[208]=100 
 $game_switches[249]=true
end

if $game_variables[205]<0
  $game_variables[205]=0 
end

if $game_variables[206]<0
  $game_variables[206]=0 
end

if $game_variables[207]<0
 $game_variables[207]=0 
 $game_switches[273]=true
end
 
if $game_variables[208]<0
 $game_variables[208]=0 
 $game_switches[249]=true
end

if $Trainer.money>100
 $Trainer.money=100 
end

if $game_switches[54]==true #Survival Mode Switch
 case $game_variables[208]
  when 0
   if $game_switches[249]==true
    pbMessage(_INTL("You are passing out from lack of sleep!"))
	Achievements.incrementProgress("INSOMNIA",1)
    $Trainer.money -= 5
    $game_switches[249]=false
   else
    $Trainer.money -= 5
   end
  else
   $game_variables[208] -= 1 if rand(20) == 5 #take from sleep
end

if $game_switches[54]==true #Survival Mode Switch
 case $game_variables[207]
  when 0
   $game_variables[205] -= 1 if rand(10) == 5 #take from hunger
   $game_variables[206] -= 1 if rand(10) == 5 #take from drinking
  else
   $game_variables[207] -= 1 if rand(10) == 5 #take from saturation
end

if $game_switches[54]==true #Survival Mode Switch
  case $game_variables[205]
   when 0
    if $game_switches[250]==true
      pbMessage(_INTL("You are passing out from lack of food!"))
	  Achievements.incrementProgress("STARVING",1)
      $Trainer.money -= 5
      $game_switches[250]=false
    else
      $Trainer.money -= 5
   end
end

if $game_switches[54]==true #Survival Mode Switch
  case $game_variables[206]
   when 0
    if $game_switches[273]==true
      pbMessage(_INTL("You are passing out from lack of water!"))
	  Achievements.incrementProgress("THIRSTY",1)
      $Trainer.money -= 5
      $game_switches[273]=false
    else
      $Trainer.money -= 5
   end
end
end
end
end #im honestly unsure why I need this mountain of ends but the script shant run without them.
end

if $Trainer.money < 1
  if $game_switches[54] == true
      pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]Game Over"))
	  Achievements.incrementProgress("DEAD",1)
      pbCancelVehicles
      pbRemoveDependencies
      pbEndGame
      return
   end
end
}

def pbSleepRestore
 if $game_variables[208]<100
  $game_variables[208]=$game_variables[208]+($game_variables[247]*6)
 end
end

#Eating Food
def pbFillUp
berry=0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
berry = screen.pbChooseItemScreen
}
if berry>0
$PokemonBag.pbDeleteItem(berry,1)
Kernel.pbMessage(_INTL("You consume the {1}. ",PBItems.getName(berry)))
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if isConst?(berry,PBItems,:ORANBERRY)
$game_variables[205]+=4
$game_variables[207]+=3
$game_variables[206]+=1
$Trainer.money += 1
elsif isConst?(berry,PBItems,:LEPPABERRY)
$game_variables[205]+=5
$game_variables[207]+=1
$game_variables[206]+=1
elsif isConst?(berry,PBItems,:SITRUSBERRY)
$game_variables[205]+=5
$game_variables[207]+=7
$game_variables[206]+=1
$Trainer.money += (0.25*$Trainer.money)
elsif isConst?(berry,PBItems,:BERRYJUICE)
$game_variables[205]+=6
$game_variables[207]+=4
$game_variables[206]+=4
$Trainer.money += 2
elsif isConst?(berry,PBItems,:FRESHWATER)
$game_variables[206]+=20
$game_variables[207]+=10#207 is Saturation
#You can add more if you want
elsif isConst?(berry,PBItems,:ATKCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:SATKCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:SPEEDCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:SPDEFCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:ACCCURRY)
$game_variables[205]+=8
$game_variables[207]+=12
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:DEFCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:CRITCURRY)
$game_variables[205]+=8
$game_variables[207]+=15
$game_variables[206]-=7
elsif isConst?(berry,PBItems,:GSCURRY)
$game_variables[205]+=8#205 is Hunger
$game_variables[207]+=5#207 is Saturation
$game_variables[206]-=7#206 is Thirst
elsif isConst?(berry,PBItems,:RAGECANDYBAR) #chocolate
$game_variables[205]+=10
$game_variables[207]+=3
$game_variables[208]+=7
elsif isConst?(berry,PBItems,:SWEETHEART) #chocolate
$game_variables[205]+=10#205 is Hunger
$game_variables[207]+=5#207 is Saturation
$game_variables[208]+=6#208 is Sleep
elsif isConst?(berry,PBItems,:SODAPOP)
$game_variables[206]-=11#206 is Thirst
$game_variables[207]+=11#207 is Saturation
$game_variables[208]+=10#208 is Sleep
elsif isConst?(berry,PBItems,:LEMONADE)
$game_variables[207]+=11#207 is Saturation
$game_variables[206]+=7#206 is Thirst
$game_variables[208]+=7#208 is Sleep
elsif isConst?(berry,PBItems,:HONEY)
$game_variables[207]+=20#207 is Saturation
$game_variables[206]+=2#206 is Thirst
$game_variables[205]+=6#205 is Hunger
elsif isConst?(berry,PBItems,:MOOMOOMILK)
$game_variables[207]+=10
$game_variables[206]+=7
elsif isConst?(berry,PBItems,:CSLOWPOKETAIL)
$game_variables[207]+=10#207 is Saturation
$game_variables[205]+=10#205 is Hunger
elsif isConst?(berry,PBItems,:BAKEDPOTATO)
$game_variables[207]+=10#207 is Saturation
$game_variables[206]+=4#206 is Thirst
$game_variables[205]+=7#205 is Hunger
elsif isConst?(berry,PBItems,:APPLE)
$game_variables[207]+=10#207 is Saturation
$game_variables[206]+=3#206 is Thirst
$game_variables[205]+=3#205 is Hunger
elsif isConst?(berry,PBItems,:CHOCOLATE)
$game_variables[207]+=5#207 is Saturation
$game_variables[205]+=7#205 is Hunger
elsif isConst?(berry,PBItems,:LEMON)
$game_variables[207]+=3#207 is Saturation
$game_variables[206]+=3#206 is Thirst
$game_variables[205]+=4#205 is Hunger
elsif isConst?(berry,PBItems,:OLDGATEAU)
$game_variables[207]+=6#207 is Saturation
$game_variables[206]+=2#206 is Thirst
$game_variables[205]+=6#205 is Hunger
elsif isConst?(berry,PBItems,:LAVACOOKIE)
$game_variables[207]+=5#207 is Saturation
$game_variables[206]-=3#206 is Thirst
$game_variables[205]+=6#205 is Hunger
elsif isConst?(berry,PBItems,:CASTELIACONE)
$game_variables[206]+=7#206 is Thirst
$game_variables[205]+=7#205 is Hunger
elsif isConst?(berry,PBItems,:LUMIOSEGALETTE)
$game_variables[207]+=5#207 is Saturation
$game_variables[205]+=6#205 is Hunger
elsif isConst?(berry,PBItems,:SHALOURSABLE)
$game_variables[207]+=8#207 is Saturation
$game_variables[205]+=8#205 is Hunger
elsif isConst?(berry,PBItems,:BIGMALASADA)
$game_variables[207]+=8#207 is Saturation
$game_variables[205]+=8#205 is Hunger
elsif isConst?(berry,PBItems,:ONION)
$game_variables[207]+=5#207 is Saturation
$game_variables[206]+=3#206 is Thirst
$game_variables[205]+=3#205 is Hunger
elsif isConst?(berry,PBItems,:COOKEDORAN)
$game_variables[207]+=6#207 is Saturation
$game_variables[206]+=6#206 is Thirst
$game_variables[205]+=6#205 is Hunger
elsif isConst?(berry,PBItems,:CARROT)
$game_variables[207]+=6#207 is Saturation
$game_variables[206]+=3#206 is Thirst
$game_variables[205]+=3#205 is Hunger
elsif isConst?(berry,PBItems,:BREAD)
$game_variables[207]+=10#207 is Saturation
$game_variables[206]+=7#206 is Thirst
$game_variables[205]+=11#205 is Hunger
elsif isConst?(berry,PBItems,:TEA)
$game_variables[207]+=8#207 is Saturation
$game_variables[206]+=8#206 is Thirst
$game_variables[205]+=2#205 is Hunger
elsif isConst?(berry,PBItems,:CARROTCAKE)
$game_variables[207]+=10#207 is Saturation
$game_variables[206]+=10#206 is Thirst
$game_variables[205]+=8#205 is Hunger
#full belly
end
end
end 


def pbMedicine
medicine=0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
medicine = screen.pbChooseItemScreen
}
if medicine>0
$PokemonBag.pbDeleteItem(medicine,1)
Kernel.pbMessage(_INTL("You consume the {1}. ",PBItems.getName(medicine)))
#205 is Hunger, 207 is Saturation, 206 is Thirst, 208 is Sleep
if isConst?(medicine,PBItems,:POTION)
$Trainer.money += 20
elsif isConst?(medicine,PBItems,:SUPERPOTION)
$Trainer.money += 40
elsif isConst?(medicine,PBItems,:HYPERPOTION)
$Trainer.money += 60
elsif isConst?(medicine,PBItems,:FULLRESTORE)
$Trainer.money += 100
#full belly
end
end
end 

def pbEndGame
  if $scene.is_a?(Scene_Map)
      pbFadeOutIn(99999){
         $game_temp.player_transferring = true
         $game_temp.player_new_map_id=292  
         $game_temp.player_new_x=002
         $game_temp.player_new_y=007
         $game_temp.player_new_direction=$PokemonGlobal.pokecenterDirection
         $scene.transfer_player
         #$game_map.need_refresh=true # in case player moves to the same map
      }
    end
end
