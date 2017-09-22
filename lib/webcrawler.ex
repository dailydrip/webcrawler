defmodule Webcrawler.Result do
  defstruct body: ""
end

defmodule Webcrawler do
  require Tesla
  alias Webcrawler.Result

  def get_robots_for(uri_string) do
    response = Tesla.get(client, robots_txt(uri_string))
    response.body
  end

  def get(uri_string) do
    # TKTK Honor robots
    response = Tesla.get(client, uri_string)
    %Result{body: response.body}
  end

  def get_and_transform(uri_string, transformations) do
    response = get(uri_string)
    for {key, transformation} <- transformations, into: %{} do
      {key, transformation.(response)}
    end
  end

  defp client do
    Tesla.build_client([
      {Tesla.Middleware.FollowRedirects, [max_redirects: 3]}
    ])
  end

  defp robots_txt(uri_string) do
    result = URI.parse(uri_string)
    scheme = result.scheme || "http"
    case result.host do
      nil ->
        "#{scheme}://#{result.path}/robots.txt"
      host ->
        "#{scheme}://#{host}/robots.txt"
    end
  end
end
