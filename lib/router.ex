defmodule Router do
  use GenServer

  def start() do
    children = [
      Sentiments.Analyzer.start(0),
      Sentiments.Analyzer.start(1),
      Sentiments.Analyzer.start(2),
      Sentiments.Analyzer.start(3)
    ]

    GenServer.start_link(__MODULE__, %{index: 0, children: children}, name: __MODULE__)
  end

  def route(tweet) do
    GenServer.cast(__MODULE__, {:route, tweet.data})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:route, tweet}, state) do
    decoded_tweet = decode(tweet)

    if decoded_tweet do
      {_, pid} = Enum.at(state.children, rem(state.index, length(state.children)))
      GenServer.cast(pid, {:compute, decoded_tweet})

      {:noreply, %{index: state.index + 1, children: state.children}}
    else
      {:noreply, %{index: state.index, children: state.children}}
    end
  end

  defp decode(tweet) do
    if tweet != "{\"message\": panic}" do
      {:ok, tweet} = Poison.decode(tweet)

      tweet
    end
  end
end
