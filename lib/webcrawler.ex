defmodule Webcrawler do
  require Tesla
  alias Webcrawler.Result
  @url_regex ~r(https?://[^ $\n]*)

  def get_robots_for(uri_string) do
    response = Tesla.get(client, robots_txt(uri_string))
    response.body
  end

  def get(uri_string) when is_binary(uri_string) do
    # TKTK Honor robots
    response = Tesla.get(client, uri_string)
    uris = get_urls_from_document(response.body)
    %Result{body: response.body, links: uris}
  end

  def get_and_transform(uri_string, transformations) when is_binary(uri_string) do
    response = get(uri_string)
    for {key, transformation} <- transformations, into: %{} do
      {key, transformation.(response)}
    end
  end
  def get_and_transform(uri_strings, transformations) when is_list(uri_strings) do
    for uri_string <- uri_strings do
      {uri_string, get_and_transform(uri_string, transformations)}
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

  def get_urls_from_document(body) do
    body
    |> Floki.find("a[href]")
    |> Floki.attribute("href")
  end
end
