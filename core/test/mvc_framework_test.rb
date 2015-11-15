#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

require 'swiby/test'
require 'swiby/mvc'

include Swiby

empty_view = Swiby.define_view(:empty_view) do
  window :open => true do
      button 'Close', :id => :close
  end
end

gui_test_suite('Test GUI test support') {

  context {
    @window = Views[:empty_view].instantiate(Object.new)
  }
  
  test('Expected error detected') {
    check {
      close.should_be_disabled
    }
  }
  
}