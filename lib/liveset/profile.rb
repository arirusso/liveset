module Liveset

  class Profile

    attr_reader :displays

    def initialize
      #populate_displays
    end

    private

    def populate_displays
      screens = Cocoa::NSScreen.screens
      @displays = (0..screens.count - 1).to_a.map do |i|
        screen = screens.objectAtIndex(i)
        frame = screen.frame
        {
          :height => frame[:size][:height].to_i,
          :width => frame[:size][:width].to_i
        }
      end
    end

  end

end
