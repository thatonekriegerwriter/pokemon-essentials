=begin
#===============================================================================
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                     Script : Multiples Partidas 5.0
#                             por JessWishes
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                 Creado para RPG Maker XP con base Essentials
#                        Compatible : versión 18
#                       No probado con 16 o menor.
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# DevianArt :
# https://www.deviantart.com/jesswshs
#
# Twitter :
# https://twitter.com/JessWishes
#
# Pagina de Recursos
# https://jesswishesdev.weebly.com
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#  Esto ha tomado tiempo y esfuerzo en ser diseñado, aunque es de uso libre,
#   se agradece que se den créditos.
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#                             Modo de uso
#
#  Copiar y pegar en un nuevo script arriba del llamado Main.
#
#  1.-Una vez guardada la primera partida, se creará la carpeta que contendrá
#     los archivos
#
#  2.-Al iniciar una partida nueva, la primera vez que se guarde, se hará en un
#     archivo nuevo y al guardar de nuevo, te preguntará si quieres que ese
#     archivo se sobre escriba, de lo contrario se creará otro nuevo.
#
#  3.-Al llegar al número maximo de partidas, te saldrá el menseaje para
#     avisar al jugador.
#
#  4.-Estando en la pantalla de carga, se podrá eliminar la partida seleccionada
#     al oprimir la tecla Z (Input::A).
#
#  5.-Para evitar reducción de rendimiento, solo la partida seleccionada en la
#     la pantalla de carga, mostrará la imagen del personaje y los iconos del
#     equipo.
#
#  6.-Para forzar que la partida se guarde de manera automatica, se usa la
#     siguiente función : pbJessAutoSave
#     Está puede regresar el resultado; true si se ha guardado o false si no se
#     pudo guardar.
#
#-------------------------------------------------------------------------------
#                           Variables Globales
#-------------------------------------------------------------------------------
# Nombre de los archivos a guardar.
#NOMBREPARTIDA = "Partida_JessWishes"
NOMBREPARTIDA = "Game"

# Nombre de la carpeta que contendrá los archivos a guardar.
#DIR_PARTIDA = "Guardar"
DIR_PARTIDA = "Save"

# Número maximo de partidas
N_MX_PARTIDA = 3

# Al iniciar partida nueva te dejará seleccionar un lenguaje diferente.
LENG_JESS = false

# Lista de Lenguajes disponibles.
# la variable LANGUAGES en la sección Settings no se debe usar para evitar
#  posibles errores con el complilador.
LANGUAGES = [  
  ["Deutsch","deutsch.dat"],
  ["Deutsch","deutsch.dat"]
]
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# Dirección donde se guardarán las partidas.
#-------------------------------------------------------------------------------
module RTP

  def self.getSaveFileName(fileName)
    Dir.mkdir(DIR_PARTIDA) unless File.exists?(DIR_PARTIDA)
    return DIR_PARTIDA+"/"+fileName
  end
  
end
#-------------------------------------------------------------------------------
# Variable temporal en la cual se guardará el nombre de la partida actual.
#-------------------------------------------------------------------------------
class Game_Temp
  attr_accessor :archivoguardado
end
#-------------------------------------------------------------------------------
# Guardar Partida(s).
#-------------------------------------------------------------------------------

# Autosave
def pbJessAutoSave
  Kernel.pbMessage(_INTL("Saving Game...\\wtnp[10]"))
  mx=false
  for i in 1..N_MX_PARTIDA
    sv = "#{NOMBREPARTIDA}#{i}"; sv2 = sv+".rxdata"
    break if !safeExists?(RTP.getSaveFileName(sv2))
    mx=true if i==N_MX_PARTIDA && !$game_temp.archivoguardado
  end
  $game_temp.archivoguardado = sv if !$game_temp.archivoguardado && mx==false
  if mx==true
    Kernel.pbMessage(_INTL("You have reached the save game limit.\nYou will not be able to save a new game."))
    return false
  else
    pbSave(false,$game_temp.archivoguardado)
    Kernel.pbMessage(_INTL("\\me[GUI save game]The Game has been saved."))
    return true
  end
end


def pbSave(safesave=false,archivo=NOMBREPARTIDA)
  $Trainer.metaID=$PokemonGlobal.playerID
  begin
    File.open(RTP.getSaveFileName("#{archivo}.rxdata"),"wb"){|f|
       Marshal.dump($Trainer,f)
       Marshal.dump(Graphics.frame_count,f)
       if $data_system.respond_to?("magic_number")
         $game_system.magic_number = $data_system.magic_number
       else
         $game_system.magic_number = $data_system.version_id
       end
       $game_system.save_count+=1
       Marshal.dump($game_system,f)
       Marshal.dump($PokemonSystem,f)
       Marshal.dump($game_map.map_id,f)
       Marshal.dump($game_switches,f)
       Marshal.dump($game_variables,f)
       Marshal.dump($game_self_switches,f)
       Marshal.dump($game_screen,f)
       Marshal.dump($MapFactory,f)
       Marshal.dump($game_player,f)
       $PokemonGlobal.safesave=safesave
       Marshal.dump($PokemonGlobal,f)
       Marshal.dump($PokemonMap,f)
       Marshal.dump($PokemonBag,f)
       Marshal.dump($PokemonStorage,f)
    }
    Graphics.frame_reset
  rescue
    return false
  end
  return true
end

#-------------------------------------------------------------------------------
# En caso de error guardará la partida actual en el archivo Repaldo.rxdata
#-------------------------------------------------------------------------------
def pbEmergencySave
  oldscene=$scene
  $scene=nil
  Kernel.pbMessage(_INTL("The script has a problem the game will restart."))
  return if !$Trainer
  if safeExists?(RTP.getSaveFileName("Respaldo.rxdata"))
    File.open(RTP.getSaveFileName("Respaldo.rxdata"),  'rb') {|r|
      File.open(RTP.getSaveFileName("Respaldo.rxdata.bak"), 'wb') {|w|
        while s = r.read(4096)
          w.write s
        end
      }
    }
  end
  if pbSave(false,"Respaldo")
    Kernel.pbMessage(_INTL("The game has been saved.\\me[GUI save game]\\wtnp[30]"))
  else
    Kernel.pbMessage(_INTL("\\se[]An error occurred while saving the file.\\wtnp[30]"))
  end
  $scene=oldscene
end

#-------------------------------------------------------------------------------
# Pantalla de guardar
#-------------------------------------------------------------------------------
class PokemonSaveScreen

 def pbSaveScreen
    ret=false
    resul=0 #Partida Nueva
    archivos=[]
    n=0
    for i in 1..N_MX_PARTIDA
      archivos.push("#{NOMBREPARTIDA}#{i}") if safeExists?(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata"))
      next if n>0
      n=i if !safeExists?(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata"))
    end
    @scene.pbStartScreen
    if Kernel.pbConfirmMessage(_INTL("Do you want to save the game?"))
       #Ver si hay una partida guardada
       
       if archivos.size>0 && !$PokemonTemp.begunNewGame && true #deactivated by default
          resul=1 #No es Partida Nueva
          #Kernel.pbMessage(_INTL("Es existiert bereits eine Spieldatei!"))
            #if Kernel.pbConfirmMessage(_INTL("Das Spiel überschreiben?"))
                resul=2 #Sobre escribir
            #end
        end
        $PokemonTemp.begunNewGame=false
        if archivos.size==N_MX_PARTIDA && resul!=2
          Kernel.pbMessage(_INTL("The maximum number of different saved games has been reached!"))
          Kernel.pbMessage(_INTL("\\se[]The game could not be saved.\\wtnp[30]"))
        else
          guardar="#{NOMBREPARTIDA}#{n}" #Archivo nuevo
          guardar=$game_temp.archivoguardado if resul==2 #Archivo actual
          if pbSave(false,guardar)
            Kernel.pbMessage(_INTL("The game has been saved.\\me[GUI save game]\\wtnp[30]"))         if resul==0
            Kernel.pbMessage(_INTL("The game has been saved in a new save.\\me[GUI save game]\\wtnp[30]")) if resul==1
            Kernel.pbMessage(_INTL("The game has been saved.\\me[GUI save game]\\wtnp[30]"))      if resul==2
            if archivos.size==N_MX_PARTIDA && resul!=2
              Kernel.pbMessage(_INTL("You have reached the maximum number of savable games. You can overwrite the existing games, but you cannot save new ones until you delete one of the previous games."))
            end
            ret=true
            $game_temp.archivoguardado= guardar #Definir archivo actual
          else
            Kernel.pbMessage(_INTL("\\se[]The game could not be saved.\\wtnp[30]"))
            ret=false
          end
        end
    end
    @scene.pbEndScreen
    return ret
  end
  
end

#-------------------------------------------------------------------------------
# Cargar partida(s)
#-------------------------------------------------------------------------------
class PokemonLoadScreen

  #Eliminando el método de Essentials para eliminar partidas.
  def pbStartDeleteScreen; end

    
  def pbLeerinfoguardar(savefile)
      trainer      = nil
      framecount   = 0
      mapid        = 0
      @haveBackup   = false
     begin
     trainer, framecount, $game_system, $PokemonSystem, mapid = pbTryLoadFile(savefile)
     rescue
     if safeExists?(savefile+".bak")
       begin
       trainer, framecount, $game_system, $PokemonSystem, mapid = pbTryLoadFile(savefile+".bak")
       @haveBackup   = true
       rescue
       end
     end
     if @haveBackup
       Kernel.pbMessage(_INTL("The save file is corrupt. The previous save file will be loaded."))
     else
      Kernel.pbMessage(_INTL("The save file is corrupt, or is incompatible with this game."))
      if !Kernel.pbConfirmMessageSerious(_INTL("Do you want to delete the save file and start anew?"))
        $scene = nil
        return
      end
      begin; File.delete(savefile); rescue; end
      begin; File.delete(savefile+".bak"); rescue; end
      $game_system   = Game_System.new
      $PokemonSystem = PokemonSystem.new if !$PokemonSystem
      Kernel.pbMessage(_INTL("The save file was deleted."))
     end
   end
   return [trainer,framecount,$game_system,$PokemonSystem,mapid]
  end
    
  def pbcarga()
    archivos=[]
    savefile=[]
    for i in 1..N_MX_PARTIDA
      archivos.push("#{NOMBREPARTIDA}#{i}") if safeExists?(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata"))
      savefile.push(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata")) if safeExists?(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata"))
    end 
    return [archivos,savefile]
  end
    
  def pbStartLoadScreen
    #pbBGMPlay("IntroOrchestra")
    $PokemonTemp   = PokemonTemp.new
    $game_temp     = Game_Temp.new
    $game_system   = Game_System.new
    $PokemonSystem = PokemonSystem.new if !$PokemonSystem
    
    datos=pbcarga
    archivos=datos[0]
    savefile=datos[1]
    
    FontInstaller.install
    
    data_system = pbLoadRxData("Data/System")
    mapfile = ($RPGVX) ? sprintf("Data/Map%03d.rvdata",data_system.start_map_id) :
                         sprintf("Data/Map%03d.rxdata",data_system.start_map_id)
    if data_system.start_map_id==0 || !pbRgssExists?(mapfile)
      Kernel.pbMessage(_INTL("No starting position was set in the map editor.\1"))
      Kernel.pbMessage(_INTL("The game cannot continue."))
      @scene.pbEndScene
      $scene = nil
      return
    end
    
    commands = []
    cmdContinuar=[]
    comando=[]
    
    for i in 0..savefile.size-1
      cmdContinuar[i] = -1
      comando.push("cmdContinuar#{i}")
    end
    
    cmdNewGame     = -1
    cmdOption      = -1
    cmdMysteryGift = -1
    cmdDebug       = -1
    cmdQuit        = -1
    
    showContinue = []
    showContinue.push(false)
    
    for i in 1..N_MX_PARTIDA
      showContinue.push(true) if safeExists?(RTP.getSaveFileName("#{NOMBREPARTIDA}#{i}.rxdata"))
    end
    
    if savefile.size>0
      data=pbLeerinfoguardar(savefile[0])
      trainer=data[0]; framecount=data[1]; $game_system=data[2]; $PokemonSystem=data[3]; mapid=data[4]
      showContinue[0]=true if trainer
      if showContinue[0]==true
        if !@haveBackup
          begin; File.delete(savefile[0]+".bak"); rescue; end
        end
      end
      for i in 0..cmdContinuar.size-1
         commands[comando[i] = commands.length]= _INTL("Load Game #{i+1}") if showContinue[i]==true
      end
    end
    commands[cmdNewGame = commands.length]     = _INTL("New Game")
    commands[cmdMysteryGift = commands.length] = _INTL("Mystery Gift") if (trainer.mysterygiftaccess rescue false)
    commands[cmdOption = commands.length]        = _INTL("Options")
    commands[cmdDebug = commands.length]         = _INTL("Debug") if $DEBUG
    commands[cmdQuit = commands.length]          = _INTL("Quit")
    
    trainerlist=[]
    framelist=[]
    maplist=[]
    for k in 0...archivos.size
      datatt=pbLeerinfoguardar(savefile[k])
      trainerlist.push(datatt[0])
      framelist.push(datatt[1])
      maplist.push(datatt[4])
    end
    
    @scene.pbStartScene(commands,showContinue[0],trainer,framecount,mapid,cmdContinuar.size,trainerlist,framelist,maplist)
    @scene.pbSetParty(trainer) if showContinue[0]
    @scene.pbStartScene2
#    $ItemData = readItemList("Data/items.dat")
    pbLoadBattleAnimations
    loop do
      command2 = @scene.pbChoose(commands)    
      command=command2[0]

       if (command2[1]=="upd" || command2[1]=="dwd")
         @scene.pbSetParty(trainer,false)
         if command<archivos.size
            data=pbLeerinfoguardar(savefile[command])
            trainer=data[0]; framecount=data[1]; $game_system=data[2]; $PokemonSystem=data[3]; mapid=data[4]
            @scene.pbSetParty(trainer) if showContinue[command]
            
         end
      
      elsif command2[1]=="eliminar"
        if command<archivos.size
        if safeExists?(savefile[command]) && comando.include?(command)
           if Kernel.pbConfirmMessage(_INTL("Delete Game?"))
              Kernel.pbMessage(_INTL("You will lose all current save data, continue?"))
              if Kernel.pbConfirmMessage(_INTL("All of it will be gone, are you sure?"))
                 begin; File.delete(savefile[command]); rescue; end
                 begin; File.delete(savefile[command]+".bak"); rescue; end
                 Kernel.pbMessage(_INTL("The Save has been Deleted."))
                 archivos.delete_at(command)
                 comando.delete_at(command)
                 @scene.pbEndScene
                 sscene=PokemonLoad_Scene.new
                 sscreen=PokemonLoadScreen.new(sscene)
                 sscreen.pbStartLoadScreen
                 break
              end
            end
          end
        end
      elsif comando.include?(command)
        for i in 0..savefile.size-1
          savefile2=savefile[i] if command==comando[i]
          n=i+1 if command==comando[i]
        end              
        
       # Determinar el nombre de esta partida
        nmb_j = (archivos[n-1] == NOMBREPARTIDA) ? "#{NOMBREPARTIDA}#{n}" : archivos[n-1]
        $game_temp.archivoguardado = nmb_j
       #
        unless safeExists?(savefile2)
          pbPlayBuzzerSE
          next
        end
        @scene.pbEndScene
        metadata = nil
       File.open(savefile2){|f|
          $Trainer = Marshal.load(f) # Trainer already loaded          
          Graphics.frame_count = Marshal.load(f)
          $game_system         = Marshal.load(f)
          $PokemonSystem       = Marshal.load(f)
          Marshal.load(f) # Current map id no longer needed
          $game_switches       = Marshal.load(f)
          $game_variables      = Marshal.load(f)
          $game_self_switches  = Marshal.load(f)
          $game_screen         = Marshal.load(f)
          $MapFactory          = Marshal.load(f)
          $game_map            = $MapFactory.map
          $game_player         = Marshal.load(f)
          $PokemonGlobal       = Marshal.load(f)
          metadata             = Marshal.load(f)
          $PokemonBag          = Marshal.load(f)
          $PokemonStorage      = Marshal.load(f)
          if $game_switches[278]
              $PokemonSystem.battlestyle = 1
              $diff_money = 0.85
              $diff_exp   = 0.85
              if $game_switches[94]
                $PokemonSystem.battlestyle = 1
                $diff_money = 0.75
                $diff_exp   = 0.75
              end
              if $game_switches[139]
                $PokemonSystem.battlestyle = 1
                $diff_money = 0.65
                $diff_exp   = 0.65
              end
          else
              $PokemonSystem.battlestyle = 0
              $diff_money = 1
              $diff_exp   = 1
          end
          magicNumberMatches = false
          if $data_system.respond_to?("magic_number")
            magicNumberMatches = ($game_system.magic_number==$data_system.magic_number)
          else
            magicNumberMatches = ($game_system.magic_number==$data_system.version_id)
          end
          if !magicNumberMatches || $PokemonGlobal.safesave
            if pbMapInterpreterRunning?
              pbMapInterpreter.setup(nil,0)
            end
            begin
              $MapFactory.setup($game_map.map_id) # calls setMapChanged
            rescue Errno::ENOENT
              if $DEBUG
                Kernel.pbMessage(_INTL("Map {1} was not found.",$game_map.map_id))
                map = pbWarpToMap
                if map
                  $MapFactory.setup(map[0])
                  $game_player.moveto(map[1],map[2])
                else
                  $game_map = nil
                  $scene = nil
                  return
                end
              else
                $game_map = nil
                $scene = nil
                Kernel.pbMessage(_INTL("The map was not found. The game cannot continue."))
              end
            end
            $game_player.center($game_player.x, $game_player.y)
          else
            $MapFactory.setMapChanged($game_map.map_id)
          end
        }
        if !$game_map.events # Map wasn't set up
          $game_map = nil
          $scene = nil
          Kernel.pbMessage(_INTL("The map is corrupt. The game cannot continue."))
          return
        end
        $PokemonMap = metadata
        $PokemonEncounters = PokemonEncounters.new
        $PokemonEncounters.setup($game_map.map_id)
        pbAutoplayOnSave
        $game_map.update
        $PokemonMap.updateMap
        $scene = Scene_Map.new
        
        $PokemonSystem.language=0 if $PokemonSystem.language>LANGUAGES.size-1
        
        pbLoadMessages("Data/"+LANGUAGES[$PokemonSystem.language][1]) if LENG_JESS
        
        return
      elsif cmdNewGame>=0 && command==cmdNewGame
        @scene.pbEndScene
        
        if LENG_JESS
          $PokemonSystem.language = pbChooseLanguage  
          pbLoadMessages("Data/"+LANGUAGES[$PokemonSystem.language][1])
        end
        
        if $game_map && $game_map.events
          for event in $game_map.events.values
            event.clear_starting
          end
        end
        $game_temp.common_event_id = 0 if $game_temp
        $scene               = Scene_Map.new
        Graphics.frame_count = 0
        $game_system         = Game_System.new
        $game_switches       = Game_Switches.new
        $game_variables      = Game_Variables.new
        $game_self_switches  = Game_SelfSwitches.new
        $game_screen         = Game_Screen.new
        $game_player         = Game_Player.new
        $PokemonMap          = PokemonMapMetadata.new
        $PokemonGlobal       = PokemonGlobalMetadata.new
        $PokemonStorage      = PokemonStorage.new
        $PokemonEncounters   = PokemonEncounters.new
        $PokemonTemp.begunNewGame = true
        pbRefreshResizeFactor   # To fix Game_Screen pictures
        $data_system         = pbLoadRxData("Data/System")
        $MapFactory          = PokemonMapFactory.new($data_system.start_map_id) # calls setMapChanged
        $game_player.moveto($data_system.start_x, $data_system.start_y)
        $game_player.refresh
        $game_map.autoplay
        $game_map.update
        return
      elsif cmdMysteryGift>=0 && command==cmdMysteryGift
        pbFadeOutIn(99999){
          trainer = pbDownloadMysteryGift(trainer)
        }
      elsif cmdOption>=0 && command==cmdOption
        pbFadeOutIn(99999){
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        }
      elsif cmdDebug>=0 && command==cmdDebug
        pbFadeOutIn(99999){ pbDebugMenu(false) }
      elsif cmdQuit>=0 && command==cmdQuit
        @scene.pbEndScene
        $scene = nil
        return
      end
    end
    @scene.pbEndScene
    return
  end
end

#-------------------------------------------------------------------------------
# Pantalla de carga (visual)
#-------------------------------------------------------------------------------
class PokemonLoad_Scene
  
  def pbUpdate
    oldi = @sprites["cmdwindow"].index rescue 0
    pbUpdateSpriteHash(@sprites)
    newi = @sprites["cmdwindow"].index rescue 0
    if oldi!=newi
      @sprites["panel#{oldi}"].selected = false
      @sprites["panel#{oldi}"].pbRefresh
      @sprites["panel#{newi}"].selected = true
      @sprites["panel#{newi}"].pbRefresh

      sy=@sprites["panel#{newi}"].bitmap.height+2
      mov=(newi>oldi)
      fv=(@mxpartidas*sy)

      for i in 0...@commands.length
        if newi==0
          @sprites["panel#{i}"].y=@bsy[i]
        elsif newi>oldi && newi!=oldi+1
          @sprites["panel#{i}"].y-=fv
        else
         @sprites["panel#{i}"].y-=sy if mov && newi<@mxpartidas+1
         @sprites["panel#{i}"].y+=sy if !mov && newi<@mxpartidas
        end
      end
    end
  end
  
  def pbSetParty(trainer,val=true)
    @sprites["player"].dispose if @sprites["player"]
    for i in 0..6; @sprites["party#{i}"].dispose if @sprites["party#{i}"]; end
    return if !trainer || !trainer.party || val==false
    meta = pbGetMetadata(0,MetadataPlayerA+trainer.metaID)
    if meta
      filename = pbGetPlayerCharset(meta,1,trainer)
      @sprites["player"] = TrainerWalkingCharSprite.new(filename,@viewport)
      charwidth  = @sprites["player"].bitmap.width
      charheight = @sprites["player"].bitmap.height
      @sprites["player"].x        = 56*2-charwidth/8
      @sprites["player"].y        = 56*2-charheight/8
      @sprites["player"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)
    end
    for i in 0...trainer.party.length
      @sprites["party#{i}"] = PokemonIconSprite.new(trainer.party[i],@viewport)
      @sprites["party#{i}"].x = 151*2+33*2*(i&1)
      @sprites["party#{i}"].y = 36*2+25*2*(i/2)
      @sprites["party#{i}"].z = 99999
    end
  end
  
  def pbStartScene(commands,showContinue,trainer,framecount,mapid,mxpartidas,trainerlist,framelist,maplist)
    @trainerlist=trainerlist
    @mxpartidas=mxpartidas
    @commands = commands
    @sprites = {}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99998
    addBackgroundOrColoredPlane(@sprites,"background","loadbg",Color.new(248,248,248),@viewport)
    y = 16*2
    @bsy=[]
    for i in 0...commands.length
      @sprites["panel#{i}"] = PokemonLoadPanel.new(i,commands[i],
         (showContinue && i<@mxpartidas) ? true : false,trainerlist[i],framelist[i],maplist[i],@viewport)
      @sprites["panel#{i}"].x = 24*2
      @sprites["panel#{i}"].y = y
      @sprites["panel#{i}"].pbRefresh
      @bsy.push(y)
      y += (showContinue && i<@mxpartidas) ? 111*2+1*2 : 23*2+1*2
    end
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].viewport = @viewport
    @sprites["cmdwindow"].visible  = false
  end
  
  def pbactu(commands,trainer,framecount,mapid)
    
    for i in 0...commands.length
    @sprites["panel#{i}"].pbactu(trainer[i],framecount,mapid)
    end
  end
  
  def pbChoose(commands)
    @sprites["cmdwindow"].commands = commands
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::C)
        return [@sprites["cmdwindow"].index,"sel"]
      elsif Input.trigger?(Input::A)
        return [@sprites["cmdwindow"].index,"eliminar"]
      elsif Input.trigger?(Input::UP)
        return [@sprites["cmdwindow"].index,"upd"]
      elsif Input.trigger?(Input::DOWN)
        return [@sprites["cmdwindow"].index,"dwd"]
      end
    end
  end

end
#-------------------------------------------------------------------------------
# Paneles
#-------------------------------------------------------------------------------
class PokemonLoadPanel < SpriteWrapper
  attr_reader :selected

  def initialize(index,title,isContinue,trainer,framecount,mapid,viewport=nil)
    super(viewport)
    @viewport=viewport
    @trainer=trainer
    @index = index
    @title = title
    @isContinue = isContinue
    @trainer = trainer
    @totalsec = (framecount || 0)/Graphics.frame_rate
    @mapid = mapid
    @selected = (index==0)
    @bgbitmap = AnimatedBitmap.new("Graphics/Pictures/loadPanels")
    @refreshBitmap = true
    @refreshing = false
    refresh
  end

  def dispose
    @bgbitmap.dispose
    self.bitmap.dispose
    super
  end

  def selected=(value)
    if @selected!=value
      @selected = value
      @refreshBitmap = true
      refresh
    end
  end

  def pbactu(trainer,framecount,mapid)
    @trainer=trainer
    @mapid=mapid
    @totalsec = (framecount || 0)/Graphics.frame_rate
    refresh
  end
  
  def pbRefresh
    @refreshBitmap = true
    refresh
  end

  def refresh
    return if @refreshing
    return if disposed?
    @refreshing = true
    if !self.bitmap || self.bitmap.disposed?
      self.bitmap = BitmapWrapper.new(@bgbitmap.width,111*2)
      pbSetSystemFont(self.bitmap)
    end
    if @refreshBitmap
      @refreshBitmap = false
      self.bitmap.clear if self.bitmap
      
      if @isContinue
        self.bitmap.blt(0,0,@bgbitmap.bitmap,Rect.new(0,(@selected) ? 111*2 : 0,@bgbitmap.width,111*2))
      else
        self.bitmap.blt(0,0,@bgbitmap.bitmap,Rect.new(0,111*2*2+((@selected) ? 23*2 : 0),@bgbitmap.width,23*2))
      end
      textpos = []
      if @isContinue
        textpos.push([@title,16*2,5*2,0,Color.new(232,232,232),Color.new(136,136,136)])
        #textpos.push([_INTL("Medallas:"),16*2,56*2,0,Color.new(232,232,232),Color.new(136,136,136)])
        #textpos.push([@trainer.numbadges.to_s,103*2,56*2,1,Color.new(232,232,232),Color.new(136,136,136)])
        textpos.push([_INTL("Pokédex :"),16*2,72*2,0,Color.new(232,232,232),Color.new(136,136,136)])
        textpos.push([@trainer.pokedexSeen.to_s,103*2,72*2,1,Color.new(232,232,232),Color.new(136,136,136)])
        textpos.push([_INTL("Spielzeit:"),16*2,88*2,0,Color.new(232,232,232),Color.new(136,136,136)])
        hour = @totalsec / 60 / 60
        min  = @totalsec / 60 % 60
        if hour>0
          if min > 10
            textpos.push([_INTL("{1}:{2}",hour,min),103*2,88*2,1,Color.new(232,232,232),Color.new(136,136,136)])
          else
            textpos.push([_INTL("{1}:0{2}",hour,min),103*2,88*2,1,Color.new(232,232,232),Color.new(136,136,136)])
          end
        else
          if min > 10
            textpos.push([_INTL("0:{1}",min),103*2,88*2,1,Color.new(232,232,232),Color.new(136,136,136)])
          else
            textpos.push([_INTL("0:0{1}",min),103*2,88*2,1,Color.new(232,232,232),Color.new(136,136,136)])
          end
        end
        if @trainer.isMale?
          textpos.push([@trainer.name,56*2,32*2,0,Color.new(56,160,248),Color.new(56,104,168)])
        else
          textpos.push([@trainer.name,56*2,32*2,0,Color.new(240,72,88),Color.new(160,64,64)])
        end
        mapname = pbGetMapNameFromId(@mapid)
        mapname.gsub!(/\\PN/,@trainer.name)
        textpos.push([mapname,193*2,5*2,1,Color.new(232,232,232),Color.new(136,136,136)])
      else
        textpos.push([@title,16*2,4*2,0,Color.new(232,232,232),Color.new(136,136,136)])
      end
      pbDrawTextPositions(self.bitmap,textpos)
    end
    @refreshing = false
  end
end
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
#===============================================================================
=end