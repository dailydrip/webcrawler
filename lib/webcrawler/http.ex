defmodule Webcrawler.Http do
  require Logger
  require Tesla

  @url_regex ~r(https?://[^ $\n]*)

  alias Webcrawler.{
    Result,
    Queue,
    Http
  }

  def get_robots_for(uri_string) do
    response = Tesla.get(client, robots_txt(uri_string))
    response.body
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

  defp get_uris_from_document(body, base_uri) do
    uris =
      body
      |> Floki.find("a[href]")
      |> Floki.attribute("href")
      |> Enum.map(&URI.parse/1)

    {uris, URI.parse(base_uri)}
  end

  def get(uri_string) when is_binary(uri_string) do
    # TKTK Honor robots
    response = Tesla.get(client, uri_string)
    {uris, base_uri} = get_uris_from_document(response.body, uri_string)
    uris =
      uris
      |> Enum.map(fn uri -> Map.merge(uri, base_uri, fn _k, v1, v2 -> v1 || v2 end) end)

    %Result{body: response.body, links: uris}
  end
  # Assuming this is a %URI{}
  def get(uri) do
    get(URI.to_string(uri))
  end

  def get_and_transform(uri_string, transformations) when is_binary(uri_string) do
    Logger.info fn ->
      "Getting #{uri_string}"
    end
    response = get(uri_string)
    transformed = for {key, transformation} <- transformations, into: %{} do
      {key, transformation.(response)}
    end
    {response, transformed}
  end
  def get_and_transform(uri_strings, transformations) when is_list(uri_strings) do
    for uri_string <- uri_strings do
      {uri_string, get_and_transform(uri_string, transformations)}
    end
  end
  # Assuming this is a %URI{}
  def get_and_transform(uri, transformations) do
    get_and_transform(URI.to_string(uri), transformations)
  end

  defp client do
    Tesla.build_client([
      {Tesla.Middleware.FollowRedirects, [max_redirects: 3]}
    ])
  end

end
