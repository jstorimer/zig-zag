class ColoredBlock < Scrollable
  has_traits :effect, :collision_detection
  include Attachable

  COLORS = [Gosu::Color::RED, Gosu::Color::WHITE, Gosu::Color::GREEN]

  attr_accessor :color, :offset_x, :offset_y, :attachable

  @@color_index = 0

  state_machine :state, :initial => :unattached do
    after_transition :on => :die, :do => :fade

    event :attach do
      transition :unattached => :attached
    end

    event :die do
      transition :attached => :dead
      transition :unattached => :dead
    end
  end

  def initialize(options = {})
    super(options)
    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 60, 60, true)[1]
    @color = COLORS[@@color_index]

#     if @@color_index == COLORS.size-1
#       @@color_index = 0
#     else
#       @@color_index += 1
    #     end
    #
  end

  def fade
    puts 'dend'
    destroy
  end

  def attach_to(attachable)
    return if attached?

    stop_scrolling
    attach

    self.offset_x = bb.centerx - attachable.bb.centerx
    self.offset_y = bb.centery - attachable.bb.centery
#     self.offset_x = @x - attachable.x
#     self.offset_y = @y - attachable.y
    self.attachable = attachable
  end

  def tilt_back
    # only works if x > attach.x && y - attach.y
    @x = attachable.bb.centerx - offset_y.abs - bb.width/2

    if @y < attachable.y
      @y = attachable.bb.centery - offset_x - bb.width/2
    elsif @y >= attachable.y
      @y = attachable.bb.centery - offset_x*2.5 - bb.width/2
    end

  end

  def tilt_forward
    # require 'ruby-debug';debugger
    @y = attachable.y + offset_y
    @x = attachable.x + offset_x

    # attachments.each {|a| a.tilt_forward}
  end

  def upright
#     @x = @attachable.x + @offset_x
    #     @y = @attachable.y + @offset_y
    #
    #

    @x = attachable.bb.centerx + offset_x - bb.width/2
    @y = attachable.bb.centery + offset_y - bb.width/2
    # attachments.each {|a| a.upright}
  end

  def update
    if attached?
      @y = attachable.y + offset_y
    end

    ColoredBlock.each_collision(ColoredBlock) do |block1, block2|
      next if block1.attachments.include?(block2)

      block1.attach_to(block2)
      block1.attachments << block2
    end

    die! if y > Config::BOTTOM_BOUNDARY || y < Config::TOP_BOUNDARY

    super
  end
end
