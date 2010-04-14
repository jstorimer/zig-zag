module Chingu
  #
  # The Animation-class helps you load and manage a tileanimation.
  # A Tileanimation is a file where all the frames are put after eachother.
  #
  # An easy to use program to create tileanimations is http://tilestudio.sourceforge.net/ or http://www.humanbalance.net/gale/us/
  #
  # TODO: 
  # Support frames in invidual image-files?
  # Is autodetection of width / height possible? 
  #
  class Animation
    attr_accessor :frames, :delay, :step, :loop, :bounce, :step
    
    #
    # Create a new Animation. 
    #
    #   - loop: [true|false]. After the last frame is used, start from the beginning.
    #   - bounce: [true|false]. After the last frame is used, play it backwards untill the first frame is used again, then start playing forwards again.
    #   - file:   Tile-file to cut up animation frames from. Could be a full path or just a name -- then it will look for media_path(file)
    #   - width:  width of each frame in the tileanimation
    #   - height:  width of each frame in the tileanimation
    #   - size: [width, height]-Array or just one fixnum which will spez both height and width
    #   - delay: milliseconds between each frame
    #   - step: [steps] move animation forward [steps] frames each time we call #next
    #
    def initialize(options)
      options = {:step => 1, :loop => true, :bounce => false, :width => 32, :height => 32, :index => 0, :delay => 100}.merge(options)
      
      @loop = options[:loop]
      @bounce = options[:bounce]
      @file = options[:file]
      @height = options[:height]
      @width = options[:width]
      @index = options[:index]
      @delay = options[:delay]
      @step = options[:step] || 1
      @dt = 0
      
      if options[:size] && options[:size].is_a?(Array)
        @width = options[:size][0]
        @height = options[:size][1]
      elsif options[:size]
        @width = options[:size]
        @height = options[:size]
      end
      
      @file = media_path(@file)  unless File.exist?(@file)
      
      @frame_actions = []
      @frames = Gosu::Image.load_tiles($window, @file, @width, @height, true)
    end
    
    #
    # Returns first frame (GOSU::Image) from animation
    #
    def first
      @frames.first
    end

    #
    # Returns last frame (GOSU::Image) from animation
    #
    def last
      @frames.last
    end
    
    #
    # Fetch a frame or frames:
    #
    #   @animation[0]       # returns first frame
    #   @animation[0..2]    # returns a new Animation-instance with first, second and third frame
    #
    def [](index)
      return @frames[index]               if  index.is_a?(Fixnum)
      return self.new_from_frames(index)  if  index.is_a?(Range)
    end
		
    #
    # Get the current frame (a Gosu#Image)
    #
    def image
      @frames[@index]
    end
		
    #
    # Resets the animation, re-starts it at frame 0
    # returns itself.
    #
    def reset!
      @index = 0
      self
    end
		
    #
    # Returns a new animation with the frames from the original animation.
    # Specify which frames you want with "range", for example "0..3" for the 4 first frames.
    #
    def new_from_frames(range)
      new_animation = self.dup
      new_animation.frames = []
      range.each do |nr|
        new_animation.frames << self.frames[nr]
      end
      return new_animation
    end
    
    #
    # Propelles the animation forward. Usually called in #update within the class which holds the animation.
    # Animation#next() will look at bounce and loop flags to always return a correct frame (a Gosu#Image)
    #
    def next
      if (@dt += $window.milliseconds_since_last_tick) > @delay
        @dt = 0
        @previous_index = @index
        @index += @step
        
        # Has the animation hit end or beginning... time for bounce or loop?
        if (@index >= @frames.size || @index < 0)
          if @bounce
            @step *= -1   # invert number
            @index += @step
          elsif @loop
            @index = 0	
          else
            @index = @previous_index # no bounce or loop, use previous frame
          end
        end
        @frame_actions[@index].call	if	@frame_actions[@index]
      end
      @frames[@index]
    end
		alias :next! :next
    
    #
    # Initialize non-blurry zoom on frames in animation
    #
    def retrofy
      frames.each { |frame| frame.retrofy }
      self
    end
    
    #
    # Execute a certain block of code when a certain frame in the animation is active.
    # This could be used for pixel perfect animation/movement.
    #
    def on_frame(frames, &block)
      if frames.kind_of? Array
        frames.each { |frame| @frame_actions[frame] = block }
      else
        @frame_actions[frames] = block
      end
    end		
  end
end