class Player < Chingu::GameObject
  has_traits :collision_detection, :effect, :velocity
  has_trait :bounding_box
  
  attr_accessor :accel_rate
  
  FALLING_RATE = 1.05
  RISING_RATE = 0.95
  
  MAX_ACCEL_RATE = 5

  def initialize(options={})
    super(options)
    @image = Gosu::Image["blimp.png"]
    self.input = {:holding_up=>:rise}
    self.max_velocity = 5

    self.acceleration_y = 0.1
  end
  
  def rise
    self.accel_rate *= 1.02
    
    self.acceleration_y = Gosu::offset_y(self.angle, self.accel_rate)*self.max_velocity
  end
  
  def update
    each_collision(Scrollable) do |player, rock|
      if side_collision?(rock)
        @x -= Config::SCROLL_SPEED
      else
        @x -= Config::SCROLL_SPEED/2  # dragging effect
      end

      @y = @previous_y
    end
    
    if !$window.button_down?(Gosu::KbUp)
      self.accel_rate = 0.1
      if self.acceleration_y < 0
        self.acceleration_y *= -FALLING_RATE
      else
        self.acceleration_y *= FALLING_RATE
      end
    end
  end
  
  def colliding?; colliding; end
  
  def side_collision?(scrollable)
    @x < (scrollable.bounding_box.x - scrollable.bounding_box.width)
  end
end
