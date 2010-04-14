#--
#
# Chingu -- OpenGL accelerated 2D game framework for Ruby
# Copyright (C) 2009 ippa / ippa@rubylicio.us
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#++

module Chingu
  module Traits
    #
    # Providing a bounding circle in the form of 2 attributes, self.radius and self.diameter
    # It creates these 2 attributes from reading image.height, image.width, factor_x and factor_y
    #
    # ...this usually only makes sense with rotation_center = :center
    #
    module BoundingCircle
    
      module ClassMethods
        def initialize_trait(options = {})
          trait_options[:bounding_circle] = options
        end
      end
      
      def setup_trait(options)
        @cached_radius = nil
        super
      end
      
      def radius
        return @cached_radius if @cached_radius
        
        width = self.image.width * self.factor_x.abs
        height = self.image.height * self.factor_y.abs
        radius = (width + height) / 4
        radius = radius * trait_options[:bounding_circle][:scale] if  trait_options[:bounding_circle][:scale]
        return radius
      end
      
      def diameter
        radius * 2
      end
      
      def cache_bounding_circle
        @cached_radius = nil
        @cached_radius = self.radius
      end
      
      #def update_trait
      #  cache_bounding_circle  if trait_options[:bounding_circle][:cache] && !@cached_radius
      #  super
      #end
      
      def circle_left;    self.x - self.radius; end
      def circle_right;   self.x + self.radius; end
      def circle_top;     self.y - self.radius; end
      def circle_bottom;  self.y + self.radius; end
      
      def draw_trait
        if trait_options[:bounding_circle][:debug]
          $window.draw_circle(self.x, self.y, self.radius, Chingu::DEBUG_COLOR)
        end
        super
      end
      
    end
  end
end