class BasicColoredBlock < Scrollable
  has_traits :effect, :collision_detection
  attr_accessor :wall

  COLORS = [Gosu::Color::RED, Gosu::Color::GREEN]
  attr_accessor :color
  @@color_index = 0

  def self.next_color
    COLORS[@@color_index].dup.tap do
      if @@color_index == COLORS.size-1
        @@color_index = 0
      else
        @@color_index += 1
      end
    end
  end

  state_machine :bcb_state, :initial => :alive do
    after_transition :on => :die, :do => :after_life

    event :die do
      transition :alive => :dead
    end
  end

  def initialize(options = {})
    super(options.merge(:zorder => 200))

    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
    @color = options[:color] || self.class.next_color

    @wall = options[:wall]
  end

  def after_life
    # template method
  end

  def update
    if dead?
      self.angle += 15
      self.alpha -= 15
      self.scale -= 1
      destroy if self.alpha < 10
    end

    each_bounding_box_collision(ColoredBlock) do |bcb, cb|
      next unless bcb.color.to_s == cb.color.to_s
      next unless cb.attached?
      next unless bcb.wall

      bcb.wall.die!
      cb.die
    end

    each_bounding_box_collision(Player) do |bcb, player|
      next if bcb.is_a?(ColoredBlock)
      next if bcb.dead?

      player.die!
    end
  end
end
