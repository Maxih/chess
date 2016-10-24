class Piece

  attr_accessor :position
  attr_reader :color, :board

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

end
