defmodule MessagePassTest do
  use ExUnit.Case
  doctest MessagePass

  test "greets the world" do
    assert MessagePass.hello() == :world
  end
end
