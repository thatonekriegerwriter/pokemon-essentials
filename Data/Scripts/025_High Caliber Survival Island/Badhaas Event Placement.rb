=begin
    ######################
    EVENT PLACEMENT SCRIPT
    ######################
- by Badhaas
- v 1.2
- 19-11-2013

This script allows you to place an event on all maps (based on a template event
created on a specific map). This can, for example, be used to put an event on the
location where a partner trainer/dependent event is left behind.

Version history:
1.2: A fix which now allows placing events on adjacent maps
1.1: Added placing events on other maps than the current map
1.0: original script

    ############
    INSTALATION:

- Place the script above Main.
- Place "pbPlacedEvents(self,@map_id)" in Game_Map, above the line
  "@common_events = {}"
- Create an empty map, which will contain all events placed by this script.
  (fill in the map ID at line 45 in the script).
- Create the desired events on the map and use the script to place them.

    ###########
    HOW TO USE:

Create all 'template' event (which will be placed using this script) in the map
with the same map ID as CHAR_TEMPLATE_MAP_ID (set below). Then use the functions
explained below to place and remove the events.

    ##########
    FUNCTIONS:

pbPlaceEvent(id,x,y,f) > place an event (or change it's position, when already
                         placed somewhere)
  id = the event id in the template map
  x & y = the x and y position
  f = facing direction (6=right, 4=left, 2=down, 8=up)
  when x, y, and f are left blank, the event is placed in front of the player

pbRemovePlacedEvent(id) > removes the event


Place events on other maps than the current map:
  pbPlaceEventMap(id,map id,x,y,direction)
    id = the event ID in the template.
    map id = the id of the map where the event should be placed.
    x, y = the x and y position respectively of the event on the map.
    direction = facing direction of the event (4=left, 8=up, 6=right, 2=down)
=end

module Char_Events
  CHAR_TEMPLATE_MAP_ID = 297     # MAP ID FOR THE TEMPLATE EVENTS
  
  map_id = CHAR_TEMPLATE_MAP_ID
  map = load_data(sprintf("Data/Map%03d.%s", map_id,$RPGVX ? "rvdata" : "rxdata"))
  $events = map.events
  
end


def pbPlaceEvent(id,x=nil,y=nil,f=nil)
  # create array if it doesn't exist
  if $PlacedEvents == nil
    $PlacedEvents = []
  end
  $PlacedEvents[id] = []
  # set position
  if x
    x2 = x
  else
    if $game_player.direction == 6
      x2 = $game_player.x + 1
    elsif $game_player.direction == 4
      x2 = $game_player.x - 1
    else
      x2 = $game_player.x
    end
  end
  if y
    y2 = y
  else
    if $game_player.direction == 2
      y2 = $game_player.y + 1
    elsif $game_player.direction == 8
      y2 = $game_player.y - 1
    else
      y2 = $game_player.y
    end
  end
  if f
    f2 = f
  else
    f2 = 2 if $game_player.direction == 8
    f2 = 8 if $game_player.direction == 2
    f2 = 4 if $game_player.direction == 6
    f2 = 6 if $game_player.direction == 4
  end
  $PlacedEvents[id][1] = [$game_map.map_id,x2,y2,f2]
  # create event based of the template
  $PlacedEvents[id][0] = CharacterEvent.new(id,$game_map,[x2,y2,f2])
  $game_map.events[$game_map.events.length+1] = $PlacedEvents[id][0]
  # refresh the map, etc.
  $scene.disposeSpritesets
  $scene.createSpritesets
  
end

def pbPlaceEventMap(id,map,x,y,f)
  if $PlacedEvents == nil
    $PlacedEvents = []
  end
  if $PlacedEvents[id] == nil
    $PlacedEvents[id] = []
  end
  $PlacedEvents[id][1] = [map,x,y,f]
  #fix for adjacent maps:
  if $MapFactory.hasMap?(map)
    index = $MapFactory.getMapIndex(map)
    $PlacedEvents[id][0] = CharacterEvent.new(id,$MapFactory.maps[index],[x,y,f])
    $MapFactory.maps[index].events[$MapFactory.maps[index].events.length+1] = $PlacedEvents[id][0]
    $scene.disposeSpritesets
    $scene.createSpritesets
  end
end

def pbRemovePlacedEvent(id)
  if $PlacedEvents[id]  #check if it actually exists
    if $PlacedEvents[id][1][0] == $game_map.map_id
      $PlacedEvents[id][0].erase
    end
    $PlacedEvents[id]=nil
  end
end

def pbPlacedEvents(map,mapid)
  # create array if it doesn't exist
  if $PlacedEvents == nil
    $PlacedEvents = []
  end
  #check for events that should be on the map
  for i in 0...$PlacedEvents.length
    if $PlacedEvents[i]
      if $PlacedEvents[i][1][0] == mapid
        $PlacedEvents[i][0] = CharacterEvent.new(i,map,[$PlacedEvents[i][1][1],
                                                        $PlacedEvents[i][1][2],
                                                        $PlacedEvents[i][1][3]])
        map.events[map.events.length+1] = $PlacedEvents[i][0]
      end
    end
  end #end loop
end #end pbPlacedEvents



class CharacterEvent < Game_Event
  
  attr_accessor :event
  
  def initialize(char_id,map,position)
    original_event = $events[char_id]
    return if original_event == nil
    @event = original_event.dup
    @event.x = position[0]
    @event.y = position[1]
    @event.pages[0].graphic.direction = position[2]
    @event.id = map.events.length+1
    super(map.map_id,@event,map)
  end
end