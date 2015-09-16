module Liveset

  class VideoPlayer

    attr_reader :settings

    def initialize(configuration, &block)
      puts "Starting video player"
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

    def populate_player_report(inputs, flags)
      puts "Using MIDI inputs:"
      inputs.each_with_index { |input, i| puts "#{i+1}. #{input.name}" }
      puts "Using MPlayer flags `#{flags}`"
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

    def get_midi_inputs
      if match = @settings[:midi][:input].match(/\Achoose(\ (\d+))?\z/)
        num_inputs = match[2] || 1
        inputs = (0..num_inputs.to_i - 1).to_a.map { UniMIDI::Input.gets }
        inputs ||= @settings[:midi][:input]
      else @settings[:midi][:input].match(/\Aall\z/)
        UniMIDI::Input.all.map(&:open)
      end
    end

    def populate_player
      flags = get_mplayer_flags
      inputs = get_midi_inputs
      populate_player_report(inputs, flags)
      puts "Starting MPlayer"
      @player = MMPlayer.new(inputs, :mplayer_flags => flags)
    end

    def get_mplayer_flags
      flags = "-noborder -framedrop -zoom -osdlevel 0 -nosound -vo x11 -fixed-vo"
      flags += " -fs" # if @settings[:video][:is_fullscreen]
      flags
    end

  end

end
