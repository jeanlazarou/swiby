#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/component/combo'

import javax.swing.JList
import javax.swing.DefaultListModel

module Swiby

  module Builder
    
     # in case <i>layout_input</i> is not defined in the calling context
    def layout_list label, list
    end

    def list label = nil, values = nil, selected = nil, options = nil, &block

      options = ListOptions.new(context, label, values, selected, options, &block)
      
      list_factory(options, :layout_list) do |opt|
        ListBox.new(opt)
      end
      
    end
    
  end
  
  class ListBox < ComboBox

    attr_accessor :linked_label
    
    def initialize options = nil

      super options
      
      scrollable

    end
    
    def create_list_component

      @model = DefaultListModel.new

      comp = JList.new
      comp.model = @model
      
      comp

    end

    def action(&block)

      listener = ListSelectionListener.new

      @component.addListSelectionListener(listener)

      listener.register do
        
        block.call(@values[@component.get_selected_index])
        
      end
      
    end

    def install_listener iv

      listener = ListSelectionListener.new

      @component.addListSelectionListener(listener)

      listener.register do
        iv.change @component.selected_index
      end

    end
    
    def clear
      @values = []
      @component.model.clear
    end
    
    def remove_at index
      @values.delete_at(index)
      @component.model.remove(index)
    end
    
    def remove value
      
      index = @values.index(value)
      
      remove_at index
      
    end
    
    def item_count
      @model.size
    end
    
    def component_renderer
      @component.cell_renderer
    end
    
    def add_item value
      @model.addElement value
    end

  end
  
end
