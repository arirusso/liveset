module Liveset

  class ClipPlayer

    extend Forwardable

    def_delegators :@player, :settings, :start

    def initialize(settings_file, clips_file, &block)
      @clips = YAML.load_file(clips_file).freeze
      @player = VideoPlayer.new(settings_file)
      configure
    end

    private

    def configure
      rx_channel(settings[:midi][:channel])

      @clips.each do |clip|
        note(clip[:note]) { play(video(clip[:file])) }
      end

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
