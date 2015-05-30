module Liveset

  class Configuration

    DIR = {
      :vidplayer => "config/vidplayer",
      :vz => "config/vz"
    }
    FILE = {
      :vidplayer => {
        :settings => "#{DIR[:vidplayer]}/settings.yml",
        :clips => "#{DIR[:vidplayer]}/clips.yml"
      },
      :vz => {
        :server => "#{DIR[:vz]}/server.yml"
      }
    }

    attr_reader :vidplayer, :vz

    def initialize
      populate
    end

    private

    def populate
      @vidplayer = {
        :clips => YAML.load_file(FILE[:vidplayer][:clips]).freeze,
        :settings => YAML.load_file(FILE[:vidplayer][:settings]).freeze
      }
      @vz = {
        :server => YAML.load_file(FILE[:vz][:server]).freeze
      }
    end

  end

end
