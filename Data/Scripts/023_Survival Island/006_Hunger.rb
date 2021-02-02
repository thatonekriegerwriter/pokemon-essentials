#Health System
#Hunger 
Events.onStepTakenTransferPossible+=proc {
if $game_switches[212]==true #hunger Switch if ON you need to survive
case $game_variables[246]
when 0
$game_variables[245] -= 1 if rand(10) == 0 #take from hunger like normal
else
$game_variables[246] -= 1 if rand(10) == 0 #take from saturation
case $game_variables[245]
when 0
$game_variables[245]=100
pbMessage(_INTL("You are passing out from lack of food and water!"))
pbFadeOutIn(99999)
Kernel.pbStartOver(true)
end
end
end
}
#Eating Food
def pbPickAndEatBerry
berry=0
pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
berry = screen.pbChooseItemScreen
}
if berry>0
$PokemonBag.pbDeleteItem(berry,1)
Kernel.pbMessage(_INTL("You consume the {1}. ",PBItems.getName(berry)))
if isConst?(berry,PBItems,:ORANBERRY)
$game_variables[245]+=7
$game_variables[246]+=3
elsif isConst?(berry,PBItems,:LEPPABERRY)
$game_variables[245]+=9
$game_variables[246]+=1
elsif isConst?(berry,PBItems,:SITRUSBERRY)
$game_variables[245]+=10
$game_variables[246]+=7
elsif isConst?(berry,PBItems,:BERRYJUICE)
$game_variables[245]+=0
$game_variables[246]+=20
elsif isConst?(berry,PBItems,:FRESHWATER)
$game_variables[245]+=0
$game_variables[246]+=40
#You can add more if you want
elsif isConst?(berry,PBItems,:ATKCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:SATKCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:SPEEDCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:SPDEFCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:ACCCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:DEFCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:CRITCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
elsif isConst?(berry,PBItems,:GSCURRY)
$game_variables[245]-=10
$game_variables[246]+=10
#full belly
$game_variables[245]=100 if $game_variables[245]>100
end
end
end 