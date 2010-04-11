class ColoredBlock < Scrollable
  has_traits :effect, :collision_detection, :timer

  COLORS = [Gosu::Color::RED, Gosu::Color::GREEN]

  attr_accessor :color, :offset_x, :offset_y, :attachable

  @@color_index = 0

  state_machine :cb_state, :initial => :unattached do
    after_transition :on => :die, :do => :start_scrolling!

    event :attach do
      transition :unattached => :attached
    end

    event :unattach do
      transition :attached => :unattached
    end

    event :die do
      transition :attached => :dead
      transition :unattached => :dead
    end
  end

  def initialize(options = {})
    super(options.merge(:zorder => 200))

    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
    @color = COLORS[@@color_index]

#     MAKE SOME WALLS PLZ

    if @@color_index == COLORS.size-1
      @@color_index = 0
    else
      @@color_index += 1
    end
  end

  def attach_to(attachable)
    return if attached?

    stop_scrolling
    attach

    self.offset_x = @x - attachable.x
    self.offset_y = @y - attachable.y
    self.attachable = attachable
  end

  def update
    if attached?
      @y = attachable.y + offset_y
    end

    ColoredBlock.each_bounding_box_collision(ColoredBlock) do |block1, block2|
      block1.attach_to(block2)
    end

    each_bounding_box_collision(Rock) do |block, rock|
      block.die
      break
    end

    die! if y > (Config::BOTTOM_BOUNDARY || y < Config::TOP_BOUNDARY) && !dead?

    if dead?
      self.angle += 15
      self.alpha -= 10
      self.scale -= 1
      destroy if self.alpha < 10
    end

    super
  end
end
