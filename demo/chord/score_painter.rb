#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/2d'

require 'chord_translator'

require 'flat_painter'
require 'sharp_painter'

require 'alto_definition'
require 'bass_definition'
require 'tenor_definition'
require 'trebble_definition'

# some special constants...
C3 = Note.new('C')
C4 = Note.new('C')

def C3.to_s; "C3"; end
def C4.to_s; "C4"; end

class ScorePainter
  
  LINE_5 = 70

  G_NOTES_Y = [
     LINE_5 + 3 * 30 - 27, # A
     LINE_5 + 2 * 30 - 12, # B
     LINE_5 + 5 * 30 - 12, # C
     LINE_5 + 4 * 30 + 3,  # D
     LINE_5 + 4 * 30 - 12, # E
     LINE_5 + 3 * 30 + 3,  # F
     LINE_5 + 3 * 30 - 12, # G
  ]
  G_UPPER_NOTES_Y = [
     LINE_5 - 1 * 30 - 12, # A
     LINE_5 + 2 * 30 - 12, # B
     LINE_5 + 1 * 30 + 3,  # C
     LINE_5 + 1 * 30 - 12, # D
     LINE_5 + 0 * 30 + 3 , # E
     LINE_5 + 0 * 30 - 12, # F
     LINE_5 - 1 * 30 + 3,  # G
  ]
  
  NOTE_HEIGHT = 24
  SPACE_HEIGHT = 30
  
  def initialize
  
    @supported_clefs = {
      F => BassDefinition.new,
      G => TrebbleDefinition.new,
      C4 => TenorDefinition.new,
      C3 => AltoDefinition.new,
    }
    
    @supported_clefs.default = @supported_clefs[G]
    
    self.clef = G
    
  end
  
  # Valid values for +clef+ are: 
  #  bass    => F3
  #  trebble => G4
  #  tenor   => C4
  # But any F would be bass clef, any G would be trebble, etc.
  def clef= clef
  
    @clef_definition = @supported_clefs[clef]
    
    @notes_by_position = @clef_definition.notes_by_position
      
    @notes_y = G_NOTES_Y.rotate(@clef_definition.offset_from_trebble)
    @upper_notes_y = G_UPPER_NOTES_Y.rotate(@clef_definition.offset_from_trebble)

  end
  
  def paint_background bg
    
    bg.background Color::WHITE
    bg.clear
  
    bg.antialias = true
    
    bg.stroke_width 1
    bg.color Color::GRAY
    bg.draw_rect 0, 0, bg.width - 1, bg.height - 1
    
    # draw staff
    bg.stroke_width 2
    bg.color Color::BLACK
    
    5.times do |i|
      
      pos = LINE_5 + i * 30
    
      bg.draw_line 10, pos, bg.width - 10, pos
      
    end
    
    # draw clef
    bg.scale 2.8

    @clef_definition.draw_clef bg
    
  end
  
  def paint_note g, x, note, lower
    
    g.antialias = true
    
    i = note.index
  
    y = lower ? @notes_y[i] : @upper_notes_y[i]
  
    draw_note g, x, y, note, lower
    
  end
  
  def paint_note_at g, x, y, color
    
    y -= SPACE_HEIGHT / 2
    
    if y < LINE_5 - 1.5 * SPACE_HEIGHT
      y = LINE_5 - 1.5 * SPACE_HEIGHT
    elsif y > SPACE_HEIGHT / 2 + LINE_5 + 4 * 30
      y = SPACE_HEIGHT / 2 + LINE_5 + 4 * 30
    end
    
    note, lower = find_note(y)
    
    g.color color
    g.antialias = true
    
    draw_note g, x, y, note, lower
    
    note
    
  end
  
  def paint_chord g, chord
    
    g.antialias = true
    g.color Color::BLUE
    
    x = 160
    previous_y = 300    
    
    chord.each do |note|
      
      i = note.index
      
      lower, y = true, @notes_y[i]
      lower, y = false, @upper_notes_y[i] if y > previous_y
    
      draw_note g, x, y, note, lower
      
      if note.pitch == '#'
        draw_sharp g, x, y
      elsif note.pitch == 'b'
        draw_flat g, x, y
      end
      
      previous_y = y
      x += 100
      
    end
    
  end
    
  def draw_sharp g, x, y
    
    g.save_transform
    g.translate x - 26, y - 9
    g.scale 1.4
    SharpPainter.paint g
    g.restore_transform
    
  end
  
  def draw_flat g, x, y
    
    g.save_transform
    g.translate x - 30, y - 18
    g.scale 1.6
    FlatPainter.paint g
    g.restore_transform
    
  end

  def draw_note g, x, y, note, lower
      
    g.fill_oval x, y, 40, NOTE_HEIGHT

    if lower && @clef_definition.low_note?(note) ||
       !lower && @clef_definition.high_note?(note)
      
      g.stroke_width 2
      g.draw_line x - 11, y + 10, x + 40 + 10, y + 11
    
    end
      
  end

  def find_note y
    
    if y < LINE_5 - SPACE_HEIGHT
      index = 0
    elsif y > LINE_5 + 4 * 30 + SPACE_HEIGHT
      index = @notes_by_position.length - 1
    else
      index = ((y - LINE_5) / (30 / 2)) + 3
    end
    
    lower = index > 5
    
    note = @notes_by_position[index]

    return note, lower
    
  end
  
end
