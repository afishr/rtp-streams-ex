defmodule Registry do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def add_subscriber(topic, subscriber) do
    GenServer.cast(__MODULE__, {:add, topic, subscriber})
  end

  def get_all() do
    GenServer.cast(__MODULE__, {:get_all})
  end

  def get_by_topic(topic) do
    GenServer.call(__MODULE__, {:get_by_topic, topic})
  end

  @impl true
  def handle_cast({:add, topic, subscriber}, state) do
    {:noreply, [%{topic: topic, subscriber: subscriber} | state]}
  end

  @impl true
  def handle_cast({:get_all}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call({:get_by_topic, topic}, _from, state) do
    {:reply, Enum.filter(state, fn map -> map.topic == topic end), state}
  end
end
