#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/component/button'
require 'swiby/component/radio_button'

import javax.swing.JToggleButton

module Swiby
  
  module Builder
  
    #TODO write tests for toggle, toggle_group + toggle-mvc (re-test radio_group_test, list and combo)
    #TODO make toggle_group / radio_group more generic => kinda list(-group) with style or param to inner items? => do we need them, custome list items does exist in Swing
    def toggle text = nil, image = nil, options = nil, &block
      
      but = button_factory(text, image, options, block) do |opt|
        Toggle.new(opt)
      end
      
      layout_list nil, but
      
      but
      
    end
  
    #TODO toggle_group / radio_group where the same...
    # options:
    #    :text_size => :short, :normal or :long
    def toggle_group values = nil, selected = nil, dir = nil, options = nil, &block
      
      options = ListOptions.new(context, values, selected, dir, options, &block)
      
      list_factory(options, :layout_list) do |opt|
        RadioGroup.new(Toggle, opt)
      end
      
    end 
 
  end

  class Toggle < Button

    def create_button_component
      JToggleButton.new
    end
    
  end
    
end
