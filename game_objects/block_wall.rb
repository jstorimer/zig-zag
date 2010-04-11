class BlockWall < Scrollable
  attr_accessor :blocks, :color

  TOTAL_BLOCKS = 7

  def initialize(options = {})
    super

    @color = ColoredBlock.next_color

    create_rocks
    create_blocks
  end

  def create_rocks
    Rock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * 1)
    Rock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * TOTAL_BLOCKS)
  end

  def create_blocks
    2.upto(6) do |current|
      BasicColoredBlock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * current, :color => @color)
    end
  end
end
