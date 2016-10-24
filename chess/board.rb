require_relative 'pieces/piece.rb'
require_relative 'pieces/null_piece.rb'
require_relative 'display'
require_relative 'pieces/bishop'

class MoveError < StandardError
end

class InvalidStartError < MoveError
end

class InvalidEndError < MoveError
end

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def populate
    grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        pos = [row_idx,col_idx]
        if row_idx.between?(2,5)
          self[pos] = NullPiece.instance
        elsif row_idx.between?(0,1)
          self[pos] = Piece.new(pos,:black, self)
        else
          self[pos] = Piece.new(pos,:white, self)
        end
      end
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos,piece)
    row, col = pos
    grid[row][col] = piece
  end

  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]
    raise InvalidStartError if start_piece.empty?
    # raise InvalidEndError unless start_piece.valid_moves.include?(end_pos)

    self[end_pos] = start_piece
    self[start_pos] = NullPiece.new

    start_piece.position = end_pos
  end

  def in_bounds?(pos)
    pos.all? { |dim| dim.between?(0,7) }
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new()
  b.populate

  bishop = Bishop.new([4,4], :white, b)
  b[[4,4]] = bishop

  p bishop.moves

  d = Display.new(b)

  d.render
  # d.move
end
