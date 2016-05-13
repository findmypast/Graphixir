defmodule Graphixir.App do

  def get_env_var(var) do
    {:ok, value} = :application.get_env(:graphixir, var)
    value
  end
end
