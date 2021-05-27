#==============================================================================#
#
#                                     Variables
#
#==============================================================================#
Name_contest = 293
Store_pokemon_contest = 294
Store_difficulty_contest = 295
Store_ribbon = 296
Store_number_for_emotion_normal = 297
Store_number_for_emotion_super = 298
Store_number_for_emotion_hyper = 299
Store_number_for_emotion_master = 300
#==============================================================================#
#
#         Information pertining to the start position on the CONTEST
#
#         Format is as following: [map_id, map_x, map_y]
#
#==============================================================================#
MAP_ID = [401,401,401,401]
MAP_X = [11,11,11,11]
MAP_Y = [9,9,9,9]
CONTEST_MAP_DATA_NORMAL = [MAP_ID[0],MAP_X[0],MAP_Y[0]]
CONTEST_MAP_DATA_SUPER = [MAP_ID[1],MAP_X[1],MAP_Y[1]]
CONTEST_MAP_DATA_HYPER = [MAP_ID[2],MAP_X[2],MAP_Y[2]]
CONTEST_MAP_DATA_MASTER = [MAP_ID[3],MAP_X[3],MAP_Y[3]]
#==============================================================================#
#
#          ID for the event and map used to move the player
#
#==============================================================================#
EVENT_ID_CONTEST = 13
CONTEST_MAP_BEFORE_PLAY = 22
CONTEST_MOVE_EVENT = 9
CONTEST_DOOR_EVENT = [1,3]
COORIDINATE_WHEN_FINISH_CONTEST = [CONTEST_MAP_BEFORE_PLAY,1,5,true]
#==============================================================================#
# If true, the pokemons in Contest are random
RANDOM_POKEMONS = true
# If true, there are the cases: the similar pokemons
SIMILAR_POKEMONS = false
# You can set Pokemon in Contest with this (of course, the condition is RANDOM_POKEMONS = false)
# If true, the method for check is each contest will is the different Pokemons.
EACH_CONTEST = false
# This is Pokemon for all Contest
# Add this if EACH_CONTEST = false
POKEMON_FIRST_CONTEST = []
POKEMON_SECOND_CONTEST = []
POKEMON_THIRD_CONTEST = []
# This is Pokemon for each Contest
# Cool
POKEMON_COOL_FIRST = [:LEDYBA,:MAKUHITA,:MIGHTYENA,:LOTAD,:POOCHYENA]
POKEMON_COOL_SECOND = [:ARON,:POOCHYENA,:AGGRON,:ILLUMISE,:TRAPINCH]
POKEMON_COOL_THIRD = [:TOTODILE,:WHISMUR,:VOLBEAT,:WAILMER,:CORPHISH]
# Beauty
POKEMON_BEAUTY_FIRST = [:MILOTIC,:TYMPOLE,:VENIPEDE,:SCRAGGY,:TIRTOUGA]
POKEMON_BEAUTY_SECOND = [:SOLOSIS,:JOLTIK,:CHANDELURE,:SERPERIOR,:SAMUROTT]
POKEMON_BEAUTY_THIRD = [:STOUTLAND,:MILOTIC,:LUCARIO,:ROSERADE,:INFERNAPE]
# Cute
POKEMON_CUTE_FIRST = [:RALTS,:PLUSLE,:MINUN,:ESPEON,:UMBREON]
POKEMON_CUTE_SECOND = [:EEVEE,:VAPOREON,:JOLTEON,:PORYGON,:PONYTA]
POKEMON_CUTE_THIRD = [:DODUO,:GROWLITHE,:ESPEON,:GARDEVOIR,:LUVDISC]
# Smart
POKEMON_SMART_FIRST = [:CHIMCHAR,:AMBIPOM,:PANSAGE,:ZORUA,:RUFFLET]
POKEMON_SMART_SECOND = [:MANDIBUZZ,:ZOROAK,:CUBONE,:GENGAR,:ZUBAT]
POKEMON_SMART_THIRD = [:ZOROAK,:ZORUA,:SNEASEL,:WEAVILE,:ARIADOS]
# Tough
POKEMON_TOUGH_FIRST = [:HARIYAMA,:WAILORD,:WHISCASH,:ABSOL,:PACHIRISU]
POKEMON_TOUGH_SECOND = [:WAILORD,:BASTIODON,:LUCARIO,:TOXICROAK,:LICKILICKY]
POKEMON_TOUGH_THIRD = [:WAIMER,:WAILORD,:ARCHEN,:EMOLGA,:GALVANTULA]
#================
# Set level
# If true, you can change this level in array. If false, level will set like:
# Normal = 25  ;  Super = 50  ; Hyper = 75  ; Master = 100
SET_LEVEL_CONTEST = true
# Here, the order is level pokemon second,third,fourth
LEVEL_POKEMON_CONTEST_NORMAL = [25,25,25]
LEVEL_POKEMON_CONTEST_SUPER = [50,50,50]
LEVEL_POKEMON_CONTEST_HYPER = [75,75,75]
LEVEL_POKEMON_CONTEST_MASTER = [100,100,100]
#===============================================================================
# Blank array to store moves to teach contest pokemon
#===============================================================================
CONTESTMOVE2=[0,0,0,0]
CONTESTMOVE3=[0,0,0,0]
CONTESTMOVE4=[0,0,0,0]
#===============================================================================
# Nicknaming contest pokemon
#===============================================================================
$CONTESTNAME2 = ""
$CONTESTNAME3 = ""
$CONTESTNAME4 = ""
#===============================================================================
#  Define Contest Combos here
#===============================================================================
# Define all combos here.
# First entry in array starts the combo, the rest are the options to follow it.
# Name them by their name used in the game, not the internal name.

combo1=["Belly Drum","Rest"]
combo2=["Calm Mind","Confusion","Dream Eater","Future Sight","Light Screen","Luster Purge","Meditate","Mist Ball","Psybeam","Psychic","Psycho Boost","Psywave","Reflect"]
combo3=["Charge","Shock Wave","Spark","Thunder","Thunderbolt","Thunder Punch","Thunder Shock","Thunder Wave","Volt Tackle","Zap Cannon"]
combo4=["Charm","Flatter","Growl","Rest","Tail Whip"]
combo5=["Confusion","Future Sight","Kinesis","Psychic","Teleport"]
combo6=["Curse","Destiny Bond","Grudge","Mean Look","Spite"]
combo7=["Defense Curl","Rollout","Tackle"]
combo8=["Dive","Surf"]
combo9=["Double Team","Agility","Quick Attack","Teleport"]
combo10=["Dragon Breath","Dragon Claw","Dragon Dance","Dragon Rage"]
combo11=["Dragon Dance","Dragon Breath","Dragon Claw","Dragon Rage"]
combo12=["Dragon Rage","Dragon Breath","Dragon Claw","Dragon Dance"]
combo13=["Earthquake","Eruption","Fissure"]
combo14=["Endure","Flail","Reversal"]
combo15=["Fake Out","Arm Thrust","Feint Attack","Knock Off","Seismic Toss","Vital Throw"]
combo16=["Fire Punch","Ice Punch","Thunder Punch"]
combo17=["Focus Energy","Arm Thrust","Brick Break","Cross Chop","Double Edge","DynamicPunch","Focus Punch","Headbutt","Karate Chop","Sky Uppercut","Take Down"]
combo18=["Growth","Absorb","Bullet Seed","Frenzy Plant","Giga Drain","Leech Seed","Magical Leaf","Mega Drain","Petal Dance","Razor Leaf","SolarBeam","Vine Whip"]
combo19=["Hail","Aurora Beam","Blizzard","Haze","Ice Ball","Ice Beam","Icicle Spear","Icy Wind","Powder Snow","Sheer Cold","Weather Ball"]
combo20=["Harden","Double Edge","Protect","Rollout","Tackle","Take Down"]
combo21=["Horn Attack","Horn Drill","Fury Attack"]
combo22=["Hypnosis","Dream Eater"]
combo23=["Ice Punch","Fire Punch","Thunder Punch"]
combo24=["Kinesis","Confusion","Future Sight","Psychic","Teleport"]
combo25=["Leer","Bite","Feint Attack","Glare","Horn Attack","Scary Face","Scratch","Stomp","Tackle"]
combo26=["Lock-On","Superpower","Thunder","Tri Attack","Zap Cannon"]
combo27=["Mean Look","Destiny Bond","Perish Song"]
combo28=["Metal Sound","Metal Claw"]
combo29=["Mind Reader","DynamicPunch","Hi Jump Kick","Sheer Cold","Submission","Superpower"]
combo30=["Mud Sport","Mud-Slap","Water Gun","Water Sport"]
combo31=["Peck","Drill Peck","Fury Attack"]
combo32=["Pound","Double Slap","Feint Attack","Slam"]
combo33=["Powder Snow","Blizzard"]
combo34=["Psychic","Confusion","Teleport","Future Sight","Kinesis"]
combo35=["Rage","Leer","Scary Face","Thrash"]
combo36=["Rain Dance","Bubble","Bubblebeam","Clamp","Crabhammer","Dive","Hydro Cannon","Hydro Pump","Muddy Water","Octazooka","Surf","Thunder","Water Gun","Water Pulse","Water Sport","Water Spout","Waterfall","Weather Ball","Whirlpool"]
combo37=["Rest","Sleep Talk","Snore"]
combo38=["Rock Throw","Rock Slide","Rock Tomb"]
combo39=["Sand-Attack","Mud-Slap"]
combo40=["Sandstorm","Mud Shot","Mud-Slap","Mud Sport","Sand Tomb","Sand-Attack","Weather Ball"]
combo41=["Scary Face","Bite","Crunch","Leer"]
combo42=["Scratch","Fury Swipes","Slash"]
combo43=["Sing","Perish Song","Refresh"]
combo44=["Sludge","Sludge Bomb"]
combo45=["Sludge Bomb","Sludge"]
combo46=["Smog","Smokescreen"]
combo47=["Stockpile","Spit Up","Swallow"]
combo48=["Sunny Day","Blast Burn","Blaze Kick","Ember","Eruption","Fire Blast","Fire Punch","Fire Spin","Flame Wheel","Flamethrower","Heat Wave","Moonlight","Morning Sun","Overheat","Sacred Fire","SolarBeam","Synthesis","Weather Ball","Will-o-Wisp"]
combo49=["Surf","Dive"]
combo50=["Sweet Scene","Poison Powder","Sleep Powder","Stun Spore"]
combo51=["Swords Dance","Crabhammer","Crush Claw","Cut","False Swipe","Fury Cutter","Slash"]
combo52=["Taunt","Counter","Detect","Mirror Coat"]
combo53=["Thunder Punch","Fire Punch","Ice Punch"]
combo54=["Vice Grip","Bind","Guillotine"]
combo55=["Water Sport","Mud Sport","Refresh","Water Gun"]
combo56=["Yawn","Rest","Slack Off"]

# Add more combos here...
# Then add them to this array below

CONTESTCOMBOS=[combo1,combo2,combo3,combo4,combo5,combo6,combo7,combo8,combo9,
combo10,combo11,combo12,combo13,combo14,combo15,combo16,combo17,combo18,combo19,
combo20,combo21,combo22,combo23,combo24,combo25,combo26,combo27,combo28,combo29,
combo30,combo31,combo32,combo33,combo34,combo35,combo36,combo37,combo38,combo39,
combo40,combo41,combo42,combo43,combo44,combo45,combo46,combo47,combo48,combo49,
combo50,combo51,combo52,combo53,combo54,combo55,combo56]