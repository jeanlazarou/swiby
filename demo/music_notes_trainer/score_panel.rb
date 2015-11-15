#--
# Copyright (C) Swiby Committers. All rights reserved.
#
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/mvc'
require 'swiby/mvc/draw_panel'

require 'swiby/swing/timer'

require 'score_painter'

module Swiby

  def score_panel options

    is_readonly = false

    if options[:readonly]
      is_readonly = options.delete(:readonly)
    end
    
    options[:actual_class] = ScorePanel
    
    panel = draw_panel(options)

    panel.editable = !is_readonly

    panel

  end

  class ScorePanel < DrawPanel

    attr_accessor :editable
    attr_accessor :current_note, :lower

    def initialize

      super

      @editable = true
      @score_painter = ScorePainter.new

      self.on_paint { |g|

        g.layer(:background) { |bg|
          @score_painter.paint_background bg
        }

        g.layer(:notes) { |g_notes|

          color = @flash_color ? @flash_color : Color::BLACK

          if @editable

            @current_note = @score_painter.paint_note_at g_notes, 160, @y, color if @x

            if @flash_color

              after 200 do
                @flash_color = nil
                layer(:notes).repaint
              end

            end

          else
            @score_painter.paint_note g_notes, 160, @current_note, @lower
          end

        }

      }

      self.on_mouse_over do |x, y|

        @x, @y = x, y

        layer(:notes).repaint

      end

    end

    def flash color

      @flash_color = color

      layer(:notes).repaint

    end
    
    def clef= new_clef

      @score_painter.clef = new_clef

      layer(:notes).repaint
      layer(:background).repaint

    end

    def current_note= new_note

      @current_note = new_note

      layer(:notes).repaint if layer(:notes)

    end

    def editable?
      @editable
    end
    
    class ScorePanelRegistrar < Registrar

      def register

        super

        need_getter_method
        need_setter_method

        if @setter_method

          listener = create_listener

          @master << self
          
          add_listener(listener)

        end

        @master << self if @getter_method
        
      end

      def create_listener
        self
      end

      def add_listener listener

        @wrapper.on_click do |x, y|
          execute_action
        end

      end

      def execute_action

        @controller.send @setter_method, @wrapper.current_note if @wrapper.editable?

        @master.refresh

      end

      def display new_value
        @wrapper.current_note = new_value[0]
        @wrapper.lower = new_value[1]
      end

      def handles_actions?
        !@action_method.nil?
      end

    end

    def create_registrar wrapper, master, controller, id, method_naming_provider
      ScorePanelRegistrar.new(wrapper, master, controller, id, method_naming_provider)
    end

  end

end
