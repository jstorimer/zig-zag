class Player < Chingu::GameObject
  include Attachable

  has_traits :collision_detection, :effect, :velocity, :timer, :bounding_box

  attr_accessor :accel_rate, :dead, :score, :score_text, :flames, :flames_count, :flame_text
  alias :dead? :dead

  FALLING_RATE = 1
  RISING_RATE = 1.1
  NUMBER_OF_FLAMES = 3

  def initialize(options={})
    super(options)
    @image = Gosu::Image["blimp.png"]
    @image.retrofy
    self.scale = 4

    self.input = { :holding_up => :rise, :space => :fire }

    self.max_velocity = 5
    self.acceleration_y = 0.1

    self.score = 0
    self.flames_count = 0

    init_text
  end
  
  def init_text
    text_color = Gosu::Color::WHITE
    @score_text = Chingu::Text.create("Score: #{@score}", :x => 0, :y => 0, :size => 30, :color => text_color)
    @flame_text = Chingu::Text.create("Flames remaining: #{NUMBER_OF_FLAMES-flames_count}", :x => 180, :y => 0, :size => 30, :color => text_color)
  end

  def rise
    return if dead?
    self.accel_rate *= 1.01

    self.acceleration_y = Gosu::offset_y(self.angle, self.accel_rate)*self.max_velocity
  end

  def fire
    return unless flames_count < NUMBER_OF_FLAMES
    return if flames?

    @flames_count += 1
    @flames = Chingu::Particle.create(:x => @x,
                                      :y => @y,
                                      :image => Gosu::Image.load_tiles($window, "media/fireball.png", 32, 32, true)[0],
                                      )

    @flames.scale(6)

    during(2000) {
      @flames.y = @y
      @flames.x = @x
    }.then do
      @flames.destroy
      @flames = nil
    end
  end
  alias :flames? :flames

  def die!
    return if dead?

    rotate(180)
    self.velocity_y = 3
    self.dead = true

    attachments.each(&:die)
  end

  def update
    each_collision(Rock) do |player, rock|
      player.die! unless player.flames?
      break
    end

    if dead?
      @y = @previous_y
      @x -= Config::SCROLL_SPEED
      return
    end

    @score += 1
    @score_text.text = "Score: #{@score}"
    @flame_text.text = "Flames remaining: #{NUMBER_OF_FLAMES-flames_count}"

    each_collision(ColoredBlock) do |player, block|
      attachments << block
      block.attach_to(player)
    end

    die! if x < 0
    die! if y > Config::BOTTOM_BOUNDARY || y < Config::TOP_BOUNDARY

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
end
