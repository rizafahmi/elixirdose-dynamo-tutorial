defmodule HelloDynamo.Mixfile do
  use Mix.Project

  def project do
    [ app: :hello_dynamo,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [HelloDynamo.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { HelloDynamo, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      { :bson, github: "checkiz/elixir-bson", tag: "0.1", override: true },
      { :mongo, github: "checkiz/elixir-mongo", tag: "0.1" },
      # { :finalizer, github: "meh/elixir-finalizer", tag: "v0.0.3", override: true }
    ]
  end
end
