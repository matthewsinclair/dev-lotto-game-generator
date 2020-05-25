defmodule CombosTest do
  use ExUnit.Case
  doctest Lotto.Combos

  test "generate combos" do
    assert [[]] == Lotto.Combos.combo(nil, 0)
    assert [[]] == Lotto.Combos.combo([],  0)
    assert [[1], [2], [3]] == Lotto.Combos.combo([1,2,3], 1)
    assert [[1,2], [1,3], [2,3]] == Lotto.Combos.combo([1,2,3], 2)
    assert [[1,2,3]] == Lotto.Combos.combo([1,2,3], 3)
  end
end
