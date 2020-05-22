defmodule Lotto.Frequencies do

  # @freq_file_name "../../data/frequencies_bad_data.csv"
  @freq_file_name "../../data/frequencies_201510-202005.csv"

  def data do
    data_from_filename()
  end 

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
      { {numb, ""}, {freq, ""} } ->
        [numb, freq]
      { _, _} -> [NaN, NaN]
    end 
   end


  def dump(stream) do
    stream
    |> Enum.map(fn [numb, freq] -> IO.puts "#{numb}: #{freq}" end)
    :ok
  end

  def to_list(stream) do
    stream
    |> Enum.to_list
  end 

  def to_map(stream) do
    stream
    |> Stream.map(fn [n,f] -> %{ n => f} end)
    |> Enum.reduce(fn x, y -> Map.merge(x, y) end)
  end 


  # @frequent_cmprtr   (fn (a, b) -> Enum.at(a,1) >= Enum.at(b,1) end)
  # @infrequent_cmprtr (fn (a, b) -> Enum.at(a,1) <= Enum.at(b,1) end)

  defp frequent_cmprtr(a, b),   do: Enum.at(a,1) >= Enum.at(b,1)
  defp infrequent_cmprtr(a, b), do: Enum.at(a,1) <= Enum.at(b,1)


  def frequent_list_with_counts(stream, n \\ 6) do
    frequent_list_with_counts(stream, n, &frequent_cmprtr/2)
  end

  def infrequent_list_with_counts(stream, n \\ 6) do
    frequent_list_with_counts(stream, n, &infrequent_cmprtr/2)
  end

  defp frequent_list_with_counts(stream, n, cmprtr) do
    stream
    |> Enum.sort(cmprtr)
    |> Enum.take(n)
  end


  def frequent_list(stream, n \\ 6) do
    frequent_list(stream, n, &frequent_cmprtr/2)
  end

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
