module Liveset

  class VideoPlayer

    def initialize(settings_file, clips_file, &block)
      @settings = YAML.load_file(settings_file).freeze
      @clips = YAML.load_file(clips_file).freeze
      populate_player
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

    def get_midi_input
      input = UniMIDI::Input.gets if @settings[:midi][:input] == "choose"
      input ||= @settings[:midi][:input]
    end

    def populate_player
      @player = MMPlayer.new(get_midi_input, :mplayer_flags => get_mplayer_flags)
    end

    def get_mplayer_flags
      flags = "-noborder -framedrop -zoom -osdlevel 0 -vo corevideo:device_id=#{@settings[:video][:display]} -nosound"
      flags += " -fs" if @settings[:video][:is_fullscreen]
      flags
    end

  end

end
