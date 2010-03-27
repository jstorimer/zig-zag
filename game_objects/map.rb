class Map < Chingu::GameObject
  attr_accessor :transformations, :orientation
  attr_accessor :block_size, :tileset
  attr_accessor :block_x, :block_y
  
  def initialize(options = {})
    if (file = options[:file])
      load_from_file(file)
    else
      # generate_randomly
    end
    
    @orientation = 90 # degrees
    @block_size = 100
    @block_x  = Config::GAME_WIDTH/2
    @block_y  = Config::GAME_HEIGHT/2
  end
  
  def load_from_file(filepath)
    lines = File.readlines(filepath).reverse.map(&:chomp)

    @transformations = []
    lines.each do |line|
      @transformations << Transformation.new(line)
    end
  end
  
  def draw
    puts 'doop'
    transformations.each do |transformation|
      if transformation.type.straight?
        transformation.x = block_x
        transformation.y = block_y
        
        @block_x += block_size
      end
    end
    
    super
  end
end

class Transformation < Chingu::GameObject
  STRAIGHT = 'straight'
  TURN = 'turn'
  FUNNEL = 'funnel'
  attr_accessor :type, :angle, :width, :line, :image
  
  def initialize(line)    
    if is_straight?(line)
      @type = STRAIGHT
    elsif is_turn?(line)
      @type = TURN
      @angle = $1
    elsif is_funnel?(line)
      @type = FUNNEL
      @width = $1
    end
    
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
  end
  
  def is_straight?(line); line =~ /||/; end
  def is_turn?(line); line =~ /\(\) (\d+)/; end
  def is_funnel?(line); line =~ /\\\/ (\d+)/; end
  
  def type
    StringInquirer.new(@type)
  end
  
  def draw
    puts 'whoop'
    
    super
  end
end



######################
#### EXAMPLE MAP FILE
######################
# Map starts at the bottom


# () 45 # turn. Number indicates the angle of the turn
# ||
# \/ 100 # funnel. Number indicates how wide the gutter should be after the funnel
# ||
# ||
# || # straight
