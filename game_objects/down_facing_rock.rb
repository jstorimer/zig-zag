class DownFacingRock < Rock
  def initialize(options = {})
    super(options)
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[0]
    
    rotate(180)
  end
end