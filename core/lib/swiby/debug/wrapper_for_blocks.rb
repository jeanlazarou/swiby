#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

  class BlockWrapper
    
    def initialize wrapped
      @wrapped = wrapped
    end
    
    def method_missing(meth, *args, &block)
      @wrapped.send(meth, *args, &block)
    end
    
  end
