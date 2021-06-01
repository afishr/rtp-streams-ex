defmodule Command do
  def parse(line) do
    case String.split(line) do
      ["PUBLISH", topic, data] -> {:ok, {:publish, topic, data}}
      ["SUBSCRIBE", topic] -> {:ok, {:subscribe, topic}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(_command) do
    {:ok, "OK\r\n"}
  end
end
