require_relative 'pieces/piece.rb'
require_relative 'pieces/null_piece.rb'
require_relative 'display'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/pawn'



class MoveError < StandardError
end

class InvalidStartError < MoveError
end

class InvalidEndError < MoveError
end


class Board

  STARTING_ROW = [Rook,Knight,Bishop,Queen,King,Bishop,Knight,Rook]

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def populate
    grid.each_index do |row_idx|
      case row_idx
      when 0
        @grid[row_idx] = first_row(row_idx, :black)
      when 1
        @grid[row_idx] = pawn_row(row_idx, :black)
      when 2,3,4,5
        @grid[row_idx] = null_row
      when 6
        @grid[row_idx] = pawn_row(row_idx, :white)
      when 7
        @grid[row_idx] = first_row(row_idx, :white)
      end
    end

  end

  def pawn_row(row, color)
    Array.new(8).each_index.map do |i|
      Pawn.new([row, i], color, self)
    end
  end

  def first_row(row, color)
    STARTING_ROW.each_with_index.map do |piece,i|
      piece.new([row,i], color, self)
    end
  end

  def null_row
    Array.new(8) { NullPiece.instance }
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

    raise InvalidStartError.new if start_piece.empty?
    raise InvalidEndError.new unless start_piece.valid_moves.include?(end_pos)

    self[end_pos] = start_piece
    self[start_pos] = NullPiece.instance

    start_piece.position = end_pos

  end

  def move_piece!(start_pos, end_pos)
    start_piece = self[start_pos]

    raise InvalidStartError.new if start_piece.empty?

    self[end_pos] = start_piece
    self[start_pos] = NullPiece.instance

    start_piece.position = end_pos

  end

  def in_bounds?(pos)
    pos.all? { |dim| dim.between?(0,7) }
  end

  def in_check?(color)
    flat_grid = self.grid.flatten
    king = flat_grid.find { |piece| piece.is_a?(King) && piece.color == color }

    opposing_moves = get_legal_moves( color == :black ? :white : :black )

    opposing_moves.include?(king.position)
  end

  def checkmate?(color)
    return false unless in_check?(color)

    get_valid_moves(color).all?(&:empty?)
  end

  def get_legal_moves(color)
    moves = []
    pieces = self.grid.flatten.select do |piece|
      !piece.is_a?(NullPiece) && piece.color == color
    end

    pieces.each { |piece| moves += piece.moves }
    moves
  end

  def get_valid_moves(color)
    moves = []
    pieces = self.grid.flatten.select do |piece|
      !piece.is_a?(NullPiece) && piece.color == color
    end

    pieces.each { |piece| moves += piece.valid_moves }
    moves
  end

  def dup
    duped_board = Board.new

    duped_board.grid.each_with_index do |row,row_idx|
      row.each_index do |col_idx|
        pos = [row_idx,col_idx]

        if self[pos].empty?
          duped_board[pos] = NullPiece.instance
        else
          duped_board[pos] = self[pos].dup
          duped_board[pos].board = duped_board
        end
      end
    end

    duped_board
  end

end
