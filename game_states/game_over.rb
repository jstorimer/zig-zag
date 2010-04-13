class GameOver < Chingu::GameState
  def initialize(options = {})
    super

    @paused = true
    @previous = options[:previous]

    self.input = { [:q, :escape] => :exit, :r => :restart}

    text_color = Gosu::Color::RED
    got = Chingu::Text.create("Game Over", :x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/3, :size => 80, :color => text_color, :align => :center)
    got.rotation_center(:center_center)
    
    scoret = Chingu::Text.create("Score: #{$player.score}", :x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/3 + 100, :size => 40, :color => text_color)
    scoret.rotation_center(:center_center)
  end

  def restart
    push_game_state(Chingu::GameStates::FadeTo.new(Level1, :speed => 2))
  end

  def draw
    @previous.draw

    super
  end
end
