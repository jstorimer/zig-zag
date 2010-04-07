begin
  # In case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # In case you don't.
end

require 'chingu'
require 'opengl'

require 'config'
require 'core_ext'

require 'game_states/level1'
require 'game_states/menu'

require_all 'game_objects'
# require_all 'game_states'

class Game < Chingu::Window
  def initialize
    super(Config::GAME_WIDTH, Config::GAME_HEIGHT, false)
    self.caption = "Mapper - By Jesse Storimer"

    transitional_game_state(Chingu::GameStates::FadeTo, :speed => 10)
    
    # push_game_state(Level1)
    push_game_state(Menu)
  end
end

Game.new.show

# A mix of a cave flier and tetris
# 
# There are floating blocks (just like now) but some are colored (and some are rainbow). If you touch one of the non-colored 
# ones you die. If you touch one of the colored ones it sticks to your ship. Can stick to top, bottom, or front. 
# 
# Every once in a while you come across a wall that has a colored patch. If you touch that colored patch with the same colored
# rock (stuck to your ship) then the patch explodes and you pass through safely. Otherwise you die. 
# 
# Colored rocks can stack on top of each other and fall off of your ship if you rub them against a wall or non-colored block.