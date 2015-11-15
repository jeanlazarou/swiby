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

require 'keyboard_painter'

module Swiby

  def piano_keyboard_panel options

    options[:actual_class] = PianoKeyboardPanel
    
    draw_panel(options)

  end

  class PianoKeyboardPanel < DrawPanel

    attr_accessor :current_note
    
    def initialize

      super

      @keyboard_painter = KeyboardPainter.new

      self.on_paint { |g|

        g.layer(:background) { |bg|
          @keyboard_painter.paint_background bg
        }

        g.layer(:keys) { |g_keys|

          color = @flash_color ? @flash_color : nil

          @current_note = @keyboard_painter.hover(g_keys, @high_light_pos, color) if @high_light_pos

          if @flash_color

            after 100 do

              @flash_color = nil

              layer(:keys).repaint

            end

          end

        }

      }

      self.on_mouse_over do |x, y|

        @high_light_pos = x

        layer(:keys).repaint

      end

      self.on_mouse_exit do |x, y|

        @high_light_pos = nil

        layer(:keys).repaint

      end

    end

    def flash color

      @flash_color = color

      layer(:keys).repaint

    end

    def refresh

      if layer(:keys)
        layer(:keys).repaint
        layer(:background).repaint
      end

    end

    class PianoKeyboardPanelRegistrar < Registrar

      def register

        super

        need_setter_method

        if @setter_method

          listener = create_listener

          @master << self
          
          add_listener(listener)

        end

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

        @controller.send @setter_method, @wrapper.current_note

        @master.refresh

      end

      def handles_actions?
        !@action_method.nil?
      end

    end

    def create_registrar wrapper, master, controller, id, method_naming_provider
      PianoKeyboardPanelRegistrar.new(wrapper, master, controller, id, method_naming_provider)
    end

  end

end
