defmodule Sentiments.Analyzer do
  use GenServer

  def start(index) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, index})
  end

  def compute(tweet) do
    GenServer.cast(__MODULE__, {:compute, tweet})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  defp get_score(words) do
    words
    |> Enum.reduce(0, fn word, acc -> Sentiments.Words.getWordValue(word) + acc end)
    |> Kernel./(length(words))
  end

  def get_words(tweet) do
    symbols = [",", ".", ":", "?", "!"]

    tweet["text"]
    |> String.replace(symbols, "")
    |> String.split(" ", trim: true)
  end

  defp compute_score(tweet) do
    score =
      tweet
      |> get_words()
      |> get_score()

    IO.puts("Tweet score: " <> Float.to_string(score))
  end

  @impl true
  def handle_cast({:compute, tweet}, _) do
    compute_score(tweet)
    {:noreply, tweet}
  end
end
