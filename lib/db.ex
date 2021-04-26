defmodule DB do
  use GenServer

  def start() do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27013", database: "rtp")

    GenServer.start_link(__MODULE__, %{connection: conn}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def save_one(tweet, user) do
    GenServer.cast(__MODULE__, {:save_one, tweet, user})
  end

  @impl true
  def handle_cast({:save_one, tweet, user}, state) do
    Mongo.insert_one(state.connection, "tweets", tweet)
    Mongo.insert_one(state.connection, "users", user)

    IO.inspect(tweet)
    IO.inspect(user)

    {:noreply, state}
  end
end
