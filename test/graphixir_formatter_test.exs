defmodule GraphixirTest.Formatter do
  require Graphixir.Formatter

  def act(val, timestamp \\ "") do
    Graphixir.Formatter.format(val, timestamp)
  end
end

defmodule GraphixirTest.Formatter.IncrementingCountersShould do
  import GraphixirTest.Formatter
  use ExUnit.Case, async: true

  test "formats a single counter" do
    val = %{"counts": [dogs: 1]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.dogs\.count 1/, formatted)
  end

  test "formats multiable counters" do
    val =  %{counts: [dogs: 1, cats: 2]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.dogs\.count 1/,formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.cats\.count 2/,formatted)
  end
end

defmodule GraphixirTest.Formatter.SettingGaugeShould do

  import GraphixirTest.Formatter
  use ExUnit.Case, async: true

  test "formats a single gauge" do
    val = %{gauges: [speed: 40]}

    formatted = act(val)
    assert Regex.match?(~r/graphixir\.local\.localhost\.gauges\.speed 40/, formatted)
  end

  test "formats a multiple gauge" do
    val = %{gauges: [speed: 40, visitors: 5]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.gauges\.speed 40/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.gauges\.visitors 5/, formatted)
  end
end

defmodule GraphixirTest.Formatter.SettingsSetShould do
  import GraphixirTest.Formatter
  use ExUnit.Case, async: true

  test "formats a single set" do
    val = %{sets: [users: [1,3]]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.sets\.users\.count 2/, formatted)
  end

  test "formats a multiple sets" do

    val = %{sets: [users: [5,6], admins: [1,3,5]]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.sets\.users\.count 2/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.sets\.admins\.count 3/, formatted)
  end
end

defmodule GraphixirTest.Formatter.SettingsTimerShould do
  import GraphixirTest.Formatter
  use ExUnit.Case, async: true

  test "formats a timer" do
    val = %{timers: [page_load: [data: [1,3], average: 2, lower: 1, upper: 3, sum: 4, standard_deviation: 1.0]]}

    formatted = act(val)

    assert Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.average 2/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.lower 1/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.upper 3/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.sum 4/, formatted)
    assert Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.standard_deviation 1.0/, formatted)
    refute Regex.match?(~r/graphixir\.local\.localhost\.timers\.page_load\.data/, formatted)
  end
end

defmodule GraphixirTest.Formatter.SettingTimestampShould do
  import GraphixirTest.Formatter
  use ExUnit.Case, async: true

  test "inserts a timestamp into the formatted lines" do
    val = %{counts: [dogs: 1]}

    formatted = act(val, 100)

    assert Regex.match?(~r/ 100\n/, formatted)
  end
end
