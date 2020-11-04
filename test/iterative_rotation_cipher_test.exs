defmodule IterativeRotationCipherTest do
  use ExUnit.Case
  doctest IterativeRotationCipher

  describe "IterativeRotationCipher.encode/2" do
    test "returns the correct value for the given example" do
      plain = "If you wish to make an apple pie from scratch, you must first invent the universe."

      cipher =
        "10 hu fmo a,ys vi utie mr snehn rni tvte .ysushou teI fwea pmapi apfrok rei tnocsclet"

      assert IterativeRotationCipher.encode(10, plain) == cipher
    end
  end

  describe "IterativeRotationCipher.decode/1" do
    test "returns the correct value for the given example" do
      plain = "If you wish to make an apple pie from scratch, you must first invent the universe."

      cipher =
        "10 hu fmo a,ys vi utie mr snehn rni tvte .ysushou teI fwea pmapi apfrok rei tnocsclet"

      assert IterativeRotationCipher.decode(cipher) == plain
    end
  end

  describe "IterativeRotationCipher.shift_right_preserving_spaces/2" do
    test "shifts characters the specified number of positions to the right, leaving spaces in place" do
      assert IterativeRotationCipher.shift_right_preserving_spaces("foo   bar", 4) ==
               "oba   rfo"
    end

    test "cycles repeatedly if n is larger than the length of the de-spaced string" do
      assert IterativeRotationCipher.shift_right_preserving_spaces("foo   bar", 10) ==
               "oba   rfo"
    end

    test "leaves leading and trailing spaces untouched" do
      assert IterativeRotationCipher.shift_right_preserving_spaces(" foo   bar  ", 4) ==
               " oba   rfo  "
    end
  end

  describe "IterativeRotationCipher.shift_character_groups_right/2" do
    test "shifts characters within each space-separated group, leaving spaces in place" do
      assert IterativeRotationCipher.shift_character_groups_right(" fo   bar bazzzz  ", 2) ==
               " fo   arb zzbazz  "
    end

    test "cycles repeatedly if n is larger than the length of the group" do
      assert IterativeRotationCipher.shift_character_groups_right("foobar baz", 10) ==
               "obarfo zba"
    end
  end

  describe "IterativeRotationCipher.shift_left_preserving_spaces/2" do
    test "shifts characters the specified number of positions to the left, leaving spaces in place" do
      assert IterativeRotationCipher.shift_left_preserving_spaces("oba   rfo", 4) ==
               "foo   bar"
    end

    test "cycles repeatedly if n is larger than the length of the de-spaced string" do
      assert IterativeRotationCipher.shift_left_preserving_spaces("oba   rfo", 10) ==
               "foo   bar"
    end

    test "leaves leading and trailing spaces untouched" do
      assert IterativeRotationCipher.shift_left_preserving_spaces(" oba   rfo  ", 4) ==
               " foo   bar  "
    end
  end

  describe "IterativeRotationCipher.shift_character_groups_left/2" do
    test "shifts characters within each space-separated group, leaving spaces in place" do
      assert IterativeRotationCipher.shift_character_groups_left(" fo   arb zzbazz  ", 2) ==
               " fo   bar bazzzz  "
    end

    test "cycles repeatedly if n is larger than the length of the group" do
      assert IterativeRotationCipher.shift_character_groups_left("obarfo zba", 10) ==
               "foobar baz"
    end
  end
end
