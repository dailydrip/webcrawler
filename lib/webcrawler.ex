defmodule Webcrawler do
  require Tesla

  def get_robots_for(host) do
    response = Tesla.get(client, "http://google.com/robots.txt")
    response.body
  end

  def client do
    Tesla.build_client([
      {Tesla.Middleware.FollowRedirects, [max_redirects: 3]}
    ])
  end
end
