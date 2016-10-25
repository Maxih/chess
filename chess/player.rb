require_relative 'display'

class Player

  attr_reader :name, :color, :display

  def initialize(name, display, color)
    @display = display
    @name = name
    @color = color
  end
end
