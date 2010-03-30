module Tiles
  Rock = 1
end

class Level1 < Chingu::GameState
  FILE = "media/level1.txt"
  
  ROCK_PADDING = 600

  def initialize
     super
     @player = Player.create(:x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/2)
     @tileset = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)

     self.input = { [:q, :escape] => :exit, :d => :debug }
     
     lines = File.readlines(FILE).map { |line| line.chomp }
     @height = lines.size
     @width = lines[0].size
     @width.times do |x|
       @height.times do |y|
         case lines[y][x, 1]
         when '#'
           rock = Rock.create(:x => x * 52 + ROCK_PADDING, :y => (y/@height.to_f) * $window.height)
           # rock.hide!
         when '^'
           UpFacingRock.create(:x => x * 52 + ROCK_PADDING, :y => (y/@height.to_f) * $window.height)
         when 'v'
           DownFacingRock.create(:x => x * 52 + ROCK_PADDING, :y => (y/@height.to_f) * $window.height)
         end
       end
     end
     
   end

   def draw
     Gosu::Image["Space.png"].draw(0, 0, 0)

     super
   end

   def debug
     push_game_state(Chingu::GameStates::Debug.new({}))
   end
   
   def update
     super

     Rock.all.each do |rock|
       rock.x -= Config::SCROLL_SPEED
       # rock.show! if rock.visible?
     end
     
     # @player.colliding = false

     Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
   end
end
