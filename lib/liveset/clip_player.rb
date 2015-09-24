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
      configure_system_controls
    end

    def configure_system_controls
      note("F9") do
        puts "Note F9 received, resetting program"
        cmd_line = "#{$0} #{ARGV.join( ' ' )}"
        Kernel.exec(cmd_line)
      end
      note("F#9") do
        puts "Note F#9 received, shutting down"
        Kernel.exec("sudo shutdown now")
      end
      note("G9") do
        puts "Note G9 received, rebooting"
        Kernel.exec("sudo reboot")
      end
    end

    def configure_clips
      @clips.each do |clip|
        note(clip[:note]) do
          puts "Note #{clip[:note]} received, playing #{clip[:file]}"
          vid = video(clip[:file])
          play(vid)
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
