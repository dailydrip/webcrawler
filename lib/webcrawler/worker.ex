defmodule Webcrawler.Worker do
  use GenStage
  alias Webcrawler.{Results, Queue}

  def start_link() do
    GenStage.start_link(__MODULE__, [])
  end

  # Server

  def init([]) do
    {:consumer, :the_state_does_not_matter}
  end

  def handle_events(events, _from, state) do
    transformations =
      %{
        length: fn(r) ->
          r.body |> String.length
        end
      }

    # Run the transformations
    for url <- events do
      unless Results.set_within_timeout?(url) do
        {response, transformed} = Webcrawler.get_and_transform(url, transformations)
        Results.set(url, transformed)
        # Add new URLs to the queue
        for link <- response.links do
          unless Results.set_within_timeout?(link) do
            Queue.push(link)
          end
        end
      end
    end

    {:noreply, [], state}
  end
end
