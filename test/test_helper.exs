Dynamo.under_test(HelloDynamo.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule HelloDynamo.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
