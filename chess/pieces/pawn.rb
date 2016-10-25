require_relative 'piece'

class Pawn < Piece

  def symbol
    "♟"
  end

  def moves
    forward_steps + side_attacks
  end

  protected

  def at_start_row?
    (self.color == :white && self.position.first == 6) ||
      (self.color == :black && self.position.first == 1)
  end

  def forward_dir
    return -1 if self.color == :white

    1
  end

  def forward_steps
    steps = [[forward_dir, 0]]

    steps << [forward_dir*2, 0] if at_start_row?

    steps = apply_deltas(self.position, steps)

    return [] unless self.board[steps.first].empty?

    steps.reject { |pos| is_opponent?(pos) }
  end

  def side_attacks
    deltas = [[forward_dir, 1], [forward_dir, -1]]

    attacks = apply_deltas(self.position, deltas)

    attacks.select { |pos| is_opponent?(pos) }
  end

  def is_opponent?(pos)
    !(self.board[pos].empty? || self.board[pos].color == self.color)
  end
end
