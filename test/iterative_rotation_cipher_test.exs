defmodule IterativeRotationCipherTest do
  use ExUnit.Case
  doctest IterativeRotationCipher

  describe "IterativeRotationCipher.encode/2" do
    test "returns the correct value for the given example" do
      plain = "If you wish to make an apple pie from scratch, you must first invent the universe."

      cipher =
        "10 hu fmo a,ys vi utie mr snehn rni tvte .ysushou teI fwea pmapi apfrok rei tnocscle"

      assert IterativeRotationCipher.encode(10, plain) == cipher
    end
  end
end
