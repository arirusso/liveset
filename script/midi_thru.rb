#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

input = UniMIDI::Input.gets
output = UniMIDI::Output.gets

MIDI.using(input, output) do

  thru

  join

end
