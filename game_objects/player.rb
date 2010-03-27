class Player < Chingu::GameObject
  has_traits :collision_detection, :effect, :velocity
  has_trait :bounding_box, :debug => true
  
  attr_accessor :falling, :accel_rate
  
  FALLING_RATE = 1.05
  RISING_RATE = 0.95
  
  MAX_ACCEL_RATE = 0.5

  def initialize(options={})
    super(options)
    @image = Gosu::Image["Starfighter.bmp"]
    self.input = {:holding_up=>:rise}
    self.max_velocity = 3
    self.accel_rate = 0.1
    
    self.falling = true
    self.acceleration_y = 0.01
  end
  
  def rise
    return if on_top_edge?
    self.falling = false
    
    if accel_rate < MAX_ACCEL_RATE
      self.accel_rate *= 1.02
    end
    
    self.acceleration_y = Gosu::offset_y(self.angle, self.accel_rate)*self.max_velocity
  end
  
  def update
    if on_top_edge?
      self.acceleration_y = FALLING_RATE
      self.falling = true
      return 
    elsif on_bottom_edge?
      self.velocity_y = 0
      return
    end

    if velocity_y < 0 && velocity_y > -3
      self.falling = true
    end
    
    if falling
      self.accel_rate = 0.01
      if self.acceleration_y < 0
        self.acceleration_y *= -FALLING_RATE
      else
        self.acceleration_y *= FALLING_RATE
      end
    else
      # self.acceleration_y *= RISING_RATE
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
