require_relative 'board'
require_relative 'HumanPlayer'

class WrongColorError < MoveError
end

class Game

  attr_accessor :current_player
  attr_reader :player1, :player2, :board

  def initialize(player1, player2)
    @board = Board.new
    @board.populate

    @display = Display.new(@board, true)

    @player1 = HumanPlayer.new(player1, @display, :white)
    @player2 = HumanPlayer.new(player2, @display, :black)
    @current_player = @player1
  end

  def play
    until winner?
      begin
        move_pair = self.current_player.make_move
        raise WrongColorError.new unless own_piece?(move_pair.first)

        self.board.move_piece(move_pair.first,move_pair.last)
      rescue MoveError => e
        puts e
        retry
      end

      self.switch_player!
    end

    @display.render
    puts "#{winner?.name} wins!"
  end

  def switch_player!
    self.current_player == self.player1 ? @current_player = self.player2 : @current_player = self.player1
  end

  def winner?
    return self.player2 if self.board.checkmate?(self.player1.color)
    return self.player1 if self.board.checkmate?(self.player2.color)

    nil
  end

  def own_piece?(start_pos)
    self.board[start_pos].color == self.current_player.color
  end
end

if __FILE__ == $PROGRAM_NAME

  g = Game.new("Max","Henry")
  g.play
  # b = Board.new()
  # b.populate
  #
  # k = Queen.new([4,5], :black, b)
  # b[[4,5]] = k
  #
  # k = Knight.new([5,3], :black, b)
  # b[[5,3]] = k
  #
  #
  # d = Display.new(b,true)
  #
  #
  # d.render
  #
  # b.move_piece([6,4],[5,3])
  # d.render
  #
  # while true
  #   d.move
  # end

end
