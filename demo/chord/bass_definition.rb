require 'bass_painter'

class BassDefinition

  def notes_by_position
    [C, B, A, G, F, E, D, C, B, A, G, F, E]
  end

  def draw_clef bg
    bg.translate 4, 19
    BassPainter.paint bg
  end

  def low_note? note
    'E' == note.note
  end

  def high_note? note
    'C' == note.note
  end

  def name
    F
  end
  
  def offset_from_trebble
    -2
  end
  
end
