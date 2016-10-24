require 'colorize'
require_relative 'cursor'

class Display

  COLORS = {
    :bg_light_square => { :background => :green },
    :bg_dark_square => { :background => :blue },
    :bg_cursor => { :background => :red },
    :white => { :color => :white },
    :black => { :color => :black }
  }

  attr_reader :board, :cursor

  def initialize(board)
    @cursor = Cursor.new([0, 0], board)
    @board = board
  end

  def render
    system('clear')
    i = 0

    self.board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, col_idx|
        pos = [row_idx, col_idx]

        print format_square(el, pos, i)

        i += 1
      end
      i += 1
      print "\n"
    end

  end

  def format_square(piece, pos, i)

    piece_str = " #{ piece.to_s.colorize(COLORS[piece.color]) } "

    color = nil
    if highlighted?(pos)
      color = COLORS[:bg_cursor]
    elsif i.odd?
      color = COLORS[:bg_dark_square]
    else
      color = COLORS[:bg_light_square]
    end

    piece_str.colorize(color)
  end

  def highlighted?(pos)
    self.cursor.cursor_pos == pos
  end

  def move
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
