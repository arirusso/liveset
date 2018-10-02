require "unimidi"
  
UniMIDI::Output.open(1) do |output|

  output.puts(0xB0, 0x7C, 0)
  output.puts(0xB0, 0x7F, 0)
  
end
