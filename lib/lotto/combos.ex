defmodule Lotto.Combos do
  @moduledoc """
  A simple way to generate combinations of n elements of a set.
  """

  @doc """
  Generate combinations of the list using k-choose-n where k is the list and
  n is the number of elements to take from the list in combination.

  ## Examples

      iex> Lotto.Combos.combo([], 0)
      [[]]
      iex>Lotto.Combos.combo([1], 1)
      [[1]]
      iex>Lotto.Combos.combo([1, 2, 3], 1)
      [[1], [2], [3]]
      iex>Lotto.Combos.combo([1, 2, 3], 2)
      [[1, 2], [1, 3], [2, 3]]
      iex>Lotto.Combos.combo([1, 2, 3], 3)
      [[1, 2, 3]]
  """
  def combo(_, 0), do: [[]]
  def combo([], _), do: []
  def combo([head | tail], size) do
    (for elem <- combo(tail, size-1), do: [head|elem]) ++ combo(tail, size)
  end

end
