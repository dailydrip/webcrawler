defmodule Webcrawler do
  alias Webcrawler.{
    Result,
    Queue,
    Http
  }

  # Transformations come in at configuration time I suppose...
  def crawl(url) do
    Queue.put(url)
  end

  defdelegate get(uri_string), to: Http
  defdelegate get_robots_for(uri_string), to: Http
  defdelegate get_and_transform(uri, transformations), to: Http
end
