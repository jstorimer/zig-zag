require 'state_machine'

class Scrollable < Chingu::GameObject
  has_trait :bounding_box
  attr_accessor :state

  state_machine :status, :initial => :scrolling do
    event :stop_scrolling do
      transition :scrolling => :not_scrolling
    end
  end
end
