class Menu < Chingu::GameState
  def initialize(options = {})
    super
    PulsatingText.create(:text=>"Welcome to Zig Zag Cave", :x=>Config::GAME_WIDTH/2, :y=>40, :size=>80, :color => Gosu::Color::WHITE, :align => :center)

    @background = Level1.new
    @background.setup

    $player.score_text.destroy
    $player.flame_text.destroy
    @background.update
  end

  def setup
    itext = Chingu::Text.create(:text => "Press i to read the instructions", :x => Config::GAME_WIDTH/2, :y => 375, :size => 40)
    itext.rotation_center(:center_center)

    stext = Chingu::Text.create(:text => "Press space bar to begin playing", :x => Config::GAME_WIDTH/2, :y => 425, :size => 40)
    stext.rotation_center(:center_center)

    self.input = { :space => :begin, :i => :instructions, [:q, :escape] => :exit }
  end

  def draw
    super

    @background.draw
  end

  def begin
    push_game_state(Level1)
  end
  
  def instructions
    push_game_state(Instructions)
  end
end
