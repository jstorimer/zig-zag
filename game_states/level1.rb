class Level1 < Chingu::GameState
  ROCK_PADDING = 300
  ROCK_FACTOR = 52.0

  has_trait :timer
  attr_accessor :next_rock_x, :next_block_x, :next_perim_x, :score

  def initialize
     super
     @player = Player.create(:x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/2)

     self.input = { [:q, :escape] => :exit, :d => :debug, :r => :restart }

     self.next_rock_x = Config::GAME_WIDTH/ROCK_FACTOR
    self.next_block_x = Config::GAME_WIDTH/ROCK_FACTOR
    self.next_perim_x = Config::GAME_WIDTH
    self.score = 0
   end

   def setup
     init_parallax     

     every(1500) { generate_floating_rock }
     every(4000) { generate_colored_block }
   end
   
   def init_parallax
     Chingu::ParallaxLayer.send(:has_trait, :effect)
     @top_parallax = Chingu::Parallax.create(:x => 0, :y => 10, :rotation_center => :top_left)
     @top_parallax.add_layer(:image => "mountains.png", :damping => 1, :repeat_x => true)
     
     top = Chingu::ParallaxLayer.new(:repeat_x => true, :damping => 1)
     top.image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[0]
     top.angle = 180
     top.zoom(0.2)
     @top_parallax << top
     
     @bottom_parallax = Chingu::Parallax.create(:x => 0, :y => Config::GAME_HEIGHT-10)
     bottom = Chingu::ParallaxLayer.new(:repeat_x => true, :damping => 1)
     bottom.image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[0]
     bottom.zoom(0.2)
     @bottom_parallax << bottom
   end

   def debug
     push_game_state(Chingu::GameStates::Debug.new({}))
   end
   
   def restart
     push_game_state(self.class)
   end

   def rock_attribs(x,y)
     {:x => x * ROCK_FACTOR + ROCK_PADDING, :y => y}
   end

   def generate_floating_rock
     x = next_rock_x
     
     min = 80
     y = min + (rand(Config::BOTTOM_BOUNDARY - min))

     Rock.create(rock_attribs(x,y))
   end

   def generate_colored_block
     x = next_rock_x
     
     min = 80
     y = min + rand(Config::BOTTOM_BOUNDARY - min)

     ColoredBlock.create(rock_attribs(x,y))
   end

   def next_rock_x
     @next_rock_x.tap do
       @next_rock_x += 1/ROCK_FACTOR
     end
   end

   def update
     super

     [@top_parallax, @bottom_parallax].each {|p| p.camera_x += 6}

     Scrollable.all.each do |rock|
       rock.x -= Config::SCROLL_SPEED if rock.scrolling?
     end

     Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
     Rock.destroy_if { |object| object.x < 0 }
     ColoredBlock.destroy_if { |object| object.x < 0 }
   end
end
