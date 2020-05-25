defmodule Lotto.Frequencies do
  @moduledoc """
  Takes a list of [number, frequency] pairs from a CSV file (or other
  text stream) and then generates game combinations of the most or
  least frequently appearing numbers in the list. 
  """

  # See: https://www.lottery.co.uk/lotto/statistics
  # @freq_file_name "../../data/frequencies_bad_data.csv"
  @freq_file_name "../../data/frequencies_201510-202005.csv"

  @doc """
  Takes the name of a file made up of lines of the form "number, frequency" and
  reads the file line by line to return a list of [number,frequency] tuples.

  ## Examples

      ### data/freqs.csv
      # 1, 300
      # 2, 302
      # 3, 259
      # ...
      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Enum.to_list
      [
        [1, 275],
        [2, 290],
        [3, 295],
        [4, 298],
        [5, 293],
        [6, 299],
        [7, 350],
        [8, 190]
      ]
  """
  def data_from_filename(filename \\ @freq_file_name) do
    filename
    |> Path.expand(File.cwd!)
    |> File.stream!
    |> data_from_stream
  end
  defp data_from_stream(stream) do
    stream 
    |> CSV.decode(strip_fields: true, headers: false)
    |> Stream.map(fn x ->
      case x do
        {:ok, [numb, freq] } -> slurp(numb, freq)
        {_, _}               -> [NaN, NaN]
      end
     end)
    |> Stream.filter(fn [n,f] -> is_number(n) and is_number(f)  end)
  end
  defp slurp(n, f) do
    case {n |> String.trim |> Integer.parse, f |> String.trim |> Integer.parse} do
      { {numb, ""}, {freq, ""} } -> [numb, freq]
      { _, _}                    -> [NaN, NaN]
    end 
   end


  @doc """
  Takes a frequency stream of [numb,freq] tuples and puts them onto IO in
  the form form "numb: freq".
  """
  def dump(stream, io \\ :stdio) do
    stream
    |> Enum.map(fn [numb, freq] -> IO.puts(io, "#{numb}: #{freq}") end)
    :ok
  end

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a list.

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.to_list
      [[1, 275], [2, 290], [3, 295], [4, 298], [5, 293], [6, 299], [7, 350], [8, 190]]
  """
  def to_list(stream) do
    stream
    |> Enum.to_list
  end 

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a map of numb => freq.

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.to_map
      %{
        1 => 275,
        2 => 290,
        3 => 295,
        4 => 298,
        5 => 293,
        6 => 299,
        7 => 350,
        8 => 190
      }
  """
  def to_map(stream) do
    stream
    |> Stream.map(fn [n,f] -> %{ n => f} end)
    |> Enum.reduce(fn x, y -> Map.merge(x, y) end)
  end 


  defp frequent_cmprtr(a, b),   do: Enum.at(a,1) >= Enum.at(b,1)
  defp infrequent_cmprtr(a, b), do: Enum.at(a,1) <= Enum.at(b,1)

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a list of the nth most frequent numbers with counts from
  the frequencies sorted in descending order of frequency.

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.frequent_list_with_counts(6)
      [[7, 350], [6, 299], [4, 298], [3, 295], [5, 293], [2, 290]]
  """
  def frequent_list_with_counts(stream, n \\ 6) do
    frequent_list_with_counts(stream, n, &frequent_cmprtr/2)
  end

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a list of the nth least frequent numbers with counts from
  the frequencies sorted in ascending order of frequency.

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.infrequent_list_with_counts(6)
      [[8, 190], [1, 275], [2, 290], [5, 293], [3, 295], [4, 298]]
  """
  def infrequent_list_with_counts(stream, n \\ 6) do
    frequent_list_with_counts(stream, n, &infrequent_cmprtr/2)
  end

  defp frequent_list_with_counts(stream, n, cmprtr) do
    stream
    |> Enum.sort(cmprtr)
    |> Enum.take(n)
  end

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a list of the nth most frequent numbers from the frequencies
  sorted in ascending number order. 

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.frequent_list
      [2, 3, 4, 5, 6, 7]
  """
  def frequent_list(stream, n \\ 6) do
    frequent_list(stream, n, &frequent_cmprtr/2)
  end

  @doc """
  Takes a frequency stream of [numb,freq] tuples and converts them
  into a list of the nth least frequent numbers from the frequencies
  sorted in ascending number order.

  ## Examples

      iex> Lotto.Frequencies.data_from_filename("test/data/test_freqs.csv") |> Lotto.Frequencies.infrequent_list
      [1, 2, 3, 4, 5, 8]
  """
  def infrequent_list(stream, n \\ 6) do
    frequent_list(stream, n, &infrequent_cmprtr/2)
  end

  defp frequent_list(stream, n, cmprtr) do
    stream 
    |> Enum.sort(cmprtr)
    |> Enum.take(n)
    |> Enum.map(fn x -> Enum.at(x,0) end)
    |> Enum.sort
  end

 end
