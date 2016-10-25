require 'byebug'

class Piece

  attr_accessor :position, :board
  attr_reader :color

  def initialize(start_pos, color, board)
    @position = start_pos
    @color = color
    @board = board
  end

  def empty?
    self.is_a? NullPiece
  end

  def symbol
    "K"
  end

  def to_s
    self.symbol
  end

  def valid_moves
    possibles = self.moves
    possibles.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(end_pos)
    test_board = self.board.dup

    test_board.move_piece!(self.position, end_pos)

    test_board.in_check?(self.color)
  end

  def apply_deltas(pos, deltas)
    new_pos = deltas.map { |(x,y)| [pos.first + x, pos.last + y] }
    new_pos.select { |pos| self.board.in_bounds?(pos) }
  end

end
