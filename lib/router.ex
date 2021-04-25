defmodule Router do
  use GenServer

  def start() do
    children = [
      Sentiments.Analyzer.start(0),
      Sentiments.Analyzer.start(1),
      Sentiments.Analyzer.start(2),
      Sentiments.Analyzer.start(3),
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
    {_, pid} = Enum.at(state.children, rem(state.index, length(state.children)))
    GenServer.cast(pid, {:compute, tweet})

    {:noreply, %{index: state.index + 1, children: state.children}}
  end
end
