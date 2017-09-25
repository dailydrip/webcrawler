defmodule Webcrawler.ResultsTest do
  use ExUnit.Case
  alias Webcrawler.Results

  test "setting a value" do
    Results.set(:foo, :bar)
    assert :bar = Results.get(:foo)
  end

  test "list values" do
    Results.set(:foo, :bar)
    assert %{foo: :bar} = Results.list()
  end

  test "find out if a key was set within a specific time" do
    refute Results.set_within_timeout?(:foo123)
    Results.set(:foo123, :bar)
    assert Results.set_within_timeout?(:foo123)
  end
end
