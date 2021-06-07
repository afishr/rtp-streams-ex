defmodule Command do
  def parse(line) do
    case String.split(line, " ", parts: 3) |> Enum.map(fn string -> String.trim(string) end) do
      ["PUBLISH", topic, data] -> {:ok, {:publish, topic, data}}
      ["SUBSCRIBE", topic] -> {:ok, {:subscribe, topic}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(command, socket)

  def run({:publish, topic, data}, socket) do
    all_subscribers = Registry.get_by_topic(topic)

    Enum.each(all_subscribers, fn subscriber -> Server.write_line(subscriber.subscriber, {:for_subscriber, data}) end)
    {:ok, "OK\r\n"}
  end

  def run({:subscribe, topic}, socket) do
    Registry.add_subscriber(topic, socket)

    {:ok, "OK\r\n"}
  end
end
