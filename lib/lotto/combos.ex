defmodule Lotto.Combos do

  # def combo(0, _), do: [[]]
  # def combo(_, []), do: []
  # def combo(size, [head | tail]) do
  #   (for elem <- combo(size-1, tail), do: [head|elem]) ++ combo(size, tail)
  # end

  def combo(_, 0), do: [[]]
  def combo([], _), do: []
  def combo([head | tail], size) do
    (for elem <- combo(tail, size-1), do: [head|elem]) ++ combo(tail, size)
  end

end

# use Lotto.Combos
# combos = Lotto.Combos.combo([2, 5, 10, 15, 35, 58, 7, 8], 6)
# IO.inspect combos
# IO.puts    "#{length(combos)} combos"
