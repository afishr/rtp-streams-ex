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

  defp getScore(words) do
    words
    |> Enum.reduce(0, fn word, acc -> Sentiments.Words.getWordValue(word) + acc end)
    |> Kernel./(length(words))
  end

  def getWords(tweet) do
    symbols = [",", ".", ":", "?", "!"]

    tweet["message"]["tweet"]["text"]
    |> String.replace(symbols, "")
    |> String.split(" ", trim: true)
  end

  defp computeScore(tweet) do
    if tweet == "{\"message\": panic}" do
      IO.inspect(tweet)
    else
      {:ok, tweet} = Poison.decode(tweet)

      score =
        tweet
        |> getWords()
        |> getScore()

      IO.puts("Tweet score: " <> Float.to_string(score))
    end
  end

  @impl true
  def handle_cast({:compute, tweet}, _) do
    computeScore(tweet)
    {:noreply, tweet}
  end
end
