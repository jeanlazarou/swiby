# File generated on 2014-10-12 10:32:59 +0200 from source res/sharp.svg

# test this file with: ruby -Ipath_to_swiby_lib -I. sharp_painter.rb

module SharpPainter
  

  def self.paint g
  
    
    g.save_transform

    g.save_transform

    path = java.awt.geom.Path2D::Double.new

    path.moveTo 12.8125, 1.5625
    path.lineTo 12.8125, 7.40625
    path.lineTo 8.90625, 8.65625
    path.lineTo 8.90625, 2.5625
    path.lineTo 7.75, 2.5625
    path.lineTo 7.75, 9.0625
    path.lineTo 6.03125, 9.625
    path.lineTo 6.03125, 13.75
    path.lineTo 7.75, 13.1875
    path.lineTo 7.75, 19.15625
    path.lineTo 6.03125, 19.71875
    path.lineTo 6.03125, 23.875
    path.lineTo 7.75, 23.3125
    path.lineTo 7.75, 28.84375
    path.lineTo 8.90625, 28.84375
    path.lineTo 8.90625, 22.90625
    path.lineTo 12.8125, 21.625
    path.lineTo 12.8125, 27.78125
    path.lineTo 13.96875, 27.78125
    path.lineTo 13.96875, 21.28125
    path.lineTo 15.53125, 20.75
    path.lineTo 15.53125, 16.625
    path.lineTo 13.96875, 17.125
    path.lineTo 13.96875, 11.1875
    path.lineTo 15.53125, 10.65625
    path.lineTo 15.53125, 6.5
    path.lineTo 13.96875, 7.03125
    path.lineTo 13.96875, 1.5625
    path.lineTo 12.8125, 1.5625
    path.closePath

    path.moveTo 12.8125, 11.5625
    path.lineTo 12.8125, 17.5
    path.lineTo 8.90625, 18.78125
    path.lineTo 8.90625, 12.84375
    path.lineTo 12.8125, 11.5625
    path.closePath

    g.fill_path path

    g.restore_transform

    g.restore_transform

      
  end


end

if $0 == __FILE__

  require 'swiby'
  require 'swiby/mvc/frame'

  require 'swiby/component/draw_panel'

  class Painter
  
    def paint g
    
      g.drawing_size 22.0, 30.0
      
      g.layer(:background) do |bg|
        
        bg.antialias = true
        
        bg.background Color::WHITE
        bg.clear
        
        SharpPainter.paint bg
        
      end
      
    end
    
  end
  
  painter = Painter.new
  
  frame(:ratio => 0.7333333333333333) {
    
    width 176
    height 240
    
    title __FILE__
    
    draw_panel(:resize_always => true) { |g|
      painter.paint(g)
    }
    
    visible true

  }
      
end
