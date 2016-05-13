defmodule GraphixirTest.AppTest do
  require Graphixir.App

  def act(var) do
    Graphixir.App.get_env_var(var)
  end
end

defmodule GraphixirTest.WithValidConfigItShould do
  import GraphixirTest.AppTest

  use ExUnit.Case, async: true

  test "Return namespace of test" do

    namespace_config = act(:namespace)

    assert namespace_config == "graphixir"
  end

  test "Return server hostname" do
    hostname_config = act(:machine_name)

    assert hostname_config == "localhost"
  end
end

defmodule GraphixirTest.WithInValidConfigItShould do
  use ExUnit.Case, async: true
  import GraphixirTest.AppTest

  test "Return namespace of test" do
      f = fn -> act(:namespace1) end
      assert_raise(MatchError, "no match of right hand side value: :undefined", f)
  end
end
