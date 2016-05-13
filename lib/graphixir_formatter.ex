defmodule Graphixir.Formatter do
  require Graphixir.App

  def format(state, timestamp \\ "") do

    namespace = Graphixir.App.get_env_var(:namespace)
    environment = Graphixir.App.get_env_var(:graphite_environment)
    hostname = Graphixir.App.get_env_var(:machine_name)

    msg = ""

    msg = format_counts(namespace,environment,hostname, Map.get(state, :counts, []), msg, timestamp)
    msg = format_gauges(namespace,environment,hostname, Map.get(state, :gauges, []), msg, timestamp)
    msg = format_sets(namespace,environment,hostname, Map.get(state, :sets, []),   msg, timestamp)
    msg = format_timers(namespace,environment,hostname, Map.get(state, :timers, []), msg, timestamp)

    msg
  end

  defp format_counts(namespace,environment,hostname, counts, msg, timestamp) do
    Enum.reduce counts, msg, fn({key, value}, acc) ->
     acc <> graphite_data_point(namespace,environment,hostname, "#{key}.count", value, timestamp)
    end
  end

 defp format_gauges(namespace,environment,hostname, gauges, msg, timestamp) do
   Enum.reduce gauges, msg, fn({key, value}, acc) ->
     acc <> graphite_data_point(namespace,environment,hostname, "gauges.#{key}", value, timestamp)
   end
 end

 defp format_sets(namespace,environment,hostname, sets, msg, timestamp) do
   Enum.reduce sets, msg, fn({key, set}, acc) ->
     acc <> graphite_data_point(namespace,environment,hostname, "sets.#{key}.count", length(set), timestamp)
   end
 end

 defp format_timers(namespace,environment,hostname, timers, msg, timestamp) do
   Enum.reduce timers, msg, fn({key, timer}, acc) ->
     key = "timers.#{key}"
     acc = acc <> graphite_data_point(namespace,environment,hostname, "#{key}.average", timer[:average], timestamp)
     acc = acc <> graphite_data_point(namespace,environment,hostname, "#{key}.lower",   timer[:lower],   timestamp)
     acc = acc <> graphite_data_point(namespace,environment,hostname, "#{key}.upper",   timer[:upper],   timestamp)
     acc = acc <> graphite_data_point(namespace,environment,hostname, "#{key}.sum",     timer[:sum],     timestamp)

     acc <> graphite_data_point(namespace,environment,hostname,
            "#{key}.standard_deviation", timer[:standard_deviation], timestamp)
   end
 end

 defp graphite_data_point(namespace,environment,hostname, key, value, timestamp) do
   "#{namespace}.#{environment}.#{hostname}.#{key} #{value} #{timestamp}\n"
 end
end
