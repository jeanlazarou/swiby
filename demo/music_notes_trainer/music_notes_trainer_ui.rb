#encoding: UTF-8
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

require 'score_panel'
require 'piano_keyboard_panel'

require 'notes_generator'

import org.codehaus.swiby.util.ArrowButton

CONTEXT.language = :fr

to_next = ArrowButton.create(ArrowButton::Orientation::EAST, 20)
to_back = ArrowButton.create(ArrowButton::Orientation::WEST, 20)

class Note
  
  def self.naming_scheme= new_naming
    
    if new_naming == 'A B C'
      @@names = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
    else
      @@names = ['La', 'Si', 'Do', 'Ré', 'Mi', 'Fa', 'Sol']
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

panel = frame(:layout => :card, :effect => :slide) {

  title "Note reading trainer"
  
  use_styles 'styles.rb'
  
  width 750
  height 340

  card(:name_to_position, :layout => :absolute) {
  
    at [10, 60]
      label '', :name => :note
    
    at [-10, 10], relative_to(:parent, :align_right_edge, :align)
      score_panel :name => :proposed_note, :width => 300, :height => 300

    at [-5, -2], relative_to(:parent, :align_right_edge, :align_bottom_edge)
      image_button(to_next[0], to_next[1]) {
        context.show_card :position_to_name
      }
      
    at [10, 0], relative_to(:parent, :align, :align_bottom_edge)
      image_button(CONTEXT.load_icon("uk.png"), CONTEXT.load_icon("uk.png"), :name => :switch_language)

  }
  
  card(:position_to_name, :layout => :absolute) {
  
    at [10, 10]
      score_panel :name => :note_to_find, :width => 300, :height => 300, :readonly => true

    at [10, 50], relative_to(:note_to_find, :right, :align)
      piano_keyboard_panel :name => :keyboard, :width => 420, :height => 200
    
    at [5, -2], relative_to(:parent, :align, :align_bottom_edge)
      image_button(to_back[0], to_back[1]) {
        context.show_card :name_to_position
      }

  }
    
  settings_form = auto_hide('settings', :north, :bg_color => Color.new(8, 107, 106), :style_class => :settings) {
    form {
      section 'Note names'
        radio_group nil, ['A B C', 'La Si Do'], 'La Si Do', :name => :note_names
      section 'Clef'
        radio_group nil, [G, F, C], G, :name => :clef
    }
  }
    
  def change_clef new_clef
    self[:name_to_position][:proposed_note].clef = new_clef
    self[:position_to_name][:note_to_find].clef = new_clef
  end

  def switch_language
    
    button = self[:name_to_position][:switch_language]
    
    if CONTEXT.language == :en
      icon = CONTEXT.load_icon("uk.png")
    else
      icon = CONTEXT.load_icon("fr.png")
    end
    
    button.java_component.icon = icon
    button.java_component.pressed_icon = icon
    button.java_component.rollover_icon = icon
    button.java_component.disabled_icon = icon
    
  end

  def correct_answer
    self[:name_to_position][:proposed_note].flash Color::GREEN if self[:name_to_position].visible?
    self[:position_to_name][:keyboard].flash Color::GREEN if self[:position_to_name].visible?
  end

  def wrong_answer
    self[:name_to_position][:proposed_note].flash Color::RED if self[:name_to_position].visible?
    self[:position_to_name][:keyboard].flash Color::RED if self[:position_to_name].visible?
  end
  
}

class Controller
  
  attr_accessor :clef, :note_names
  
  def initialize

    @clef = G
    @note_names = 'La Si Do'

    @random = NotesGenerator.new(ARGV)

    @current_note, @lower = @random.next

  end
  
  def may_note_names?
    true
  end
  
  def may_clef?
    true
  end
  
  def switch_language
    
    if CONTEXT.language == :en
      CONTEXT.language = :fr
    else
      CONTEXT.language = :en
    end
    
  end
  
  def note_names= new_name
    
    @note_names = new_name
    
    Note.naming_scheme = @note_names

  end

  def clef= new_clef
    @clef = new_clef
    @window.change_clef new_clef
  end

  def note
    @current_note.humanize
  end

  def proposed_note= note

    if note == @current_note

      @window.correct_answer

      @current_note, @lower = @random.next

    else

      @window.wrong_answer

    end

  end

  def note_to_find
    [@current_note, @lower]
  end

  def keyboard= note

    if note == @current_note

      @window.correct_answer

      @current_note, @lower = @random.next

    else

      @window.wrong_answer

    end

  end

end

controller = Controller.new

ViewDefinition.bind_controller panel, controller

panel.visible = true
