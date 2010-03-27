class Rock < Chingu::GameObject
  has_trait :bounding_box
  has_trait :effect

  def initialize(options = {})
    super(options)
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
  end
end
