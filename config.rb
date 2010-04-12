module Config
  GAME_WIDTH = 1000
  GAME_HEIGHT = 500

  TOP_BOUNDARY = 80
  BOTTOM_BOUNDARY = GAME_HEIGHT - 80

  SCROLL_SPEED = 8

  @@retro = true
  def self.retro=(bool)
    @@retro = bool
  end

  def self.retro?
    !!@@retro
  end
end
