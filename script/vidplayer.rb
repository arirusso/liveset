#!/usr/bin/env ruby
$:.unshift(File.join("lib"))

require "liveset"
require "yaml"

@settings = YAML.load_file("config/vidplayer/settings.yml").freeze

@player = Liveset::VideoPlayer.new(@settings) do

  rx_channel @settings[:midi][:channel]

  #note("C3") { play() }
  note("C#3") { play(video("pressure.mov")) }
  note("D3") { play(video("spider.mov")) }
  note("D#3") { play(video("skeleton.mov")) }
  note("E3") { play(video("loop.mov")) }
  note("F3") { play(video("bigbaby.mov")) }

  cc(1) do |value|
   percent = to_percent(value)
   setting = [(percent / 100.0) * 2, 0.1].max
   speed(setting, :set)
 end

end

@player.start #(:background => true)
