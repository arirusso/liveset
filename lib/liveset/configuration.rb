module Liveset

  class Configuration

    attr_reader :vidplayer

    def initialize(settings_file, clips_file)
      populate(settings_file, clips_file)
    end

    private

    def populate(settings_file, clips_file)
      @vidplayer = {
        :clips => YAML.load_file(clips_file).freeze,
        :settings => YAML.load_file(settings_file).freeze
      }
    end

  end

end
