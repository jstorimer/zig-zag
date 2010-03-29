module Tiles
  Rock = 1
end

class Level1 < Chingu::GameState
  FILE = "media/level1.txt"
  
  # attr_accessor :screenx
  ROCK_PADDING = 600

  def initialize
     super
     @player = Player.create(:x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/2)
     @tileset = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)

     self.input = { [:q, :escape] => :exit }
     # self.screenx = 0
     
     lines = File.readlines(FILE).map { |line| line.chomp }
     @height = lines.size
     @width = lines[0].size
     @width.times do |x|
       @height.times do |y|
     # @tiles = Array.new(@width) do |x|
     #   Array.new(@height) do |y|
         case lines[y][x, 1]
         when '#'
           # x = 7
           # 7 * 50 - 5 = 345
           
           # y = 4
           # 4 * 50 - 0 - 600 * 50
           rock = Rock.create(:x => x * 60 + ROCK_PADDING, :y => (y/@height.to_f) * $window.height)
           # rock.hide!
           
           # Tiles::Rock
         else
           nil
         end
       end
     end
     
   end

   def draw
     Gosu::Image["Space.png"].draw(0, 0, 0)

     # Very primitive drawing function:
     # Draws all the tiles, some off-screen, some on-screen.
     # @height.times do |y|
     #   @width.times do |x|
     #     tile = @tiles[x][y]
     #     if tile
     #       # rock = Rock.create(:x => x * 50 + 100, :y => (y/@height.to_f) * $window.height)
     #       @tileset[tile].draw(x * 50 + screenx + ROCK_PADDING, (y/@height.to_f) * $window.height, 10)
     #     end
     #   end
     # end
     
     super
   end
   
   def update
     super

     Rock.all.each do |rock|
       rock.x -= Config::SCROLL_SPEED
       # rock.show! if rock.visible?
     end

     Player.each_collision(Rock) do |player, rock|
       @player.x -= Config::SCROLL_SPEED
       @player.y
       break
     end

     Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
   end
end
