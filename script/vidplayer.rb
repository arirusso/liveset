#!/usr/bin/env ruby
$:.unshift(File.join("lib"))

require "liveset"
require "yaml"

@player = Liveset::VideoPlayer.new("config/vidplayer/settings.yml", "config/vidplayer/clips.yml") do

  rx_channel @settings[:midi][:channel]

  @clips.each do |clip|
    note(clip[:note]) { play(video(clip[:file])) }
  end

  cc(1) do |value|
   percent = to_percent(value)
   setting = [(percent / 100.0) * 2, 0.1].max
   speed(setting, :set)
 end

end

@player.start #(:background => true)
