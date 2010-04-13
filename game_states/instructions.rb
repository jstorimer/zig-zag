# encoding: UTF-8

class Instructions < Menu
  def setup
    self.input = { [:q, :escape] => :return }
    
    story = "
      Story
      ======
       You are the storied leader of an expedition to
      map the route to the center of Zig Zag Cave.
       Fortune and glory awaits your arrival.
      But beware, no pilot has yet flown the
      terrain of Zig Zag.
       Will you be the first?
    "
    
    Chingu::Text.create(:text => story, :x => 20, :y => 50, :size => 20)
    
    gameplay = "
      Gameplay
      =========
        Due to the barometric pressure in the cave
      your ship is constantly falling. You must 
      continuallyrise up to avoid crashing on the 
      cave floor.
        Zig Zag Cave is known for its floating rocks. 
      The brown colored ones are dangerous and will 
      harm your ship.
    "
    Chingu::Text.create(:text => gameplay, :x => 20, :y => 230, :size => 20)
    Rock.create(:x => 200, :y => 400, :zorder => -1000)
    
    gameplay_cont = "
      Gameplay (cont'd)
      =================
        The colored blocks however will stick to the
      hull of your ship. These ones will protect you,
      push it against a brown rock and it will ensure
      your safety.
        But watch out for them in numbers. A wall of colored
      blocks is just as impenetrable as a brown one.
        If you ever get in a bind you can always just 
      turn on your safety flames and ride to safety.
    "
    Chingu::Text.create(:text => gameplay_cont, :x => 550, :y => 75, :size => 20)
    ColoredBlock.create(:x => 950, :y => 170, :zorder => -1000)
    
    commands = "
      Commands
      ========
      ↑ - Move the ship up
      <space> - Use safety flames
      r - restart game
      p - pause game
      <esc> - quit
    "
    Chingu::Text.create(:text => commands, :x => 550, :y => 300, :size => 20)
  end
  
  def return
    pop_game_state
  end
end
