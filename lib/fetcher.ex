defmodule Fetcher do
  def fetch() do
    receive do
      tweet ->
        Router.route(tweet)
        fetch()
    end
  end

  def init(url) do
    EventsourceEx.new(url, stream_to: self())
    fetch()
  end
end
