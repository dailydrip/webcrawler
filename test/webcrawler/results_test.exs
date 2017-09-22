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
end
