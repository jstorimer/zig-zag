begin
  # In case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # In case you don't.
end

require 'chingu'
require 'config'
require 'core_ext'

require 'game_objects/map'
require 'game_objects/player'

require 'game_states/level1'

class Game < Chingu::Window
  def initialize
    super(Config::GAME_WIDTH, Config::GAME_HEIGHT, false)
    self.caption = "Zig Zag - By Jesse Storimer"
    
    push_game_state(Level1)
  end
end

Game.new.show