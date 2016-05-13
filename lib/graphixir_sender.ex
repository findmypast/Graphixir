defmodule Graphixir.Sender do
  require Graphixir.Formatter
  require Graphixir.App

  def send(state) do
      payload = Graphixir.Formatter.format(state, :os.system_time(:seconds))
      create_and_send_packets(payload)
  end

  defp create_and_send_packets(payload) do

    ip_address = Graphixir.App.get_env_var(:graphite_ip_address)
    port = Graphixir.App.get_env_var(:graphite_port)
    {:ok, socket} = :gen_tcp.connect(ip_address, port, [:binary, {:packet, 0}])

    :gen_tcp.send(socket, payload)
  end
end
