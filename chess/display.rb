require 'colorize'
require_relative 'cursor'

class Display

  COLORS = {
    :bg_light_square => { :background => :light_black },
    :bg_dark_square => { :background => :white },
    :bg_cursor => { :background => :red },
    :white => { :color => :light_white },
    :black => { :color => :black },
    :moves => { :background => :light_red },
    :selected => { :background => :light_blue }
  }

  attr_reader :board, :cursor

  def initialize(board,debug = false)
    @cursor = Cursor.new([0, 0], board)
    @board = board
    @debug = debug
  end

  def render
    system('clear')
    i = 0

    moves = []

    moves = self.board[self.cursor.cursor_pos].valid_moves unless self.board[self.cursor.cursor_pos].is_a? NullPiece


    self.board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, col_idx|
        pos = [row_idx, col_idx]

        print format_square(el, pos, i, moves)

        i += 1
      end
      i += 1
      print "\n"
    end

  end

  def format_square(piece, pos, i, moves)

    piece_str = " #{piece.to_s} ".colorize(COLORS[piece.color])

    color = nil
    if highlighted?(pos)
      color = COLORS[:bg_cursor]
    elsif selected?(pos)
      color = COLORS[:selected]
    elsif i.odd?
      color = COLORS[:bg_dark_square]
    else
      color = COLORS[:bg_light_square]
    end

    color = COLORS[:moves] if @debug && moves.include?(pos)

    piece_str.colorize(color)
  end

  def highlighted?(pos)
    self.cursor.cursor_pos == pos
  end

  def selected?(pos)
    self.cursor.selected == pos
  end

  def get_pos
    input = nil
    until input
      self.render
      begin
        input = self.cursor.get_input
      rescue InvalidEndError
        retry
      end
    end

    input
  end



end
