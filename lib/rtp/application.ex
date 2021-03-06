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
        id: Fetcher,
        start: {Fetcher, :init, []}
      }
    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
