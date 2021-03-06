defmodule Fetcher do
  def fetch() do
    receive do
      tweet ->
        Router.route(tweet)
        fetch()
    end
  end

  def init() do
    EventsourceEx.new("localhost:4000/tweets/1", stream_to: self())
    fetch()
  end
end
