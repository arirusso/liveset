module Liveset

  class ClipPlayer

    extend Forwardable

    def_delegators :@player, :settings, :start

    def initialize(configuration, &block)
      @clips = configuration.vidplayer[:clips]
      @player = VideoPlayer.new(configuration)
      @clip = nil
      configure
    end

    private

    def configure
      receive_channel(settings[:midi][:channel])

      configure_clips
      #configure_speed_control
      configure_system_controls
    end

    def stop_player
      @player.player.player.quit unless @player.player.nil? || @player.player.player.nil?
      true
    end

    def configure_system_controls
      note("F9") do
        puts "Note F9 received, resetting program"
        stop_player
        cmd_line = "#{$0} #{ARGV.join( ' ' )}"
        Kernel.exec(cmd_line)
      end
      note("F#9") do
        puts "Note F#9 received, shutting down"
        stop_player
        Kernel.exec("sudo shutdown now")
      end
      note("G9") do
        puts "Note G9 received, rebooting"
        stop_player
        Kernel.exec("sudo reboot")
      end
    end

    def configure_clips
      @clips.each do |clip|
        cc(clip[:cc]) do |value|
          play_clip(clip) if @clip != clip
          set_position(value)
        end
      end
    end

    def play_clip(clip)
      puts "CC #{clip[:cc]} received, playing #{clip[:file]}"
      vid = video(clip[:file])
      play(vid)
      @clip = clip
    end

    def set_position(value)
      percent = to_percent(value)
      seek(percent, :percent)
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
