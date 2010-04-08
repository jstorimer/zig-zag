class ColoredBlock < Scrollable
  has_trait :effect

  COLORS = [Gosu::Color::RED, Gosu::Color::BLUE, Gosu::Color::GREEN]
  
  attr_accessor :color

  @@color_index = 0
  
  def initialize(options = {})
    super(options)
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
    @color = COLORS[@@color_index]    
    
    if @@color_index == COLORS.size-1
      @@color_index = 0
    else
      @@color_index += 1
    end
  end
end
