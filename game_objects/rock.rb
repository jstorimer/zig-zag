module Tiles
  Rock = 1
end

class Rock < Chingu::GameObject
  has_trait :bounding_box, :debug => true

  def initialize(options = {})
    super
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[Tiles::Rock]
    # @image = Image["Starfighter.bmp"]
  end
end
