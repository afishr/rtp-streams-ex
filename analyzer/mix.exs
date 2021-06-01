defmodule RTP.MixProject do
  use Mix.Project

  def project do
    [
      app: :rtp,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RTP.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eventsource_ex, "~> 0.0.2"},
      {:poison, "~> 3.1"},
      # {:mongodb, "~> 0.5.1"}
    ]
  end
end
