require 'tenor_painter'

class TenorDefinition

  def notes_by_position
    [G, F, E, D, C, B, A, G, F, E, D, C, B]
  end

  def draw_clef bg
    bg.translate 4, 10
    TenorPainter.paint bg
  end

  def low_note? note
    'B' == note.note
  end

  def high_note? note
    'G' == note.note
  end

  def name
    C
  end
  
  def offset_from_trebble
    1
  end
  
end
