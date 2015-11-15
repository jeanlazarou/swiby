#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'chord_translator'

class KeyboardPainter

  def initialize

    @ligh_gray = Color.new(245, 245, 236)
    
    @font = Graphics.create_font("Arial", Font::PLAIN, 30)
    
    @keyboard_to_note = [C, D, E, F, G, A, B]
    @note_to_keyboard = @keyboard_to_note.map {|note| note.index}
    
  end
      
  def white_keys
    
    unless @white_positions
    
      @white_positions = []
      
      7.times do |i|
        @white_positions << [i * 60, 0, 59, 199]
      end
      
    end
    
    @white_positions
    
  end
  
  def black_keys
    
    unless @black_positions
    
      @black_positions = []
      
      @black_positions << [40, 0, 40, 120]
      @black_positions << [40 + 60, 0, 40, 120]
      @black_positions << [40 + 3 * 60, 0, 40, 120]
      @black_positions << [40 + 4 * 60, 0, 40, 120]
      @black_positions << [40 + 5 * 60, 0, 40, 120]
    
    end
    
    @black_positions
    
  end
  
  def paint_background bg
    
    bg.background Color::WHITE
    bg.clear
  
    bg.antialias = true
    
    bg.stroke_width 1
    bg.color Color::BLACK
    
    bg.draw_rect 0, 0, bg.width - 1, bg.height - 1

    white_keys.each do |rect|
      bg.draw_rect *rect
    end
    
    draw_black_keys bg

    keys = white_keys
    names = Note.names
    
    keys.each_index do |i|
      draw_note bg, i
    end
    
  end
  
  def hover g, x, color = nil
    
    @white_positions.each_index do |i|
      
      rect = @white_positions[i]
      
      if x >= rect[0] and x < rect[0] + rect[2]
        
        g.antialias = true
        
        g.color color ? color : @ligh_gray
        g.fill_rect *rect
        
        g.color Color::BLACK
        g.draw_rect *rect
      
        draw_black_keys g

        draw_note g, i, Color::BLACK
        
        return @keyboard_to_note[i]
        
      end
      
    end
    
    nil
    
  end
  
  def draw_note g, note_position, color = nil
    
    g.set_font @font
    g.color color if color
    
    rect = @white_positions[note_position]
    
    g.centered_string Note.names[@note_to_keyboard[note_position]], rect[0] + rect[2] / 2, rect[1] + 170
    
  end
  
  def draw_black_keys g
    
    black_keys.each do |rect|
      g.fill_round_rect *(rect + [10, 8])
    end
    
  end
  
end
