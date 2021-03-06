defmodule RTP.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Router.start()
    Fetcher.init()

    children = [
      # Starts a worker by calling: RTP.Worker.start_link(arg)
      # {RTP.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
