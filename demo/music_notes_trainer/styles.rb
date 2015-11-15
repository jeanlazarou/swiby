#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

create_styles {
  root(
    :background_color => Color::WHITE,
    :font_family => Styles::VERDANA,
    :font_style => :normal,
    :font_size => 16
  )
  label(
    :font_size => 126
  )
  settings {
    container(
      :padding => 20,
      :margin => 1,
      :background_color => 0x086b6a,
      :border_color => Color::BLACK
    )
  }
}