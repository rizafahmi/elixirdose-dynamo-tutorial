defmodule HelloDynamo do
  use Application.Behaviour
  Mongoex.Server.setup(address: 'localhost', port: 3001, database: :dynamo)
  Mongoex.Server.start

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    HelloDynamo.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
  end
end
