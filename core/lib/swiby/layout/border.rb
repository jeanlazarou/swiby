#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

import java.awt.BorderLayout

require 'swiby/layout_factory'

module Swiby

  # BorderLayout maps to java's one but adds a ratio option
  # where ratio is (width / height)
  class BorderLayoutFactory
  
    def accept name
      name == :border
    end
    
    def create name, data
          
      layout = SwibyBorderLayout.new

      layout.hgap = data[:hgap] if data[:hgap]
      layout.vgap = data[:vgap] if data[:vgap]
      
      layout.ratio = data[:ratio] if data[:ratio]
          
      def layout.add_layout_extensions component

        return if component.respond_to?(:swiby_border__actual_add)

        class << component
          alias :swiby_border__actual_add :add
        end

        def component.add x

          if @position
            swiby_border__actual_add x, @position
          else
            swiby_border__actual_add x
          end

        end

        def component.north
          @position = BorderLayout::NORTH
        end

        def component.east
          @position = BorderLayout::EAST
        end

        def component.center
          @position = BorderLayout::CENTER              
        end

        def component.south
          @position = BorderLayout::SOUTH              
        end

        def component.west
          @position = BorderLayout::WEST
        end

      end

      layout
                
    end
    
  end
  
  LayoutFactory.register_factory(BorderLayoutFactory.new)
  
  class SwibyBorderLayout < BorderLayout
   
    attr_accessor :ratio
    
    def layoutContainer(parent)
      
      super
      
      if @ratio
        
        center = getLayoutComponent(BorderLayout::CENTER)
        
        rect = center.bounds
        
        width = rect.height * ratio
        height = rect.width / ratio
        
        if height > rect.height
          rect.x += (rect.width - width) / 2
          height = rect.height
        elsif width > rect.width
          rect.y += (rect.height - height) / 2
          width = rect.width
        end
        
        center.setBounds(rect.x, rect.y, width, height)
        
      end
    
    end
    
  end
  
end