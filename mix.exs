defmodule YouTuberr.MixProject do
  use Mix.Project

  def project do
    [
      app: :youtuberr,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {YouTuberr.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # dev
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:credo_single_line_functions,
       github: "Baradoy/credo_single_line_functions",
       tag: "v0.1.0",
       only: [:dev, :test],
       runtime: false},
      {:dialyxir, "~> 1.4.0", only: [:dev, :test], runtime: false},
      # eveyrthing else
      {:jason, "~> 1.4"},
      {:quantum, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      build: ["deps.get", "compile", "release --overwrite"]
    ]
  end
end
