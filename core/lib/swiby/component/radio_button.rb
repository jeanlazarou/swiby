#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/component/combo'
require 'swiby/component/panel'
require 'swiby/component/button'

require 'swiby/layout/stacked'

import javax.swing.ButtonGroup
import javax.swing.JRadioButton

module Swiby
  
  module Builder
  
    def radio text = nil, image = nil, options = nil, &block
      
      but = button_factory(text, image, options, block) do |opt|
        RadioButton.new(opt)
      end

      layout_list nil, but
      
    end
    
    def radio_group label = nil, values = nil, selected = nil, dir = nil, options = nil, &block
      
      options = ListOptions.new(context, label, values, selected, dir, options, &block)
      
      list_factory(options, :layout_list) do |opt|
        RadioGroup.new(RadioButton, opt)
      end
      
    end
 
  end

  class RadioButton < Button

    def create_button_component
      JRadioButton.new
    end
    
  end
  
  class RadioGroup < ComboBox
    
    def initialize component_class, options = {}
      
      @component_class = component_class
      
      @listeners = []
      @radio_items = []

      @panel = Panel.new
      
      if options[:direction] == :vertical
        layout = {:layout => :stacked, :align => :left}
      elsif options[:direction] == :horizontal
        layout = {:layout => :stacked, :align => :left, :direction => :horizontal}
      else
        layout = nil
      end

      if layout
        @panel.content(layout) {}
      else
        @panel.content() {}
      end
      
      @selected_index = 0
      
      jcomp = @panel.java_component
      def jcomp.removeAllItems
        removeAll
      end
      
      super options
      
    end
    
    def create_list_component
      @panel.java_component
    end
    
    def change_language
      @radio_items.each { |rb| rb.change_language }
    end
    
    def enabled= enabled
      @component.enabled = enabled
      @radio_items.each { |rb| rb.enabled = enabled }
    end
    
    def selection
      @selected_index
    end
    
    def selection=(index)
      @radio_items[index.to_i].selected = true
    end
    
    def item_count
      @radio_items.length
    end
    
    def add_item value
      
      @group = ButtonGroup.new unless @group
      
      radio = @component_class.new(ButtonOptions.new(nil, to_human_readable(value, :short), true))
      
      index = @radio_items.length
      
      radio.java_component.add_action_listener do |evt|
        
        @selected_index = index
      
        @listeners.each do |listener|
          listener.actionPerformed evt
        end
        
      end
      
      @radio_items << radio
      
      @panel.add radio
      @group.add radio.java_component
      
    end
    
    def [] name
      
      if name.is_a?(Integer)
        return @radio_items[name]
      else
        
        @radio_items.each do |comp|
          return comp if (comp.name == name)
        end

      end
      
      nil
      
    end
    
    def add_action_listener listener
      @listeners << listener
    end
    
    def action(&block)
      
      @radio_items.each_index do |i|
        
        @radio_items[i].java_component.add_action_listener do |evt|
          
          @selected_index = i
          
          block.call(@values[i])
          
        end
        
      end
      
    end
    
    def apply_styles styles
      
      return unless styles
      
      color = styles.resolver.find_color(:list, @style_id, @style_class)
      bgcolor = styles.resolver.find_background_color(:list, @style_id, @style_class)

      if Defaults.enhanced_styling?
        
        font = styles.resolver.find_css_font(:list, @style_id, @style_class)
        
        @radio_items.each_index do |i|
          
          radio = @radio_items[i]
          value = @values[i]
          
          value = "#{font}#{value}" if font
          
          radio.java_component.text = value if font
          radio.java_component.foreground = color if color
          radio.java_component.background = bgcolor if bgcolor
          
        end
        
      else
        
        font = styles.resolver.find_font(:list, @style_id, @style_class)
        
        @radio_items.each do |radio|
          radio.java_component.font = font if font
          radio.java_component.foreground = color if color
          radio.java_component.background = bgcolor if bgcolor
        end
        
      end
      
      @panel.java_component.background = bgcolor if bgcolor
        
    end
    
  end
  
end
