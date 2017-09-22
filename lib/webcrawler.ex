defmodule Webcrawler do
  require Tesla

  def get_robots_for(uri_string) do
    response = Tesla.get(client, robots_txt(uri_string))
    response.body
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
