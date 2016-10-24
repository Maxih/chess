require 'byebug'
module Slideable

  def moves
    possible_directions = directions
    possible_moves = []
    debugger
    possible_directions.each do |(row, col)|
      possible_moves.concat(grow_unblocked_moves_in_dir(row, col))
    end

    possible_moves
  end

  private

  def directions
    dirs = []
    dir_names = move_dirs
    dirs += diagonal_dirs if dir_names.include?(:diagonal)
    dirs += horizontal_dirs if dir_names.include?(:horizontal)

    dirs
  end

  def diagonal_dirs
    [[1,-1],[-1,1],[-1,-1],[1,1]]
  end

  def horizontal_dirs
    [[1,0],[0,1],[-1,0],[0,-1]]
  end

  def grow_unblocked_moves_in_dir(dx,dy)
    moves = []
    blocked = false
    new_pos = [self.position.first, self.position.last]
    until blocked
      new_pos = [new_pos.first + dx, new_pos.last + dx]
      if self.board[new_pos].empty?
        moves << new_pos
      else
        blocked = true
        moves << new_pos unless self.board[new_pos].color == self.color
      end
    end

    moves
  end
end
