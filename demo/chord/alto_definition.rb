require 'tenor_painter'

class AltoDefinition

  def notes_by_position
    [B, A, G, F, E, D, C, B, A, G, F, E, D]
  end

  def draw_clef bg
    bg.translate 4, 21
    TenorPainter.paint bg
  end

  def low_note? note
    'D' == note.note
  end

  def high_note? note
    'B' == note.note
  end

  def name
    C3
  end
  
  def offset_from_trebble
    -1
  end
  
end
