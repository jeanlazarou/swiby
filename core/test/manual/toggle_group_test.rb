#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/layout/stacked'
require 'swiby/component/toggle'

class ToggleGroupTest < ManualTest

  manual 'Toggle Group / default layout / no data' do
    
    form {
      
      title "Toggle Group / default layout / no data"
      
      width 340
      height 200
      
      label 'blue should be selected'

      toggle_group 'Color:', ['red', 'green', 'blue'], 'blue', :name => :color
      
      button "'green' by index" do
        context[:color].selection = 1
      end
      
      button "'red' by value" do
        context[:color].value = 'red'
      end
      
      visible true
      
    }
    
  end

  manual 'Toggle Group / default layout / w/ data' do
    
    class MyColor
      
      attr_accessor :color
      
      def initialize color
        @color = color
      end
      
    end

    my_colors = MyColor.new('blue')

    form {
      
      title "Radio Group / default layout / w/ data"
      
      data my_colors
      
      width 340
      height 200
      
      label 'blue should be selected'

      toggle_group 'Color:', ['red', 'green', 'blue'], :color
      
      button "'green' by index" do
        context[:color].selection = 1
      end
      
      button "'red' by value" do
        context[:color].value = 'red'
      end
      
      visible true
      
    }
    
  end

  manual 'Toggle Group / vertical / no data' do
    
    form {
      
      title "Toggle Group / vertical / no data"
      
      width 340
      height 200
      
      label 'blue should be selected'

      toggle_group 'Color:', ['red', 'green', 'blue'], 'blue', :name => :color, :direction => :vertical
      
      button "'green' by index" do
        context[:color].selection = 1
      end
      
      button "'red' by value" do
        context[:color].value = 'red'
      end
      
      visible true
      
    }

  end

  manual 'Toggle Group test selection' do
    
    form {
      
      title "Toggle Group test selection"
      
      width 340
      height 200
      
      toggle_group('Color:', ['red', 'green', 'blue'], 'blue') { |color|
        message_box "Selected color is '#{color}'"
      }
      
      visible true
      
    }

  end

  class ColorTermsHumanizer
  
    MAP_SHORT = {:red => 'R', :blue => 'B', :green => 'G'}
    
    def humanize value, size
      MAP_SHORT[value] if size == :short
    end
    
  end
  
  manual 'Toggle Group test humanized values' do
    
    CONTEXT.humanizer = ColorTermsHumanizer.new
    
    form {
      
      width 340
      height 200
      
      toggle_group('Color:', [:red, :green, :blue], :blue)
      
      visible true
    
    }

    CONTEXT.humanizer = nil

  end
  
end
