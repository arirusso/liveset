require "midi"
require "pp"

@input = MIDI::Input.gets

MIDI.using(@input) do

  receive do |message|
    pp(message)
  end

  loop { wait_for_input }

end
