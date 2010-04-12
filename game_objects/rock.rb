class Rock < Scrollable
  has_trait :effect

  def initialize(options = {})
    super(options)
    @image = if Config.retro?
               im = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 15, 15, true)[1]
               im.retrofy
               self.scale = 4
               im
             else
               Gosu::Image.load_tiles($window, "media/big-CptnRuby Tileset.png", 15, 15, true)[1]
             end
  end

  def die
    destroy
  end
end
