require 'trebble_painter'

class TrebbleDefinition
  
  def notes_by_position
    [A, G, F, E, D, C, B, A, G, F, E, D, C]
  end

  def draw_clef bg
    bg.translate 4, 6
    TrebblePainter.paint bg
  end

  def low_note? note
    'C' == note.note
  end

  def high_note? note
    'A' == note.note
  end

  def name
    G
  end
  
  def offset_from_trebble
    0
  end
  
end
