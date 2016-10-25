module Stepable

  def moves
    possible_moves = move_diffs

    possible_moves = apply_deltas(self.position, possible_moves)

    possible_moves.select { |pos| valid_step?(pos) }
  end

  private

  def valid_step?(pos)
    if self.board[pos].empty? || self.board[pos].color != self.color
      true
    else
      false
    end
  end
end
