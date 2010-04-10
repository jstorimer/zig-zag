require 'state_machine'

class Scrollable < Chingu::GameObject
  has_trait :bounding_box
  attr_accessor :state

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
