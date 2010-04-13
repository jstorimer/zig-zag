class GameOver < Chingu::GameState
  def initialize(options = {})
    super

    @paused = true
    @previous = options[:previous]

    self.input = { [:q, :escape] => :exit, :r => :restart}

    text_color = Gosu::Color::RED
    Chingu::Text.create("Game Over", :x => Config::GAME_WIDTH/3, :y => Config::GAME_HEIGHT/3, :size => 80, :color => text_color, :align => :center)

#     @score_text = Chingu::Text.create("Score: #{@score}", :x => Config::GAME_WIDTH/2, :y => Config::GAME_HEIGHT/3, :size => 40, :color => text_color)
  end

  def restart
    push_game_state(Chingu::GameStates::FadeTo.new(Level1, :speed => 2))
  end

  def draw
    @previous.draw

    super
  end
end
