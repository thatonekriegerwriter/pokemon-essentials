class PokemonContestTemp
  attr_accessor :pokemonContestMoveData
 
  def pbOpenContestMoveData
    if !self.pokemonContestMoveData
      pbRgssOpen("Data/contestmoves.dat","rb"){|f|
         self.pokemonContestMoveData=f.read
      }
    end
    if block_given?
      StringInput.open(self.pokemonContestMoveData) {|f| yield f }
    else
      return StringInput.open(self.pokemonContestMoveData)
    end
  end
end

class PBContestMoveData
  
attr_reader :contestType
attr_reader :hearts,:jam
attr_reader :contestfunction
 
  def initialize(moveid)
    contestmovedata=nil
    if $PokemonContestTemp
      contestmovedata=$PokemonContstTemp.pbOpenContestMoveData
    else
      contestmovedata=pbRgssOpen("Data/contestmoves.dat")
    end
    contestmovedata.pos=moveid*4
    @contestType = contestmovedata.fgetb
    @hearts      = contestmovedata.fgetb
    @jam         = contestmovedata.fgetb
    @contestfunction    = contestmovedata.fgetb
    contestmovedata.close
  end
end

class PBContestMove
attr_reader :hearts,:jam
attr_reader :contestfunction,:id
 
# Gets this move's type.
  def type
    contestmovedata=PBContestMoveData.new(@id)
    return contestmovedata.type
  end
#gets the number of hearts
def hearts
  contestmovedata=PBContestMoveData.new(@id)
  return contestmovedata.hearts
end
 
# Initializes this object to the specified move ID.
  def initialize(moveid)
    contestmovedata=PBContestMoveData.new(moveid)
    @id=moveid
  end
end