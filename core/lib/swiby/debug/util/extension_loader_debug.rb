#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/util/extension_loader'

module Swiby
  
  class Extension
  
    code = <<ALIAS_CODE
    
    class << self
      alias :debug__load_extensions_for :load_extensions_for
    end

ALIAS_CODE
    
    eval code

    def self.load_extensions_for category

      debug__load_extensions_for category

      puts "Loaded #{category} extensions:"

      each do |ext|
        puts "    #{ext.name} #{ext.version} (#{ext.author})"
      end

    end

  end
  
end