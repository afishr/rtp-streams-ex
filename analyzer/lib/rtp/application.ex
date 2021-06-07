defmodule RTP.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Router,
        start: {Router, :start, []}
      },
      %{
        id: Aggregator,
        start: {Aggregator, :start, []}
      },
      # %{
      #   id: DB,
      #   start: {DB, :start, []}
      # },
      %{
        id: Fetcher1,
        start: {Fetcher, :init, ["server:4000/tweets/1"]}
      },
      %{
        id: Fetcher2,
        start: {Fetcher, :init, ["server:4000/tweets/2"]}
      }
    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
