class Player < Chingu::GameObject
  has_traits :collision_detection, :effect, :velocity
  has_trait :bounding_box, :debug => true
  
  attr_accessor :falling
  
  FALLING_RATE = 1.05
  RISING_RATE = 0.95

  def initialize(options={})
    super(options)
    @image = Gosu::Image["Starfighter.bmp"]
    self.input = {:holding_up=>:rise}
    self.max_velocity = 10
  end
  
  def rise
    return if on_top_edge?
    self.falling = false
    
    self.velocity_y = Gosu::offset_y(self.angle, 0.5)*self.max_velocity
  end
  
  def update
    if on_top_edge?
      self.velocity_y = FALLING_RATE
      self.falling = true
      return 
    elsif on_bottom_edge?
      self.velocity_y = 0
      return
    end
    # return if on_edge?
    
    if velocity_y < 0 && velocity_y > -0.1
      self.falling = true
    end
    
    if falling
      if self.velocity_y < 0
        self.velocity_y *= -FALLING_RATE
      else
        self.velocity_y *= FALLING_RATE
      end
    else
      self.velocity_y *= RISING_RATE
    end
  end
  
  private
  def on_top_edge?
    @y <= 0 + bounding_box.height
  end
  
  def on_bottom_edge?
    @y >= $window.height - bounding_box.height
  end
end
