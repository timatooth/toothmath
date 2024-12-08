defmodule Toothmath.MixProject do
  use Mix.Project

  def project do
    [
      app: :toothmath,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex.pm specific fields
      description: "A library to handle primary school mathematics operations",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/timatooth/toothmath"}
      ],

      # Docs
      name: "Toothmath",
      source_url: "https://github.com/timatooth/toothmath",
      homepage_url: "https://github.com/timatooth/toothmath",
      docs: &docs/0,

      # Additional configurations for Hex.pm publishing
      preferred_cli_env: [publish: :prod]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.35", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "Fraction",
      logo: "toothmath-logo.svg",
      extras: ["README.md"]
    ]
  end
end
