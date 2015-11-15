#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

module Swiby

  def self.current_method
    caller[0] =~ /`([^']*)'/ and $1
  end
  
  def self.install_debug *modules
    
    modules.each do |mod|
      
      case mod
      when :remote_loader
        require 'swiby/debug/util/remote_loader_debug'
      when :local_loader
        require 'swiby/debug/util/local_loader_debug'
      when :extension_loader
        require 'swiby/debug/util/extension_loader_debug'
      when :simple_cache
        require 'swiby/debug/util/simple_cache_debug'
      end
    
    end
    
  end
  
end

class Module
  
  def trace_call method, source_file = nil, source_line = nil
    
    new_name = "debug__#{method}".to_sym
    
    return if method_defined?(new_name)
    
    alias_method new_name, method

    source_file = File.basename(source_file) if source_file
    
    define_method method do |*args|
      puts "[trace] #{Swiby.current_method}(#{args.join(', ')}) in #{source_file}:#{source_line}"
      res = self.send(new_name, *args)
      puts "[trace] #{Swiby.current_method} => #{res.nil? ? 'nil' : res.to_s} in #{source_file}:#{source_line}"
      res
    end
  
  end
  
  def trace_static_call method, source_file = nil, source_line = nil
    
    new_name = "debug__#{method}"
    
    return if method_defined?(:new_name)

    source_file = File.basename(source_file) if source_file
    
    code = <<DEF_AROUND
    
    class << self

      alias :#{new_name} :#{method}
      
      def #{method} *args
        puts "[trace] \#{Swiby.current_method}(\#{args.join(', ')}) in #{source_file}:#{source_line}"
        res = self.send(:#{new_name}, *args)
        puts "[trace] \#{Swiby.current_method} => \#{res.nil? ? 'nil' : res.to_s} in #{source_file}:#{source_line}"
        res
      end

    end
    
DEF_AROUND
    
    eval code
      
  end
  
end
