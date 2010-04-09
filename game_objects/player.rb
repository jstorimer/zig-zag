class Player < Chingu::GameObject
  has_traits :collision_detection, :effect, :velocity
  has_trait :bounding_box

  attr_accessor :accel_rate, :dead, :attached_blocks

  FALLING_RATE = 1
  RISING_RATE = 1.1

  SCALE_RATE = 0.001

  MAX_ACCEL_RATE = 5

  def initialize(options={})
    super(options)
    @image = Gosu::Image["blimp.png"]
    @image.retrofy
    self.scale = 2

    self.input = { :holding_up => :rise,
      :left => :tilt_back,
      :right => :tilt_forward,
      :released_left => :upright,
      :released_right => :upgright}

    self.max_velocity = 6

    self.acceleration_y = 0.1

    self.attached_blocks = []
  end

  def rise
    return if dead
    self.accel_rate *= 1.01

    self.acceleration_y = Gosu::offset_y(self.angle, self.accel_rate)*self.max_velocity
  end

  def tilt_back
    rotate(-90)

    attached_blocks.each(&:tilt_back)
  end

  def tilt_forward
    rotate(90)

    attached_blocks.each(&:tilt_forward)
  end

  def upright
    @angle = 0

    attached_blocks.each(&:upright)
  end

  def die!
    return if dead

    rotate(180)
    self.velocity_y = 3
    self.dead = true
  end

  def update
    each_collision(Rock) do |player, rock|
      @x -= Config::SCROLL_SPEED
      die!
    end

    if dead
      @y = @previous_y
      @x -= Config::SCROLL_SPEED
      return
    end

    each_collision(ColoredBlock) do |player, block|
      attached_blocks << block
      block.attach_to(player)
    end

    if @x <= bounding_box.width/2
      die!
    end

    if !$window.button_down?(Gosu::KbUp)
      self.accel_rate = 0.1
      if self.acceleration_y < 0
        self.acceleration_y *= -FALLING_RATE
      else
        self.acceleration_y *= FALLING_RATE
      end

      # Make sure that the falling eventually gets to the same speed
      if (velocity_y + acceleration_y).abs > max_velocity
        @velocity_y = max_velocity
      end
    end
  end

  def colliding?; colliding; end

  def side_collision?(scrollable)
    @x < (scrollable.bounding_box.x - scrollable.bounding_box.width/2)
  end
end
