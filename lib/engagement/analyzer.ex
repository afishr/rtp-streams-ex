defmodule Engagement.Analyzer do
  use GenServer

  def start(index) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, index})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  def compute(tweet) do
    GenServer.cast(__MODULE__, {:compute, tweet})
  end

  defp calculate(0, favourites, retweets) do
    (favourites + retweets) / 1
  end

  defp calculate(followers, favourites, retweets) do
    (favourites + retweets) / followers
  end

  defp compute_score(tweet) do
    followers = tweet["user"]["followers_count"]
    favourites = tweet["favorite_count"]
    retweets = tweet["retweet_count"]
    score = calculate(followers, favourites, retweets)

    score
  end

  @impl true
  def handle_cast({:compute, tweet}, _) do
    score = compute_score(tweet)

    Aggregator.add(Map.put(tweet, "engagement_score", score))

    {:noreply, tweet}
  end
end
