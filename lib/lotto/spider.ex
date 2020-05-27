defmodule Lotto.Spider do
  use Crawly.Spider

  @base_url   "https://www.lottery.co.uk"
  @scrape_url "https://www.lottery.co.uk/lotto/statistics"

  @impl Crawly.Spider
  def base_url(),   do: @base_url
  def scrape_url(), do: @scrape_url 

  @impl Crawly.Spider
  def init(), do: [start_urls: [ @scrape_url ]]

  @impl Crawly.Spider
  def parse_item(_response) do
    %Crawly.ParsedItem{:items => [], :requests => []}
  end
end
