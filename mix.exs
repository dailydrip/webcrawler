defmodule Webcrawler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webcrawler,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Webcrawler.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 0.8.0"},
      {:floki, "~> 0.18.0"},
      {:gen_stage, "~> 0.12.2"},
    ]
  end
end
