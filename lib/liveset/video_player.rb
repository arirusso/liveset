module Liveset

  class VideoPlayer

    def initialize(settings, &block)
      @settings = settings
      @player = MMPlayer.new(@settings[:midi][:input], :mplayer_flags => mplayer_flags)
      instance_eval(&block)
    end

    def video(file)
      "#{@settings[:video][:directory]}/#{file}"
    end

    def method_missing(method, *args, &block)
      if @player.respond_to?(method)
        @player.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method)
      @player.respond_to?(method) || super
    end

    private

    def mplayer_flags
      flags = "-noborder -framedrop -zoom -osdlevel 0 -vo corevideo:device_id=#{@settings[:video][:display]} -nosound"
      flags += " -fs" if @settings[:video][:is_fullscreen]
      flags
    end

  end

end
