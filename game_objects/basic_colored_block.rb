class BasicColoredBlock < Scrollable
  has_traits :effect, :collision_detection
  attr_accessor :group, :color

  state_machine :bcb_state, :initial => :alive do
    after_transition :on => :die, :do => :after_life

    event :die do
      transition :alive => :dead
    end
  end

  def initialize(options = {})
    super({:zorder => 200}.merge(options))

    @image = Gosu::Image.load_tiles($window, "media/CptnRuby Tileset.png", 15, 15, true)[1]
    @image.retrofy
    self.scale = 4

    @color = Config::COLOR.dup
    @group = options[:group]
  end

  def after_life
    # template method
  end

  def update
    if dead?
      self.angle += 15
      self.alpha -= 10
      self.scale -= 1
      destroy if self.alpha < 10
    end

    each_bounding_box_collision(ColoredBlock) do |bcb, cb|
      next unless bcb.color.to_s == cb.color.to_s
      next unless cb.attached?
      next unless bcb.group

      bcb.group.die!
      cb.die
    end

    each_bounding_box_collision(Player) do |bcb, player|
      next if bcb.is_a?(ColoredBlock)
      next if bcb.dead?

      if player.flames?
        bcb.die!
      else
        player.die!
      end
    end
  end
end
