module Custom_Entries
  attr_accessor :entries


  @entries = []
end



class PokeBattle_Trainer
include Custom_Entries
end


def customEntry?(species)
  species = getID(PBSpecies,species)
  if $Trainer.entries && $Trainer.entries[species]!=nil && $Trainer.entries[species]!=" " && $Trainer.entries[species]!=""
    return true
  else
    return false
  end
end


def entry(species,var)
  species = getID(PBSpecies,species)
    if $Trainer.entries && $Trainer.entries[species]!=nil && $Trainer.entries[species]!=" " && $Trainer.entries[species]!=""
      $game_variables[var] = $Trainer.entries[species]
    else
      $game_variables[var] = pbGetMessage(MessageTypes::Entries,species)
  end

end

class PokemonPokedexInfo_Scene

  def drawPageInfo
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/Pokedex/bg_info"))
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88,88,80)
    shadow = Color.new(168,184,184)
    imagepos = []
    if @brief
      imagepos.push([_INTL("Graphics/Pictures/Pokedex/overlay_info"),0,0])
    end
    # Write various bits of text
    indexText = "???"
    if @dexlist[@index][4]>0
      indexNumber = @dexlist[@index][4]
      indexNumber -= 1 if @dexlist[@index][5]
      indexText = sprintf("%03d",indexNumber)
    end
    textpos = [
       [_INTL("{1}{2} {3}",indexText," ",PBSpecies.getName(@species)),
          246,42,0,Color.new(248,248,248),Color.new(0,0,0)],
       [_INTL("Height"),314,158,0,base,shadow],
       [_INTL("Weight"),314,190,0,base,shadow]
    ]
    if $Trainer.owned[@species]
      speciesData = pbGetSpeciesData(@species,@form)
      fSpecies = pbGetFSpeciesFromForm(@species,@form)
      # Write the kind
      kind = pbGetMessage(MessageTypes::Kinds,fSpecies)
      kind = pbGetMessage(MessageTypes::Kinds,@species) if !kind || kind==""
      textpos.push([_INTL("{1} Pokémon",kind),246,74,0,base,shadow])
      # Write the height and weight
      height = speciesData[SpeciesHeight] || 1
      weight = speciesData[SpeciesWeight] || 1
      if pbGetCountry==0xF4   # If the user is in the United States
        inches = (height/0.254).round
        pounds = (weight/0.45359).round
        textpos.push([_ISPRINTF("{1:d}'{2:02d}\"",inches/12,inches%12),460,158,1,base,shadow])
        textpos.push([_ISPRINTF("{1:4.1f} lbs.",pounds/10.0),494,190,1,base,shadow])
      else
        textpos.push([_ISPRINTF("{1:.1f} m",height/10.0),470,158,1,base,shadow])
        textpos.push([_ISPRINTF("{1:.1f} kg",weight/10.0),482,190,1,base,shadow])
      end
      # Draw the Pokédex entry text
      entry = pbGetMessage(MessageTypes::Entries,fSpecies)
      entry = pbGetMessage(MessageTypes::Entries,@species) if !entry || entry==""
      if !$Trainer.entries
        $Trainer.entries = []
        for i in 1..PBSpecies.maxValue
          $Trainer.entries[i]         = ""
        end
      end
        if $Trainer.entries[@species]!=nil && $Trainer.entries[@species]!=" " && $Trainer.entries[@species]!=""
          entry = $Trainer.entries[@species]
        end
      drawTextEx(overlay,40,240,Graphics.width-(40*2),4,entry,base,shadow)
      # Draw the footprint
      footprintfile = pbPokemonFootprintFile(@species,@form)
      if footprintfile
        footprint = BitmapCache.load_bitmap(footprintfile)
        overlay.blt(226,138,footprint,footprint.rect)
        footprint.dispose
      end
      # Show the owned icon
      imagepos.push(["Graphics/Pictures/Pokedex/icon_own",212,44])
      # Draw the type icon(s)
      type1 = speciesData[SpeciesType1] || 0
      type2 = speciesData[SpeciesType2] || type1
      type1rect = Rect.new(0,type1*32,96,32)
      type2rect = Rect.new(0,type2*32,96,32)
      overlay.blt(296,120,@typebitmap.bitmap,type1rect)
      overlay.blt(396,120,@typebitmap.bitmap,type2rect) if type1!=type2
    else
      # Write the kind
      textpos.push([_INTL("????? Pokémon"),246,74,0,base,shadow])
      # Write the height and weight
      if pbGetCountry()==0xF4 # If the user is in the United States
        textpos.push([_INTL("???'??\""),460,158,1,base,shadow])
        textpos.push([_INTL("????.? lbs."),494,190,1,base,shadow])
      else
        textpos.push([_INTL("????.? m"),470,158,1,base,shadow])
        textpos.push([_INTL("????.? kg"),482,190,1,base,shadow])
      end
    end
    # Draw all text
    pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
    # Draw all images
    pbDrawImagePositions(overlay,imagepos)
  end


  def pbScene
    pbPlayCrySpecies(@species,@form)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::A)
        pbSEStop
        pbPlayCrySpecies(@species,@form) if @page==1
      elsif Input.trigger?(Input::B)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::C)
        if @page==2   # Area
#          dorefresh = true
        elsif @page==3   # Forms
          if @available.length>1
            pbPlayDecisionSE
            pbChooseForm
            dorefresh = true
          end
        end
      elsif Input.trigger?(Input::ALT) && $Trainer.owned[@species]
        if @page==1
          if !$Trainer.entries
            $Trainer.entries = []
            for i in 1..PBSpecies.maxValue
              $Trainer.entries[i]         = ""
            end
          end
          $Trainer.entries[@species]=pbMessageFreeText(_INTL("New PokéDex entry?"),"",false,170,Graphics.width)
          dorefresh = true
          drawPageInfo
        end
      elsif Input.trigger?(Input::UP)
        oldindex = @index
        pbGoToPrevious
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN)
        oldindex = @index
        pbGoToNext
        if @index!=oldindex
          pbUpdateDummyPokemon
          @available = pbGetAvailableForms
          pbSEStop
          (@page==1) ? pbPlayCrySpecies(@species,@form) : pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT)
        oldpage = @page
        @page -= 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT)
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @index
  end




end

