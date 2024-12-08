defmodule Toothmath.FractionTest do
  use ExUnit.Case
  doctest Toothmath.Fraction
  alias Toothmath.Fraction

  test "imperial measurements from real numbers" do
    assert Fraction.from_value(0.6875) == %Fraction{a: 11, b: 16}
  end
end
