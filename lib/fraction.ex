defmodule Fraction do
  @moduledoc """
  This is a hand spun math module to handle Fractions
  """

  @doc """
  A fraction

  * `:a`: the top (numerator) value
  * `:b` the bottom (denominator) value
  """
  defstruct a: nil, b: nil

  @doc """
  Create a new fraction with numerator and denominator such as 1 / 2 

  * `a` - the numerator
  * `b` - the denominator
  """
  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  @doc """
  Get the rational number

  a fractional number is always a rational number, but a rational number may or may not be a fractional number

  ## Examples

    ```
    iex> Fraction.value(%Fraction{a: 1, b: 2})
    0.50
    ```


  """
  def value(%Fraction{a: a, b: b}) do
    a / b
  end

  @doc """
    Add 2 fractions together in simplified form

  ## Examples

  ```
  iex> Fraction.add(%Fraction{a: 1, b: 2}, %Fraction{a: 1, b: 4})
  %Fraction{a: 3, b: 4}
  ```

  """
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(
      a1 * b2 + a2 * b1,
      b2 * b1
    )
    |> simplify()
  end

  @doc """
  Simply a fraction using the greatest common divisor using the Euclidean algorithm

  ```
  iex> Fraction.simplify(%Fraction{a: 2, b: 4})
  %Fraction{a: 1, b: 2}
  ```
  """
  def simplify(%Fraction{a: a, b: b}) do
    gcd = gcd(a, b)
    new(div(a, gcd), div(b, gcd))
  end

  @doc ~S"""
  Approximates the given `x` float value into a fraction

  ## Examples

    iex> Fraction.from_value(0.6875)
    %Fraction{a: 11, b: 16}
    
  """
  def from_value(x, max_denominator \\ 100) do
    # Try to find the most accurate fraction
    find_best_fraction = fn ->
      Enum.find_value(1..max_denominator, fn denominator ->
        # Try different numerators
        numerator = round(x * denominator)

        # Check if this fraction is close to the original value
        fraction_value = numerator / denominator

        if abs(fraction_value - x) < 1.0e-10 do
          {numerator, denominator}
        else
          nil
        end
      end)
    end

    case find_best_fraction.() do
      {a, b} ->
        new(a, b) |> simplify()

      nil ->
        # Fallback to the previous approximation method
        do_from_value(x, max_denominator)
    end
  end

  # Fallback approximation method (previous implementation)
  defp do_from_value(x, max_denominator) do
    mediant = fn {a1, b1}, {a2, b2} -> {a1 + a2, b1 + b2} end

    {lower_a, lower_b} = {0, 1}
    {upper_a, upper_b} = {1, 0}

    do_approximate = fn
      _, _, {a, b}, _ when abs(a / b - x) < 1.0e-10 ->
        new(a, b)

      _, max_denom, {lower_a, lower_b}, {upper_a, upper_b} when lower_b + upper_b > max_denom ->
        {a, b} =
          if abs(lower_a / lower_b - x) < abs(upper_a / upper_b - x),
            do: {lower_a, lower_b},
            else: {upper_a, upper_b}

        new(a, b)

      f, _max_denom, lower, upper ->
        {mediant_a, mediant_b} = f.(lower, upper)

        cond do
          mediant_a / mediant_b > x ->
            f.(lower, {mediant_a, mediant_b})

          true ->
            f.({mediant_a, mediant_b}, upper)
        end
    end

    do_approximate.(mediant, max_denominator, {lower_a, lower_b}, {upper_a, upper_b})
  end

  # https://en.wikipedia.org/wiki/Greatest_common_divisor
  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
