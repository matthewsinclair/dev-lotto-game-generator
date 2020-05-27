defmodule Lotto.Scraper do
  @moduledoc """
  Extracts a map in the form `%{number => frequency, ...}` from a URL known to
  contain frequencies for lotto balls.
  """

  @doc """
  Scrape a map of %{number => frequency} from the default URL defined at @Lotto.Spider.scrape_url.
  """
  def scrape_frequencies_from(nil) do
    scrape_frequencies_from(Lotto.Spider.scrape_url)
  end

  @doc """
  Scrape a map of %{number => frequency} from URL, defaulting to @Lotto.Spider.scrape_url.
  """
  def scrape_frequencies_from(url) do
    url  = if (url == ""), do: Lotto.Spider.scrape_url, else: url
    resp = Crawly.fetch(url)
    case Floki.parse_document(resp.body) do
      {:ok, doc}       -> extract_numbs_and_freqs_from(doc)
      {:error, reason} -> {:error, reason}
      _                -> {:error, :uknown}
    end
  end

  # Extracts the first count balls from the provided (parsed) web doc.
  # Note: this is really, really fragile as it assumes specific HTML
  # tags/classes from the lottery.co.uk web site.
  @number_of_lotto_balls_drawn 59
  defp extract_numbs_and_freqs_from(doc, count \\ @number_of_lotto_balls_drawn) do
    numbs = doc
    |> Floki.find("div.result.medium.lotto-ball")
    |> Floki.text(sep: ",")
    |> String.split(",")
    |> Enum.take(count)

    freqs = doc
    |> Floki.find("span.tk")
    |> Floki.text(sep: ",")
    |> String.split(",")
    |> Enum.take(count)

    _freqmap = Enum.zip(numbs, freqs)
    |> Enum.into(%{})
    |> Map.new(fn {k,v} -> {String.to_integer(k), String.to_integer(v)} end)
  end

  @doc """
  Dump a number frequency map in the form `%{number => frequency, ...}` onto the
  provided stream in the form of a CSV file.
  """
  def dump_csv(freqmap, header \\ true, stream \\ IO) do
    if header, do: stream.puts "number, frequency"
    freqmap
    |> Enum.sort()
    |> Enum.each(fn {numb,freq} -> stream.puts "#{numb}, #{freq}" end)
    :ok
   end
end
