require_relative 'player'

class HumanPlayer < Player

  def make_move
    start_pos = self.display.get_pos
    end_pos = self.display.get_pos

    [start_pos,end_pos]
  end
  
end
