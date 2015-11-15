#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/mvc/text'
require 'swiby/mvc/image'
require 'swiby/mvc/frame'
require 'swiby/mvc/label'
require 'swiby/mvc/button'
require 'swiby/mvc/radio_button'

require 'swiby/component/form'
require 'swiby/component/auto_hide'

require 'swiby/layout/card'
require 'swiby/layout/absolute'

require 'score_panel2'
require 'piano_keyboard_panel'

require 'notes_generator'

import org.codehaus.swiby.util.ArrowButton

to_next = ArrowButton.create(ArrowButton::Orientation::EAST, 20)
to_back = ArrowButton.create(ArrowButton::Orientation::WEST, 20)

class Note
  
  def self.naming_scheme= new_naming
    
    if new_naming == 'A B C'
      @@names = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
    else
      @@names = ['La', 'Si', 'Do', 'Ré'.to_utf8, 'Mi', 'Fa', 'Sol']
    end
      
  end
    
  self.naming_scheme = 'La Si Do'
  
  def self.names
    @@names
  end

  def humanize
    Note.names[@index]
  end
  
  def to_s
    humanize
  end
  
end

#NEW tag for new things
panel = frame(:layout => :card, :effect => :slide) {

  title "Note reading trainer"
  
  use_styles 'styles.rb'
  
  width 750
  height 720

  card(:name_to_position, :layout => :absolute) {
  
    at [10, 10]
      label 'A', :name => :note_1
    at [10, 20], relative_to(:note_1, :align, :below)
      label 'A', :name => :note_2
    at [10, 20], relative_to(:note_2, :align, :below)
      label 'A', :name => :note_3
    at [10, 20], relative_to(:note_3, :align, :below)
      label 'A', :name => :note_4
    
    at [-10, 10], relative_to(:parent, :align_right_edge, :align)
      score_panel :name => :score_1, :width => 240, :height => 260
    at [0, -90], relative_to(:score_1, :align, :below)
      score_panel :name => :score_2, :width => 240, :height => 260
    at [0, -90], relative_to(:score_2, :align, :below)
      score_panel :name => :score_3, :width => 240, :height => 260
    at [0, -90], relative_to(:score_3, :align, :below)
      score_panel :name => :score_4, :width => 240, :height => 260

    at [-5, -2], relative_to(:parent, :align_right_edge, :align_bottom_edge)
      image_button(to_next[0], to_next[1]) {
        context.show_card :position_to_name
      }
      
    at [10, 0], relative_to(:parent, :align, :align_bottom_edge)
      image_button(CONTEXT.load_icon("uk.png"), CONTEXT.load_icon("uk.png"), :name => :switch_language)

  }

}

class Controller
end

controller = Controller.new

ViewDefinition.bind_controller panel, controller

panel.visible = true