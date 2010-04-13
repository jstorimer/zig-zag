class Scrollable < Chingu::GameObject
  has_traits :bounding_box, :effect
  attr_accessor :state

  def initialize(options = {})
    super
    self.scale = 4
  end

  state_machine :scroll_state, :initial => :scrolling do
    event :stop_scrolling do
      transition :scrolling => :not_scrolling
    end

    event :start_scrolling do
      transition :not_scrolling => :scrolling
      transition :scrolling => same
    end
  end
end
