defmodule Rtp.MixProject do
  use Mix.Project

  def project do
    [
      app: :rtp,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eventsource_ex, "~> 1.0.0"},
      {:poison, "~> 3.1"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
