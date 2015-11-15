#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/component/toggle'
require 'swiby/component/button'

class ToggleTest < ManualTest
  
  manual 'Test Handler call' do
    
    form {
      
      toggle "Select me (x)", :x do
        context[:report].text = "'x' changed state..."
      end

      toggle "Set 'my state' to 'x'", :y do
        context[:x].selected = context[:y].selected
      end

      button "Check status", :checker do
        
        str = "'x' is #{context[:x].selected? ? 'checked' : 'not checked'}"
        str += ", "
        str += "'y' is #{context[:y].selected? ? 'checked' : 'not checked'}"
        
        context[:report].text = str
        
      end

      label "", :report
      
      visible true
      
    }

  end

end
