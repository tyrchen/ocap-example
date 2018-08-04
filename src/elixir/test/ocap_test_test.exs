defmodule OcapTestTest do
  use ExUnit.Case
  doctest OcapTest

  test "greets the world" do
    assert OcapTest.hello() == :world
  end
end
