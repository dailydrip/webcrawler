defmodule Webcrawler.Worker do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, [])
  end

  # Server

  def init([]) do
    {:consumer, :the_state_does_not_matter}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events)

    {:noreply, [], state}
  end
end
