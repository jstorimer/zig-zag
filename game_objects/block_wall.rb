class BlockWall
  attr_accessor :blocks, :color

  TOTAL_BLOCKS = 7

  def initialize(options = {})
    @color = Config::COLOR.dup

    @x = options[:x]
    @blocks = []
    create_rocks
    create_blocks
  end

  def create_rocks
    Rock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * 1)
    Rock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * TOTAL_BLOCKS)
  end

  def create_blocks
    2.upto(6) do |current|
      blocks << BasicColoredBlock.create(:x => @x, :y => Config::BOTTOM_BOUNDARY/TOTAL_BLOCKS * current, :color => @color, :group => self)
    end
  end

  def die!
    blocks.each(&:die)
  end
end
