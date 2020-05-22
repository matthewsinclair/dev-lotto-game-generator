# defmodule Lotto.CLI do
#   def main(_args) do
#     IO.puts("Lotto Number Generator (ver: #{Mix.Project.config[:version]})")
#   end
# end


defmodule Lotto.CLI do
  @moduledoc """
  Lotto Number Generator (ver: #{Mix.Project.config[:version]})

  synopsis:
  Generate Lotto numbers from frequency tables
  usage:
  $ lotto {options} datafile
  options:
  --least       Use least frequently selected numbers (defaults to true)
  --most        Use most frequently selected numbers (defaults to false)
  --select=S    Number of Lotto numbers to select (defaults to 6)
  --count=C     Number of frequency numbers to draw from (defaults to 8)
  where:
  datafile      Comma-separated CSV file of the form:

  # datafile.csv
  number, frequency
  1, 345
  2, 340
  ...
  """

  def main(), do: main([])
  def main(args) do
    args |> parse |> process
  end

  @option_parser_switches [select: :integer, count: :integer, most: :boolean, least: :boolean]
  defp parse(args) do
    options  = %{select: 6, count: 8, most: false, least: true}
    switches = @option_parser_switches
    aliases  = [h: :help, m: :most, l: :least, s: :select, c: :count]
    parse    = OptionParser.parse(args, switches: switches, aliases: aliases)

    case parse do
      { [help: true], _, _   } -> :help
      { [], args, []         } -> { options, args }
      { opts, args, []       } -> { Enum.into(opts, options), args }
      { opts, args, bad_opts } -> {
        Enum.into(merge_opts(opts, bad_opts), options), args
      }
      _ -> {:help, args}
    end
  end

  defp merge_opts(opts, bad_opts) do
    bad_opts |> rehabilitate_args |> Keyword.merge(opts)
  end
  defp rehabilitate_args(bad_args) do
    bad_args
    |> Enum.flat_map(fn x -> Tuple.to_list(x) end)
    |> Enum.filter(fn str -> str end)
    |> Enum.map(fn str -> String.replace(str, ~r/^\-([^-]+)/, "--\\1") end)
    |> OptionParser.parse(switches: @option_parser_switches)
    |> Tuple.to_list
    |> List.first 
  end


  defp process(:help) do
    IO.puts(@moduledoc)
  end 
  # defp process({:help, bad_args}) do
  #   IO.puts("error: unknown option(s): #{bad_args}")
  #   IO.puts(@moduledoc)
  # end
  defp process({options, args}) do
    [ options, args ]
  end
end
