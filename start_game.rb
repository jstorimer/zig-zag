require 'rubygems'

require 'state_machine'
require 'chingu'
require 'opengl'

require 'config'
require 'lib/attachable'
require 'lib/pulsating_text'

require 'game_objects/scrollable'
require 'game_objects/basic_colored_block'
require 'game_objects/colored_block'
require 'game_objects/block_wall'
require 'game_objects/block_zag'
require 'game_objects/rock'
require 'game_objects/player'

require 'game_states/game_over'
require 'game_states/level1'
require 'game_states/menu'
require 'game_states/instructions'

class Game < Chingu::Window
  def initialize
    super(Config::GAME_WIDTH, Config::GAME_HEIGHT, false)
    self.caption = "Zig Zag - By Jesse Storimer"

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
