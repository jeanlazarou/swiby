#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/core'
require 'swiby/util/local_loader'
require 'swiby/util/remote_loader'

require 'java'

module Swiby

  module AWT
    java_import 'java.awt.EventQueue'
    java_import 'java.awt.FlowLayout'
  end
  
  module JAVA
    java_import 'java.lang.Runnable'
  end
  
  java_import 'javax.swing.JScrollPane'

  def message_box text
    JOptionPane.showMessageDialog nil, text
  end
  
  def exit exit_code = 0
    exit_code = exit_code ? 0 : 1 unless exit_code.is_a?(Fixnum)
    java.lang.System.exit(exit_code)
  end
  
  def create_icon(url)

    if url =~ /http:\/\/.*/
      url = java.net.URL.new(url)
    elsif url =~ /file:\/\/.*/
      url = url[7..-1]
    elsif File.exist?(url)
      url = "#{File.expand_path(url)}"
    else
      
      url = resolve_file(url)

      return nil unless url
      
    end

    ImageIcon.new(url)

  end

  # @param size the size to the readable text :short, :normal or :long
  def to_human_readable(value, size = :long)
    
    if value.respond_to? :humanize
      value.humanize
    elsif value.respond_to? :name
      value.name
    elsif CONTEXT.humanize?
      CONTEXT.to_human_readable(value, size)
    else
      value.to_s
    end

  end

  class Runnable

    include JAVA::Runnable

    def initialize &run
      @run = run
    end

    def run
      @run.call
    end

  end
  
  class SwingBase

    attr_accessor :style_class
    
    def self.swing_attr_accessor(symbol, *args)
      generate_swing_attribute to_map(symbol, args), :include_attr_reader
    end

    def self.swing_attr_writer(symbol, *args)
      generate_swing_attribute to_map(symbol, args)
    end

    def self.container(symbol)
      raise RuntimeError, "#{symbol} is not a Symbol" unless symbol.is_a? Symbol

      eval %{
        def #{symbol}(array = nil, &block)
          if array.nil?
            self.addComponents block.call
          else
            self.addComponents array
          end
        end
      }
    end
    
    def change_language
    end
    
    def gui_wrapper?
      true
    end

    def scrollable
      @scroll_pane = JScrollPane.new @component
    end

    def visible?
      @component.visible?
    end
    
    def visible= visible
      @component.visible = visible
    end
    
    def setBounds x, y, w, h
      @component.setBounds x, y, w, h
    end

    def on_focus_lost &handler
      
      listener = FocusLostListener.new
      
      listener.register &handler
      
      java_component(true).addFocusListener(listener)
      
    end

    def install_listener iv
    end

    def font
      java_component.font
    end

    def font= f
      java_component.font = f
    end
    
    def java_component force_no_scroll = false
      return @component if force_no_scroll
      return @component if @scroll_pane.nil?
      @scroll_pane
    end

    def java_container
      nil
    end

    def apply_styles styles = nil
    end
    
    def invoke_later &block
      runnable = Runnable.new(&block)
      AWT::EventQueue::invokeLater runnable
    end
    
    #TODO remove private because some calls to 'addComponents' were forbidden (with JRuby 1.0.1)
    #private

    def self.to_map(symbol, args)
      map = Hash.new
      fill_map map, symbol
      args.each {|sym| fill_map map, sym } unless args.nil?
      map
    end

    def self.fill_map(map, x)
      if x.is_a? Hash
        x.each do |k, v|
          raise RuntimeError, "#{k} must be a Symbol" unless k.is_a? Symbol
          map[k] = v
        end
      elsif x.is_a? Symbol
        map[x] = nil
      else
        raise RuntimeError, "#{x} must be a Symbol"
      end
      map
    end

    def self.generate_swing_attribute(map, include_attr_reader=nil)
      map.each do |symbol, javaName|
        javaName ||= symbol
        if include_attr_reader
          class_eval %{
            def #{symbol}
              @component.#{javaName}
            end
          }
        end

        class_eval %{

          def #{symbol}=(val)
            @component.#{javaName} = val
          end

          def #{symbol}
            @component.#{javaName}
          end

        }
      end

    end

    def addComponents(array)
      if array.respond_to? :each
        array.each do |comp|
          @component.add comp.java_component
        end
      else
        @component.add array.java_component
      end
    end
    
    swing_attr_accessor :name
    swing_attr_accessor :preferred_size
    
  end

end
