class ColoredBlock < BasicColoredBlock
  has_traits :timer

  attr_accessor :attachable, :offset_y

  state_machine :cb_state, :initial => :unattached do
    event :attach do
      transition :unattached => :attached
    end

    event :unattach do
      transition :attached => :unattached
    end
  end

  def attach_to(attachable)
    return if attached?

    stop_scrolling
    attach

    self.offset_y = @y - attachable.y
    self.attachable = attachable
  end

  def after_life
    start_scrolling!
  end

  def update
    if attached?
      @y = attachable.y + offset_y
    end

    ColoredBlock.each_bounding_box_collision(ColoredBlock) do |block1, block2|
      block1.attach_to(block2)
    end

    each_bounding_box_collision(Rock) do |block, rock|
      die
      break
    end

    die! if (y > Config::BOTTOM_BOUNDARY || y < Config::TOP_BOUNDARY) && !dead?

    super
  end
end
