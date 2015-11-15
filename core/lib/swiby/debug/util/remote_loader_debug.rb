#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/util/remote_loader'

module Kernel
  trace_call :resolve_file, __FILE__, __LINE__
end

module Swiby
  
  class RemoteLoader
    trace_static_call :from_cache, __FILE__, __LINE__
  end
  
end
