defmodule Webcrawler.Queue do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def push(item) do
    GenStage.call(__MODULE__, {:push, item})
  end

  ## Server
  def init(items) do
    {:producer, items}
  end

  def handle_call({:push, item}, _from, state) do
    {:reply, :ok, [item], state}
  end

  def handle_demand(demand, state) when demand > 0 do
    items = Enum.take(state, demand)
    remaining = Enum.drop(state, demand)
    {:noreply, items, remaining}
  end
end
