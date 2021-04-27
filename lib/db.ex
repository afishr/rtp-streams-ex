defmodule DB do
  use GenServer

  def start() do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27013", database: "rtp")

    GenServer.start_link(__MODULE__, %{connection: conn, tweets: [], users: []}, name: __MODULE__)
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
    IO.inspect(tweet)
    if length(state.tweets) == 128 do
      Mongo.insert_many(state.connection, "tweets", state.tweets)
      Mongo.insert_many(state.connection, "users", state.users)

      {:noreply,
       %{
         connection: state.connection,
         tweets: [],
         users: []
       }}
    else
      {:noreply,
       %{
         connection: state.connection,
         tweets: [tweet | state.tweets],
         users: [user | state.users]
       }}
    end
  end
end
