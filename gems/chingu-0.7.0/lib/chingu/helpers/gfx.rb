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
  module Helpers
    
  #
  # Various helper-methods to manipulate the screen.
  # All drawings depend on the global variable $window which should be an instance of Gosu::Window or Chingu::Window
  #
  module GFX
  
    #
    # Fills whole window with specified 'color' and 'zorder'
    #
    #def fill(color, zorder = 0)
    #  $window.draw_quad(0, 0, color,
    #                    $window.width, 0, color,
    #                    $window.width, $window.height, color,
    #                    0, $window.height, color,
    #                    zorder, :default)
    #end
    #
    
    # Fills window or a given rect with a gradient between two colors.
    #
    #   :from         - Start with this color
    #   :to           - End with this color
    #   :rect         - Only fill rectangle :rect with the gradient, either a Rect-instance or [x,y,width,height] Array.
    #   :orientation  - Either :vertical (top to bottom) or :horizontal (left to right)
    #
    
    def fill(options, zorder = 99)
      #
      # if only 1 color-argument is given, assume fullscreen simple color fill.
      #
      if options.is_a?(Gosu::Color)
        $window.draw_quad(0, 0, options,
                        $window.width, 0, options,
                        $window.width, $window.height, options,
                        0, $window.height, options, 0, :default)
        return
      end
      
      default_options = { :colors => [Gosu::Color.new(0xFFFFFFFF), Gosu::Color.new(0xFF000000)],
                          :orientation => :vertical,
                          :rect => Rect.new([0, 0, $window.width, $window.height]),
                          :zorder => 0,
                          :mode => :default
                        }
			options = default_options.merge(options)
      rect = Rect.new(options[:rect])
      
      if options[:orientation] == :vertical
        x = rect.x
        y = rect.y
        right = rect.right
        bottom = rect.bottom
        
        step = (rect.x + rect.right) / options[:colors].size
        1.upto(options[:colors].size).each do |nr|
          from = options[:colors]
          to = 
        
          $window.draw_quad(  x, y, options[:from],
                            x + step, rect.y, options[:from],
                            x + step, rect.bottom, options[:to],
                            x, rect.bottom, options[:to],
                            options[:zorder], options[:mode]
                          )
        end
      else
        $window.draw_quad(  rect.x, rect.y, options[:from],
                            rect.x, rect.bottom, options[:from],
                            rect.right, rect.bottom, options[:to],
                            rect.right, rect.y, options[:to],
                            options[:zorder], options[:mode]
                          )        
      end
    end
    
    #
    # Draws an unfilled rect in given color
    #
    def draw_rect(rect, color, zorder)
      $window.draw_line(rect.x, rect.y, color, rect.right, rect.y, color, zorder)
      $window.draw_line(rect.right, rect.y, color, rect.right, rect.bottom, color, zorder)
      $window.draw_line(rect.right, rect.bottom, color, rect.x, rect.bottom, color, zorder)
      $window.draw_line(rect.x, rect.bottom, color, rect.x, rect.y, color, zorder)
    end
    
    
    #
    # Draws an unfilled circle, thanks shawn24!
    #
    CIRCLE_STEP = 10
    def draw_circle(cx,cy,r,color)      
      0.step(360, CIRCLE_STEP) do |a1|
        a2 = a1 + CIRCLE_STEP
        $window.draw_line cx + Gosu.offset_x(a1, r), cy + Gosu.offset_y(a1, r), color, cx + Gosu.offset_x(a2, r), cy + Gosu.offset_y(a2, r), color, 9999
      end
    end
    
    #
    # Fills a given Rect 'rect' with Color 'color', drawing with zorder 'zorder'
    #
    def fill_rect(rect, color, zorder = 0)
      rect = Rect.new(rect)     # Make sure it's a rect
      $window.draw_quad(  rect.x, rect.y, color,
                          rect.right, rect.y, color,
                          rect.right, rect.bottom, color,
                          rect.x, rect.bottom, color,
                          zorder, :default)
    end
    
    #
    # Fills window or a given rect with a gradient between two colors.
    #
    #   :from         - Start with this color
    #   :to           - End with this color
    #   :rect         - Only fill rectangle :rect with the gradient, either a Rect-instance or [x,y,width,height] Array.
    #   :orientation  - Either :vertical (top to bottom) or :horizontal (left to right)
    #
    def fill_gradient(options)
      default_options = { :from => Gosu::Color.new(255,0,0,0),
                          :to => Gosu::Color.new(255,255,255,255), 
                          :thickness => 10, 
                          :orientation => :vertical,
                          :rect => Rect.new([0, 0, $window.width, $window.height]),
                          :zorder => 0,
                          :mode => :default
                        }
			options = default_options.merge(options)
      rect = Rect.new(options[:rect])
      
      if options[:orientation] == :vertical
        $window.draw_quad(  rect.x, rect.y, options[:from],
                            rect.right, rect.y, options[:from],
                            rect.right, rect.bottom, options[:to],
                            rect.x, rect.bottom, options[:to],
                            options[:zorder], options[:mode]
                          )
      else
        $window.draw_quad(  rect.x, rect.y, options[:from],
                            rect.x, rect.bottom, options[:from],
                            rect.right, rect.bottom, options[:to],
                            rect.right, rect.y, options[:to],
                            options[:zorder], options[:mode]
                          )        
      end
    end
  end
  
  end
end