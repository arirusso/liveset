module Liveset

  class ClipPlayer

    extend Forwardable

    def_delegators :@player, :settings, :start

    def initialize(configuration, &block)
      @clips = configuration.vidplayer[:clips]
      @player = VideoPlayer.new(configuration)
      configure
    end

    private

    def configure
      receive_channel(settings[:midi][:channel])

      configure_clips
      configure_speed_control
    end

    def configure_clips
      @clips.each do |clip|
        note(clip[:note]) do
          puts "Note #{clip[:note]} received, playing #{clip[:file]}"
          play(video(clip[:file]))
        end
      end
    end

    def configure_speed_control
      cc(1) do |value|
        percent = to_percent(value)
        setting = [(percent / 100.0) * 2, 0.1].max
        speed(setting, :set)
      end
    end

    def method_missing(method, *args, &block)
      if @player.respond_to?(method)
        @player.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @player.respond_to?(method) || super
    end

  end

end
