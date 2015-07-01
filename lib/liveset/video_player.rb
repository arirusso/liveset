module Liveset

  class VideoPlayer

    attr_reader :settings

    def initialize(configuration, &block)
      @settings = configuration.vidplayer[:settings]
      populate_player
      instance_eval(&block) if block_given?
    end

    def start
      @player.start
    end

    def video(file)
      "#{@settings[:video][:directory]}/#{file}"
    end

    private

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

    def get_midi_inputs
      if match = @settings[:midi][:input].match(/\Achoose(\ (\d+))?\z/)
        num_inputs = match[2] || 1
        inputs = (0..num_inputs.to_i - 1).to_a.map { UniMIDI::Input.gets }
        inputs ||= @settings[:midi][:input]
      end
    end

    def populate_player
      @player = MMPlayer.new(get_midi_inputs, :mplayer_flags => get_mplayer_flags)
    end

    def get_mplayer_flags
      flags = "-noborder -framedrop -zoom -osdlevel 0 -vo corevideo:device_id=#{@settings[:video][:display]} -nosound"
      flags += " -fs" if @settings[:video][:is_fullscreen]
      flags
    end

  end

end
