class Player < Chingu::GameObject
  has_traits :collision_detection, :effect, :velocity
  has_trait :bounding_box

  attr_accessor :accel_rate, :dead

  FALLING_RATE = 1
  RISING_RATE = 0.95

  SCALE_RATE = 0.001

  MAX_ACCEL_RATE = 5

  def initialize(options={})
    super(options)
    @image = Gosu::Image["blimp.png"]
    @image.retrofy
    self.scale = 2

    self.input = { :holding_up => :rise, :holding_left => :tilt_back, :holding_right => :tilt_forward }
    self.max_velocity = 9

    self.acceleration_y = 0.1
  end

  def rise
    return if dead
    self.accel_rate *= 1.02

    self.acceleration_y = Gosu::offset_y(self.angle, self.accel_rate)*self.max_velocity
  end

  def tilt_back
    return if angle == -90
    rotate(-10)
  end

  def tilt_forward
    return if angle == 90
    rotate(10)
  end

  def die!
    return if dead

    rotate(180)
    self.velocity_y = 3
    self.dead = true
  end

  def update
    return if dead

    unless $window.button_down?(Gosu::KbLeft) || $window.button_down?(Gosu::KbRight)
      rotate(-angle) #reset player
    end

    if @x <= bounding_box.width/2
      die!
    end

    each_collision(Scrollable) do |player, rock|
#       if side_collision?(rock)
#         @x -= Config::SCROLL_SPEED
#       else
#         @x -= Config::SCROLL_SPEED/2  # dragging effect
#         @y = @previous_y
#       end
      die!
#       scale(SCALE_RATE) # should only happen on grass collisisons, player needs to die on rock collisisons
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
    @x < (scrollable.bounding_box.x - scrollable.bounding_box.width/2)
  end
end
