###---NEW---###
def pbHasType?(type)
  for pokemon in $Trainer.party
    next if pokemon.egg?
    return true if pokemon.type1==type || pokemon.type2==type
  end
  return false
end

def pbHasLegendaries?()
  for pokemon in $Trainer.party
    next if pokemon.egg?
    return true if
    pbHasSpecies?(PBSpecies::ARTICUNO) ||
    pbHasSpecies?(PBSpecies::ZAPDOS) ||
    pbHasSpecies?(PBSpecies::MOLTRES) ||
    pbHasSpecies?(PBSpecies::MEWTWO) ||
    pbHasSpecies?(PBSpecies::MEW) ||
    pbHasSpecies?(PBSpecies::CELEBI) ||
    pbHasSpecies?(PBSpecies::ENTEI) ||
    pbHasSpecies?(PBSpecies::RAIKOU) ||
    pbHasSpecies?(PBSpecies::SUICUNE) ||
    pbHasSpecies?(PBSpecies::LUGIA) ||
    pbHasSpecies?(PBSpecies::HOOH) ||
    pbHasSpecies?(PBSpecies::REGICE) ||
    pbHasSpecies?(PBSpecies::REGISTEEL) ||
    pbHasSpecies?(PBSpecies::REGIROCK) ||
    pbHasSpecies?(PBSpecies::LATIOS) ||
    pbHasSpecies?(PBSpecies::LATIAS) ||
    pbHasSpecies?(PBSpecies::KYOGRE) ||
    pbHasSpecies?(PBSpecies::GROUDON) ||
    pbHasSpecies?(PBSpecies::RAYQUAZA) ||
    pbHasSpecies?(PBSpecies::JIRACHI) ||
    pbHasSpecies?(PBSpecies::DEOXYS)
  end
  return false
end

def pbSetUpcase(variable)
  $game_variables[variable]=$game_variables[variable].upcase
end

def pbLegendaryStarter?(variable)
    starter=$game_variables[variable]
  return true if
    starter=="ARTICUNO" ||
    starter=="ZAPDOS" ||
    starter=="MOLTRES" ||
    starter=="MEWTWO" ||
    starter=="MEW" ||
    starter=="RAIKOU" ||
    starter=="ENTEI" ||
    starter=="SUICUNE" ||
    starter=="LUGIA" ||
    starter=="HOOH" ||
    starter=="CELEBI" ||
    starter=="REGIROCK" ||
    starter=="REGICE" ||
    starter=="REGISTEEL" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="KYOGRE" ||
    starter=="GROUDON" ||
    starter=="RAYQUAZA" ||
    starter=="JIRACHI" ||
    starter=="DEOXYS" ||
    starter=="UXIE" ||
    starter=="MESPRIT" ||
    starter=="AZELF" ||
    starter=="DIALGA" ||
    starter=="PALKIA" ||
    starter=="HEATRAN" ||
    starter=="REGIGIGAS" ||
    starter=="GIRATINA" ||
    starter=="CRESSELIA" ||
    starter=="MANAPHY" ||
    starter=="DARKRAI" ||
    starter=="SHAYMIN" ||
    starter=="ARCEUS" ||
    starter=="VICTINI" ||
    starter=="COBALION" ||
    starter=="TERRAKION" ||
    starter=="VIRIZION" ||
    starter=="TORNADUS" ||
    starter=="THUNDURUS" ||
    starter=="RESHIRAM" ||
    starter=="ZEKROM" ||
    starter=="LANDORUS" ||
    starter=="KYUREM" ||
    starter=="KELDEO" ||
    starter=="MELOETTA" ||
    starter=="GENESECT"
  return false
end

def pbPhioneStarter?(variable)
    starter=$game_variables[variable]
  return true if starter=="PHIONE"
  return false
end

def pbMagikarpStarter?(variable)
    starter=$game_variables[variable]
  return true if starter=="MAGIKARP"
  return false
end

def pbRandomStarter(typ)
  allstarters=["ABRA",
    "ABSOL",
    "AERODACTYL",
    "AIPOM",
    "ALOMOMOLA",
    "ANORITH",
    "ARCHEN",
    "ARON",
    "AUDINO",
    "AXEW",
    "AZURILL",
    "BAGON",
    "BALTOY",
    "BARBOACH",
    "BASCULIN",
    "BELDUM",
    "BELLSPROUT",
    "BIDOOF",
    "BLITZLE",
    "BONSLY",
    "BOUFFALANT",
    "BRONZOR",
    "BUDEW",
    "BUIZEL",
    "BULBASAUR",
    "BUNEARY",
    "BURMY",
    "CACNEA",
    "CARNIVINE",
    "CARVANHA",
    "CASTFORM",
    "CATERPIE",
    "CHARMANDER",
    "CHATOT",
    "CHERUBI",
    "CHIKORITA",
    "CHIMCHAR",
    "CHINCHOU",
    "CHINGLING",
    "CLAMPERL",
    "COBALION",
    "COMBEE",
    "CORPHISH",
    "CORSOLA",
    "COTTONEE",
    "CRANIDOS",
    "CROAGUNK",
    "CRYOGONAL",
    "CUBCHOO",
    "CUBONE",
    "CYNDAQUIL",
    "DARUMAKA",
    "DEERLING",
    "DEINO",
    "DELIBIRD",
    "DIGLETT",
    "DITTO",
    "DODUO",
    "DRATINI",
    "DRIFLOON",
    "DRILBUR",
    "DROWZEE",
    "DRUDDIGON",
    "DUCKLETT",
    "DUNSPARCE",
    "DURANT",
    "DUSKULL",
    "DWEBBLE",
    "EEVEE",
    "EKANS",
    "ELECTRIKE",
    "ELEKID",
    "ELGYEM",
    "EMOLGA",
    "EXEGGCUTE",
    "FARFETCHD",
    "FEEBAS",
    "FERROSEED",
    "FINNEON",
    "FOONGUS",
    "FRILLISH",
    "GASTLY",
    "GEODUDE",
    "GIBLE",
    "GIRAFARIG",
    "GLAMEOW",
    "GLIGAR",
    "GOLDEEN",
    "GOLETT",
    "GOTHITA",
    "GRIMER",
    "GROWLITHE",
    "GULPIN",
    "HAPPINY",
    "HEATMOR",
    "HERACROSS",
    "HIPPOPOTAS",
    "HOOTHOOT",
    "HOPPIP",
    "HORSEA",
    "HOUNDOUR",
    "IGGLYBUFF",
    "ILLUMISE",
    "JOLTIK",
    "KABUTO",
    "KANGASKHAN",
    "KARRABLAST",
    "KECLEON",
    "KLINK",
    "KOFFING",
    "KRABBY",
    "KRICKETOT",
    "LAPRAS",
    "LARVESTA",
    "LARVITAR",
    "LATIAS",
    "LATIOS",
    "LEDYBA",
    "LICKITUNG",
    "LILEEP",
    "LILLIPUP",
    "LITWICK",
    "LOTAD",
    "LUNATONE",
    "LUVDISC",
    "MACHOP",
    "MAGBY",
    "MAGIKARP",
    "MAGNEMITE",
    "MAKUHITA",
    "MANAPHY",
    "MANKEY",
    "MANTYKE",
    "MARACTUS",
    "MAREEP",
    "MAWILE",
    "MEDITITE",
    "MEOWTH",
    "MIENFOO",
    "MILTANK",
    "MINCCINO",
    "MINUN",
    "MISDREAVUS",
    "MUDKIP",
    "MUNCHLAX",
    "MUNNA",
    "MURKROW",
    "NATU",
    "NINCADA",
    "NOSEPASS",
    "NUMEL",
    "ODDISH",
    "OMANYTE",
    "ONIX",
    "OSHAWOTT",
    "PACHIRISU",
    "PANPOUR",
    "PANSAGE",
    "PANSEAR",
    "PARAS",
    "PATRAT",
    "PAWNIARD",
    "PETILIL",
    "PHANPY",
    "PICHU",
    "PIDGEY",
    "PIDOVE",
    "PINECO",
    "PINSIR",
    "PIPLUP",
    "PLUSLE",
    "POLIWAG",
    "PONYTA",
    "POOCHYENA",
    "PORYGON",
    "PSYDUCK",
    "PURRLOIN",
    "QWILFISH",
    "RALTS",
    "RATTATA",
    "RELICANTH",
    "REMORAID",
    "RHYHORN",
    "RIOLU",
    "ROGGENROLA",
    "ROTOM",
    "RUFFLET",
    "SABLEYE",
    "SANDILE",
    "SANDSHREW",
    "SAWK",
    "SCRAGGY",
    "SCYTHER",
    "SEEDOT",
    "SEEL",
    "SENTRET",
    "SEVIPER",
    "SEWADDLE",
    "SHELLDER",
    "SHELLOS",
    "SHELMET",
    "SHIELDON",
    "SHINX",
    "SHROOMISH",
    "SHUCKLE",
    "SHUPPET",
    "SIGILYPH",
    "SKARMORY",
    "SKITTY",
    "SKORUPI",
    "SLAKOTH",
    "SLOWPOKE",
    "SLUGMA",
    "SMEARGLE",
    "SMOOCHUM",
    "SNEASEL",
    "SNIVY",
    "SNORUNT",
    "SNOVER",
    "SOLOSIS",
    "SOLROCK",
    "SPEAROW",
    "SPHEAL",
    "SPINARAK",
    "SPINDA",
    "SPIRITOMB",
    "SPOINK",
    "SQUIRTLE",
    "STANTLER",
    "STARLY",
    "STARYU",
    "STUNFISK",
    "STUNKY",
    "SUNKERN",
    "SURSKIT",
    "SWABLU",
    "SWINUB",
    "TAILLOW",
    "TANGELA",
    "TAUROS",
    "TEDDIURSA",
    "TENTACOOL",
    "TEPIG",
    "TERRAKION",
    "THROH",
    "TIMBURR",
    "TIRTOUGA",
    "TORCHIC",
    "TORKOAL",
    "TOTODILE",
    "TRAPINCH",
    "TREECKO",
    "TROPIUS",
    "TRUBBISH",
    "TURTWIG",
    "TYMPOLE",
    "TYNAMO",
    "TYROGUE",
    "UNOWN",
    "VANILLITE",
    "VENIPEDE",
    "VENONAT",
    "VOLBEAT",
    "VOLTORB",
    "VULLABY",
    "VULPIX",
    "WAILMER",
    "WEEDLE",
    "WHISMUR",
    "WINGULL",
    "WOOBAT",
    "WOOPER",
    "WURMPLE",
    "WYNAUT",
    "YAMASK",
    "YANMA",
    "ZANGOOSE",
    "ZAPDOS",
    "ZIGZAGOON",
    "ZORUA",
    "ZUBAT"]
  if typ=="NONE"
    rPoke=allstarters[rand(allstarters.length)]
    return rPoke
  else
    spoke=[]
    tyo=typ
    for i in 0...allstarters.length
      poke=PokeBattle_Pokemon.new(getID(PBSpecies,allstarters[i]),20,$Trainer)
      if tyo==PBTypes.getName(poke.type1)||tyo==PBTypes.getName(poke.type2)
        spoke=spoke.push(allstarters[i])
      end 
    end
    tPoke=spoke[rand(spoke.length)]
    #fer=PBSpecies.getName(tPoke)
    return tPoke
  end
end

def pbFixCommonStarterSpellingErrors(variable)
    starter=$game_variables[variable]
  if starter=="MR MIME"||starter=="MR. MIME"||starter=="MR.MIME"||starter=="MISTERMIME" 
    $game_variables[variable]="MRMIME"
  end
  if starter=="JINX" 
    $game_variables[variable]="JYNX"
  end
  if starter=="ONYX" 
    $game_variables[variable]="ONIX"
  end
  if starter=="POOCHYEENA"||starter=="POOCHEENA"
    $game_variables[variable]="POOCHYENA"
  end
  if starter=="MAGICARP"||starter=="MAJIKARP"||starter=="MAJICARP"
    $game_variables[variable]="MAGIKARP"
  end
  if starter=="FARFETCH'D"||starter=="FARFECH'D"||starter=="FARFECHD"
    $game_variables[variable]="FARFETCHD"
  end
  if starter=="GHASTLY"||starter=="GASTLEY"
    $game_variables[variable]="GASTLY"
  end
  if starter=="HO-OH"||starter=="HO OH"
    $game_variables[variable]="HOOH"
  end
  if starter=="PORYGON 2"
    $game_variables[variable]="PORYGON2"
  end
  if starter=="FLAFFY"||starter=="FLAAFY"
    $game_variables[variable]="FLAAFFY"
  end
  if starter=="VICTREEBELL"||starter=="VICTORYBELL"
    $game_variables[variable]="VICTREEBEL"
  end
  if starter=="FERALIGATOR"||starter=="FERALLIGATOR"
    $game_variables[variable]="FERALIGATR"
  end
  if starter=="NINETAILS"
    $game_variables[variable]="NINETALES"
  end
  if starter=="VENASAUR"
    $game_variables[variable]="VENUSAUR"
  end
  if starter=="GARADOS"||starter=="GARYDOS"||starter=="GYRADOS"
    $game_variables[variable]="GYARADOS"
  end
  if starter=="DIGLET"||starter=="DIGGLET"||starter=="DIGGLETT"
    $game_variables[variable]="DIGLETT"
  end
  if starter=="POLITOAD"||starter=="POLYTOAD"
    $game_variables[variable]="POLITOED"
  end
  if starter=="NIDORAN"
    command=Kernel.pbShowCommands(nil,
       [_INTL("Male?"),
       _INTL("Female?")],
       -1)
      if command==0 # Male
        $game_variables[variable]="NIDORANmA"
      elsif command==1 # Female
        $game_variables[variable]="NIDORANfE"
      else
        break
      end
    end
    if starter=="NIDORAN♀"||starter=="NIDORANF"
      $game_variables[variable]="NIDORANfE"
    end
    if starter=="NIDORAN♂"||starter=="NIDORANM"
      $game_variables[variable]="NIDORANmA"
    end
    starter=$game_variables[variable]
  if starter=="RANDOM"||starter=="Random"||starter=="Anything"||starter=="ANYTHING" 
    $game_variables[variable]=pbRandomStarter("NONE")
  end
  if starter=="GRASS"||
    starter=="FIRE"||
    starter=="WATER"||
    starter=="NORMAL"||
    starter=="FLYING"||
    starter=="BUG"||
    starter=="FIGHTING"||
    starter=="POISON"||
    starter=="ROCK"||
    starter=="GROUND"||
    starter=="ELECTRIC"||
    starter=="ICE"||
    starter=="PSYCHIC"||
    starter=="DARK"||
    starter=="STEEL"||
    starter=="DRAGON"
      $game_variables[variable]=pbRandomStarter(starter)
  end
end

def pbIsLowestEvolutionStarter?(variable)
  starter=$game_variables[variable]
  return true if starter=="ABRA" ||
    starter=="ABSOL" ||
    starter=="AERODACTYL" ||
    starter=="AIPOM" ||
    starter=="ALOMOMOLA" ||
    starter=="ANORITH" ||
    starter=="ARCHEN" ||
    starter=="ARON" ||
    starter=="ARTICUNO" ||
    starter=="AUDINO" ||
    starter=="AXEW" ||
    starter=="AZELF" ||
    starter=="AZURILL" ||
    starter=="BAGON" ||
    starter=="BALTOY" ||
    starter=="BARBOACH" ||
    starter=="BASCULIN" ||
    starter=="BELDUM" ||
    starter=="BELLSPROUT" ||
    starter=="BIDOOF" ||
    starter=="BLITZLE" ||
    starter=="BONSLY" ||
    starter=="BOUFFALANT" ||
    starter=="BRONZOR" ||
    starter=="BUDEW" ||
    starter=="BUIZEL" ||
    starter=="BULBASAUR" ||
    starter=="BUNEARY" ||
    starter=="BURMY" ||
    starter=="CACNEA" ||
    starter=="CARNIVINE" ||
    starter=="CARVANHA" ||
    starter=="CASTFORM" ||
    starter=="CATERPIE" ||
    starter=="CELEBI" ||
    starter=="CHARMANDER" ||
    starter=="CHATOT" ||
    starter=="CHERUBI" ||
    starter=="CHIKORITA" ||
    starter=="CHIMCHAR" ||
    starter=="CHINCHOU" ||
    starter=="CHINGLING" ||
    starter=="CLAMPERL" ||
    starter=="COBALION" ||
    starter=="COMBEE" ||
    starter=="CORPHISH" ||
    starter=="CORSOLA" ||
    starter=="COTTONEE" ||
    starter=="CRANIDOS" ||
    starter=="CROAGUNK" ||
    starter=="CRYOGONAL" ||
    starter=="CUBCHOO" ||
    starter=="CUBONE" ||
    starter=="CYNDAQUIL" ||
    starter=="DARUMAKA" ||
    starter=="DEERLING" ||
    starter=="DEINO" ||
    starter=="DELIBIRD" ||
    starter=="DEOXYS" ||
    starter=="DIALGA" ||
    starter=="DIGLETT" ||
    starter=="DITTO" ||
    starter=="DODUO" ||
    starter=="DRATINI" ||
    starter=="DRIFLOON" ||
    starter=="DRILBUR" ||
    starter=="DROWZEE" ||
    starter=="DRUDDIGON" ||
    starter=="DUCKLETT" ||
    starter=="DUNSPARCE" ||
    starter=="DURANT" ||
    starter=="DUSKULL" ||
    starter=="DWEBBLE" ||
    starter=="EEVEE" ||
    starter=="EKANS" ||
    starter=="ELECTRIKE" ||
    starter=="ELEKID" ||
    starter=="ELGYEM" ||
    starter=="EMOLGA" ||
    starter=="ENTEI" ||
    starter=="EXEGGCUTE" ||
    starter=="FARFETCHD" ||
    starter=="FEEBAS" ||
    starter=="FERROSEED" ||
    starter=="FINNEON" ||
    starter=="FOONGUS" ||
    starter=="FRILLISH" ||
    starter=="GASTLY" ||
    starter=="GENESECT" ||
    starter=="GEODUDE" ||
    starter=="GIBLE" ||
    starter=="GIRAFARIG" ||
    starter=="GIRATINA" ||
    starter=="GLAMEOW" ||
    starter=="GLIGAR" ||
    starter=="GOLDEEN" ||
    starter=="GOLETT" ||
    starter=="GOTHITA" ||
    starter=="GRIMER" ||
    starter=="GROUDON" ||
    starter=="GROWLITHE" ||
    starter=="GULPIN" ||
    starter=="HAPPINY" ||
    starter=="HEATMOR" ||
    starter=="HERACROSS" ||
    starter=="HIPPOPOTAS" ||
    starter=="HOOH" ||
    starter=="HOOTHOOT" ||
    starter=="HOPPIP" ||
    starter=="HORSEA" ||
    starter=="HOUNDOUR" ||
    starter=="IGGLYBUFF" ||
    starter=="ILLUMISE" ||
    starter=="JIRACHI" ||
    starter=="JOLTIK" ||
    starter=="KABUTO" ||
    starter=="KANGASKHAN" ||
    starter=="KARRABLAST" ||
    starter=="KECLEON" ||
    starter=="KELDEO" ||
    starter=="KLINK" ||
    starter=="KOFFING" ||
    starter=="KRABBY" ||
    starter=="KRICKETOT" ||
    starter=="KYOGRE" ||
    starter=="KYUREM" ||
    starter=="LANDORUS" ||
    starter=="LAPRAS" ||
    starter=="LARVESTA" ||
    starter=="LARVITAR" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="LEDYBA" ||
    starter=="LICKITUNG" ||
    starter=="LILEEP" ||
    starter=="LILLIPUP" ||
    starter=="LITWICK" ||
    starter=="LOTAD" ||
    starter=="LUGIA" ||
    starter=="LUNATONE" ||
    starter=="LUVDISC" ||
    starter=="MACHOP" ||
    starter=="MAGBY" ||
    starter=="MAGIKARP" ||
    starter=="MAGNEMITE" ||
    starter=="MAKUHITA" ||
    starter=="MANAPHY" ||
    starter=="MANKEY" ||
    starter=="MANTYKE" ||
    starter=="MARACTUS" ||
    starter=="MAREEP" ||
    starter=="MAWILE" ||
    starter=="MEDITITE" ||
    starter=="MELOETTA" ||
    starter=="MEOWTH" ||
    starter=="MESPRIT" ||
    starter=="MEW" ||
    starter=="MEWTWO" ||
    starter=="MIENFOO" ||
    starter=="MILTANK" ||
    starter=="MINCCINO" ||
    starter=="MINUN" ||
    starter=="MISDREAVUS" ||
    starter=="MOLTRES" ||
    starter=="MUDKIP" ||
    starter=="MUNCHLAX" ||
    starter=="MUNNA" ||
    starter=="MURKROW" ||
    starter=="NATU" ||
    starter=="NINCADA" ||
    starter=="NOSEPASS" ||
    starter=="NUMEL" ||
    starter=="ODDISH" ||
    starter=="OMANYTE" ||
    starter=="ONIX" ||
    starter=="OSHAWOTT" ||
    starter=="PACHIRISU" ||
    starter=="PALKIA" ||
    starter=="PANPOUR" ||
    starter=="PANSAGE" ||
    starter=="PANSEAR" ||
    starter=="PARAS" ||
    starter=="PATRAT" ||
    starter=="PAWNIARD" ||
    starter=="PETILIL" ||
    starter=="PHANPY" ||
    starter=="PICHU" ||
    starter=="PIDGEY" ||
    starter=="PIDOVE" ||
    starter=="PINECO" ||
    starter=="PINSIR" ||
    starter=="PIPLUP" ||
    starter=="PLUSLE" ||
    starter=="POLIWAG" ||
    starter=="PONYTA" ||
    starter=="POOCHYENA" ||
    starter=="PORYGON" ||
    starter=="PSYDUCK" ||
    starter=="PURRLOIN" ||
    starter=="QWILFISH" ||
    starter=="RAIKOU" ||
    starter=="RALTS" ||
    starter=="RATTATA" ||
    starter=="RAYQUAZA" ||
    starter=="REGICE" ||
    starter=="REGIROCK" ||
    starter=="REGISTEEL" ||
    starter=="RELICANTH" ||
    starter=="REMORAID" ||
    starter=="RESHIRAM" ||
    starter=="RHYHORN" ||
    starter=="RIOLU" ||
    starter=="ROGGENROLA" ||
    starter=="ROTOM" ||
    starter=="RUFFLET" ||
    starter=="SABLEYE" ||
    starter=="SANDILE" ||
    starter=="SANDSHREW" ||
    starter=="SAWK" ||
    starter=="SCRAGGY" ||
    starter=="SCYTHER" ||
    starter=="SEEDOT" ||
    starter=="SEEL" ||
    starter=="SENTRET" ||
    starter=="SEVIPER" ||
    starter=="SEWADDLE" ||
    starter=="SHELLDER" ||
    starter=="SHELLOS" ||
    starter=="SHELMET" ||
    starter=="SHIELDON" ||
    starter=="SHINX" ||
    starter=="SHROOMISH" ||
    starter=="SHUCKLE" ||
    starter=="SHUPPET" ||
    starter=="SIGILYPH" ||
    starter=="SKARMORY" ||
    starter=="SKITTY" ||
    starter=="SKORUPI" ||
    starter=="SLAKOTH" ||
    starter=="SLOWPOKE" ||
    starter=="SLUGMA" ||
    starter=="SMEARGLE" ||
    starter=="SMOOCHUM" ||
    starter=="SNEASEL" ||
    starter=="SNIVY" ||
    starter=="SNORUNT" ||
    starter=="SNOVER" ||
    starter=="SOLOSIS" ||
    starter=="SOLROCK" ||
    starter=="SPEAROW" ||
    starter=="SPHEAL" ||
    starter=="SPINARAK" ||
    starter=="SPINDA" ||
    starter=="SPIRITOMB" ||
    starter=="SPOINK" ||
    starter=="SQUIRTLE" ||
    starter=="STANTLER" ||
    starter=="STARLY" ||
    starter=="STARYU" ||
    starter=="STUNFISK" ||
    starter=="STUNKY" ||
    starter=="SUICUNE" ||
    starter=="SUNKERN" ||
    starter=="SURSKIT" ||
    starter=="SWABLU" ||
    starter=="SWINUB" ||
    starter=="TAILLOW" ||
    starter=="TANGELA" ||
    starter=="TAUROS" ||
    starter=="TEDDIURSA" ||
    starter=="TENTACOOL" ||
    starter=="TEPIG" ||
    starter=="TERRAKION" ||
    starter=="THROH" ||
    starter=="THUNDURUS" ||
    starter=="TIMBURR" ||
    starter=="TIRTOUGA" ||
    starter=="TORCHIC" ||
    starter=="TORKOAL" ||
    starter=="TORNADUS" ||
    starter=="TOTODILE" ||
    starter=="TRAPINCH" ||
    starter=="TREECKO" ||
    starter=="TROPIUS" ||
    starter=="TRUBBISH" ||
    starter=="TURTWIG" ||
    starter=="TYMPOLE" ||
    starter=="TYNAMO" ||
    starter=="TYROGUE" ||
    starter=="UNOWN" ||
    starter=="UXIE" ||
    starter=="VANILLITE" ||
    starter=="VENIPEDE" ||
    starter=="VENONAT" ||
    starter=="VICTINI" ||
    starter=="VIRIZION" ||
    starter=="VOLBEAT" ||
    starter=="VOLTORB" ||
    starter=="VULLABY" ||
    starter=="VULPIX" ||
    starter=="WAILMER" ||
    starter=="WEEDLE" ||
    starter=="WHISMUR" ||
    starter=="WINGULL" ||
    starter=="WOOBAT" ||
    starter=="WOOPER" ||
    starter=="WURMPLE" ||
    starter=="WYNAUT" ||
    starter=="YAMASK" ||
    starter=="YANMA" ||
    starter=="ZANGOOSE" ||
    starter=="ZAPDOS" ||
    starter=="ZEKROM" ||
    starter=="ZIGZAGOON" ||
    starter=="ZORUA" ||
    starter=="ZUBAT"
  return false
end

def pbCheckMoveType(mtype,va,wa)
  xtype=getID(PBTypes,mtype)
  for poke in $Trainer.party
    for i in 0...4
      if poke.moves[i].type==xtype
        vID = poke.moves[i].id
        $game_variables[va] = poke.name
        $game_variables[wa] = PBMoves.getName(vID)
        return true 
      end
    end
  end
  return false
end

def pbSetBaseEvolutionStarterHelper(variable)
  pkmn=getConst(PBSpecies,pbGet(variable))
  base=pbGetBabySpecies(pkmn)
  ret=PBSpecies.getName(base)
  return ret
end

def pbSetBaseEvolutionStarter(variable,wariable)
  $game_variables[variable] = pbSetBaseEvolutionStarterHelper(wariable)
end

def pbSetGameVariables(variable,wariable)
  $game_variables[variable] = $game_variables[wariable]
end

###---END NEW---###
