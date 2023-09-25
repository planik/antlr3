#!/usr/bin/ruby

class IO
  def screen_width
    default_width = (ENV['COLUMNS'] || 80).to_i
    begin
      tiocgwinsz = 0x5413    # ioctl constant for window size
      data = [0, 0, 0, 0].pack('SSSS')
      if ioctl(tiocgwinsz, data) >= 0
        rows, cols, xpixels, ypixels = data.unpack('SSSS')
        cols >= 0 ? cols : default_width
      else
        default_width
      end
    rescue Exception
      default_width
    end
  end

  def screen_height
    default_height = (ENV['LINES'] || 22).to_i
    begin
      tiocgwinsz = 0x5413
      data = [0, 0, 0, 0].pack('SSSS')
      if ioctl(tiocgwinsz, data) >= 0
        rows, cols, xpixels, ypixels = data.unpack('SSSS')
        rows >= 0 ? rows : default_height
      else
        default_height
      end
    rescue Exception
      default_height
    end
  end
end
