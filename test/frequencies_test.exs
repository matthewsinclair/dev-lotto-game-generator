defmodule Lotto.FrequenciesTest do
  use ExUnit.Case
  doctest Lotto.Frequencies

  test "data_from_filename" do
    assert [
        [1, 275],
        [2, 290],
        [3, 295],
        [4, 298],
        [5, 293],
        [6, 299],
        [7, 350],
        [8, 190]
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Enum.to_list
  end

  test "to_list" do
    assert [
        [1, 275],
        [2, 290],
        [3, 295],
        [4, 298],
        [5, 293],
        [6, 299],
        [7, 350],
        [8, 190]
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.to_list
  end

  test "to_map" do
    assert %{
        1 => 275,
        2 => 290,
        3 => 295,
        4 => 298,
        5 => 293,
        6 => 299,
        7 => 350,
        8 => 190
    } = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.to_map
  end

  test "frequent_list_with_counts" do
    assert [
      [7, 350], [6, 299], [4, 298], [3, 295], [5, 293], [2, 290]
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.frequent_list_with_counts(6)
  end

  test "infrequent_list_with_counts" do
    assert [
      [8, 190], [1, 275], [2, 290], [5, 293], [3, 295], [4, 298]
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.infrequent_list_with_counts(6)
  end

  test "frequent_list" do
    assert [
      2, 3, 4, 5, 6, 7
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.frequent_list
  end

  test "infrequent_list" do
    assert [
      1, 2, 3, 4, 5, 8
    ] = Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv")
    |> Lotto.Frequencies.infrequent_list
  end
end
