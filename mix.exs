defmodule PDF.MixProject do
  use Mix.Project

  def project do
    [
      app: :pdf,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :erlazure],
      mod: {PDF.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:porcelain, "~> 2.0"},
      {:erlazure, github: "dkataskin/erlazure"},
      {:temp, "~> 0.4.5"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
