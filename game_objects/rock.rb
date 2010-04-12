class Rock < Scrollable
  has_trait :effect

  def initialize(options = {})
    super(options)
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 15, 15, true)[1]
    @image.retrofy
  end

  def die
    destroy
  end
end
