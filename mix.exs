defmodule TruLockApi.Mixfile do
  use Mix.Project

  def project do
    [app: :tru_lock_api,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :httpoison, :tru_face],
     mod: {TruLockApi, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:poison, "~> 3.1"},
     {:httpoison, "~> 0.12"},
     {:mem, "~> 0.3.1"},
     {:tru_face, "~> 0.1.1"}]
  end
end
