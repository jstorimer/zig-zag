class BlockZag
  attr_accessor :blocks, :color, :width

  HEIGHT_BLOCKS = 7
  WIDTH_BLOCKS = 7

  def initialize(options = {})
    @color = ColoredBlock.next_color

    @x = options[:x]
    @blocks = []
    @width = BasicColoredBlock.new.bb.width

    create_rocks
    create_blocks
  end

  def create_rocks
    1.upto(HEIGHT_BLOCKS/2) do |current|
      Rock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/HEIGHT_BLOCKS * current)
    end

    HEIGHT_BLOCKS.downto(HEIGHT_BLOCKS/2 + 2) do |current|
      Rock.create(:x => @x + @width*WIDTH_BLOCKS+@width, :y => Config::BOTTOM_BOUNDARY/HEIGHT_BLOCKS * current)
    end
  end

  def create_blocks
    1.upto(WIDTH_BLOCKS) do |current|
      blocks << BasicColoredBlock.create(:x => @x + width*current, :y =>Config::BOTTOM_BOUNDARY/HEIGHT_BLOCKS * HEIGHT_BLOCKS/2, :color => @color, :group => self)
    end
  end

  def die!
    blocks.each(&:die)
  end
end
