defmodule ToothmathTest do
  use ExUnit.Case
  doctest Toothmath

  test "greets the world" do
    assert Toothmath.hello() == :world
  end
end
