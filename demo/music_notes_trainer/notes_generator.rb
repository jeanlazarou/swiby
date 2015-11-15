#--
# Copyright (C) Swiby Committers. All rights reserved.
#
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'chord_translator'

NOTES = [A, B, C, D, E, F, G]

class NotesGenerator

  def initialize static_sequence

    if static_sequence[0]

      @sequence = []

      static_sequence.each do |note|
        @sequence << eval(note) if note =~ /[A-G]/
      end

    end

    @last_note = nil

  end

  def next

    if @sequence and @sequence.length > 0
      return @sequence.shift
    end

    new_note = NOTES[rand(7)]
    new_note = NOTES[rand(7)] if new_note == @last_note
    new_note = NOTES[rand(7)] if new_note == @last_note

    @last_note = new_note

    return @last_note, rand(2) == 0

  end


end