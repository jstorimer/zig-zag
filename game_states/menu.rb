class Menu < Chingu::GameState 
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"Pretty Blocks", :x=>200, :y=>50, :size=>30)
    self.input = { :space => :begin }
  end
  
  def begin
    push_game_state(Level1)
  end
end
