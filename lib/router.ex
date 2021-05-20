defmodule Router do
  use GenServer

  def start() do
    sentiment_workers = [
      Sentiments.Analyzer.start(0),
      Sentiments.Analyzer.start(1),
      Sentiments.Analyzer.start(2),
      Sentiments.Analyzer.start(3)
    ]

    engagement_workers = [
      Engagement.Analyzer.start(4),
      Engagement.Analyzer.start(5),
      Engagement.Analyzer.start(6),
      Engagement.Analyzer.start(7)
    ]

    GenServer.start_link(
      __MODULE__,
      %{index: 0, sentiment_workers: sentiment_workers, engagement_workers: engagement_workers},
      name: __MODULE__
    )
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
      {_, sentiment_pid} =
        Enum.at(state.sentiment_workers, rem(state.index, length(state.sentiment_workers)))

      {_, engagement_pid} =
        Enum.at(state.engagement_workers, rem(state.index, length(state.engagement_workers)))

      GenServer.cast(sentiment_pid, {:compute, decoded_tweet})
      GenServer.cast(engagement_pid, {:compute, decoded_tweet})

      {:noreply,
       %{
         index: state.index + 1,
         sentiment_workers: state.sentiment_workers,
         engagement_workers: state.engagement_workers
       }}
    else
      {:noreply,
       %{
         index: state.index,
         sentiment_workers: state.sentiment_workers,
         engagement_workers: state.engagement_workers
       }}
    end
  end

  defp decode(tweet) do
    if tweet != "{\"message\": panic}" do
      {:ok, tweet} = Poison.decode(tweet)

      tweet["message"]["tweet"]
    end
  end
end
