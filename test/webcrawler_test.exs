defmodule WebcrawlerTest do
  use ExUnit.Case
  doctest Webcrawler

  test "downloads the robots file" do
    google_robots = fixture("google.com/robots.txt")
    tesla_robots = fixture("tesla.com/robots.txt")
    assert Webcrawler.get_robots_for("google.com") == google_robots
    assert Webcrawler.get_robots_for("http://google.com/foo") == google_robots
    assert Webcrawler.get_robots_for("tesla.com") == tesla_robots
  end

  test "gets a URI" do
    example_index = fixture("example.com/index.html")
    %Webcrawler.Result{body: body} = Webcrawler.get("http://example.com/index.html")
    assert body == example_index
  end

  def fixture(path) do
    File.read!("./test/fixtures/requests/#{path}")
  end
end
