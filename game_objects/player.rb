class Player < Chingu::GameObject
  has_traits :collision_detection
  has_trait :bounding_box, :debug => true

  def initialize(options = {})
    super
    @image = Gosu::Image["Starfighter.bmp"]
  end
end
