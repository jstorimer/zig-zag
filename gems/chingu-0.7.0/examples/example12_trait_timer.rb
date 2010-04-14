#!/usr/bin/env ruby
require 'rubygems'
require File.join(File.dirname($0), "..", "lib", "chingu")
include Gosu
include Chingu

#
# Using trait "timer" to achieve various moves
#
class Game < Chingu::Window
  def initialize
    super(640,400)
    self.input = {:esc => :exit}
    self.caption = "Example of Chingus :timer trait (arrows,space,return sets timers that affects @x,@y & @color)"
    
    Cube.create(:x => 200, :y => 200)
  end
end

class Cube < GameObject
  has_trait :timer
  
  def initialize(options)
    super
    self.input = {  :left => :left, :right => :right, :up => :up, :down => :down, 
                    :space => :shake1, :return => :shake2 }
  end
  
  def left
    during(500) { @x -= 1 }
  end
  
  def right
    during(500) { @x += 1 }
  end
  
  def up
    @color = Color::RED
    during(500) { @y -= 1 }.then { @color = Color::WHITE }
  end

  def down
    @color = Color::BLUE
    during(500) { @y += 1 }.then { @color = Color::WHITE }
  end

  def shake1
    #
    # Nesting works too!
    #
    during(50) {@y -= 4}.then  { during(100) {@y += 4}.then { during(50) {@y -= 4} } }
  end
  
  def shake2
    #
    # Does the exact same as "shake1" but using between() instead of during()
    #
    between(0,50) {@y -= 4}
    between(50,150) {@y += 4}
    between(150,200) {@y -= 4}
  end
  
  def draw
    $window.fill_rect([@x, @y, 40, 40], @color)
  end
end

Game.new.show
