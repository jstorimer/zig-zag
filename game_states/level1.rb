class Level1 < Chingu::GameState
  FILE = "media/level1.txt"

  ROCK_PADDING = 300
  ROCK_FACTOR = 52.0

  has_trait :timer
  attr_accessor :next_rock_x, :next_block_x

  def initialize
     super
     @player = Player.create(:x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/2)

     self.input = { [:q, :escape] => :exit, :d => :debug }

     @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left)
     @parallax.add_layer(:image => "mountains.png", :damping => 1, :repeat_x => true)

     # Read in map
     lines = File.readlines(FILE).map { |line| line.chomp }
     @height = lines.size
     @width = lines[0].size
     @width.times do |x|
       @height.times do |y|
         rock_attribs = rock_attribs(x,y)
         case lines[y][x, 1]
         when '#' then Rock.create(rock_attribs)
         when '^' then UpFacingRock.create(rock_attribs)
         when 'v' then DownFacingRock.create(rock_attribs)
         when '>' then RightFacingRock.create(rock_attribs)
         when '<' then LeftFacingRock.create(rock_attribs)
         end
       end
     end

     self.next_rock_x = Config::GAME_WIDTH/ROCK_FACTOR
     self.next_block_x = Config::GAME_WIDTH/ROCK_FACTOR
   end

   def setup
     every(2000) { generate_floating_rock }
     after(1000) do
       every(5000) { generate_colored_block }
     end
   end

   def draw
#      Gosu::Image["Space.png"].draw(0, 0, 0)

     super
   end

   def debug
     push_game_state(Chingu::GameStates::Debug.new({}))
   end

   def rock_attribs(x,y)
     {:x => x * ROCK_FACTOR + ROCK_PADDING, :y => (y/@height.to_f) * $window.height}
   end

   def generate_floating_rock
     x = next_rock_x
     y = rand(@height-1)

     Rock.create(rock_attribs(x,y))
   end
   
   def generate_colored_block
     x = next_rock_x
     y = rand(@height-1)
puts "coming up at #{x} and #{y}"
     ColoredBlock.create(rock_attribs(x,y))
   end

   def update
     super

     @parallax.camera_x += 12

     Scrollable.all.each do |rock|
       rock.x -= Config::SCROLL_SPEED
       # rock.show! if rock.visible?
     end

     self.next_rock_x += 1/ROCK_FACTOR

     Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
   end
end
