defmodule RoyalTest do
  use ExUnit.Case
  doctest Royal

  test "greets the world" do
    assert Royal.hello() == :world
  end
end
