require "helper"

class Liveset::ProfileTest < Minitest::Test

  context "Profile" do

    setup do
      @profile = Liveset::Profile.new
    end

    context "#populate_displays" do

      should "populate displays" do
        refute_nil @profile
        refute_nil @profile.displays
        refute_empty @profile.displays
      end

    end

  end

end
