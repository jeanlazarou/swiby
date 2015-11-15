#--
# Copyright (C) Swiby Committers. All rights reserved.
# 
# The software in this package is published under the terms of the BSD
# style license a copy of which has been included with this distribution in
# the LICENSE.txt file.
#
#++

class ColorWheel

  # initial values for S and L values of the HSL model color,
  # they must be values between 0 and 1
  def initialize s = 1, l = 0.5
    @s, @l = s, l
  end

  def change_hue(degree)
    
    if degree > 360
      degree -= 360
    elsif degree < 0
      degree += 360
    end
    
    hsl_to_rgb(degree)
    
  end

  private
  
  def hsl_to_rgb(degree)

    h = degree
    s = @s
    l = @l
    
    c = (1 - (2*l - 1).abs) * s
    x = c * ( 1 - ((h / 60) % 2 - 1).abs)
    m = l - c / 2.0
    
    r, g, b = 0

    if (h < 60)
      r = c
      g = x
      b = 0
    elsif (h < 120)
      r = x
      g = c
      b = 0
    elsif (h < 180)
      r = 0
      g = c
      b = x
    elsif (h < 240)
      r = 0
      g = x
      b = c
    elsif (h < 300)
      r = x
      g = 0
      b = c
    else
      r = c
      g = 0
      b = x
    end

    r = normalize_rgb_value(r, m)
    g = normalize_rgb_value(g, m)
    b = normalize_rgb_value(b, m)

    return r, g, b
      
  end

  def normalize_rgb_value color, m
  
    color = ((color + m) * 255).floor
    
    color = 0 if color < 0
    
    color
    
  end

end
