class Level1 < Chingu::GameState
  FILE = "media/level1.txt"
  attr_accessor :screen_y

  def initialize
     super
     @player = Player.create(:x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/2)
     @map = Map.create(:file => FILE)

     @map.input = { [:holding_a, :holding_left, :holding_pad_left] => :turn_left,
                       [:holding_d, :holding_right, :holding_pad_right] => :turn_right
                     }
     self.input = { [:q, :escape] => :exit }
   end

   def draw
     Gosu::Image["Space.png"].draw(0, 0, 0)

     super
   end
end
