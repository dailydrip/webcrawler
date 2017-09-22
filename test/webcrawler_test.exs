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

  test "runs an transformation on a request" do
    example_index = fixture("example.com/index.html")
    index_length = String.length(example_index)
    transformations =
      %{
        length: fn(r) ->
          r.body |> String.length
        end
      }
    assert {_, %{length: ^index_length}} = Webcrawler.get_and_transform("http://example.com/index.html", transformations)
  end

  test "finds links to crawl" do
    example_index = fixture("example.com/index.html")
    iana_uri = URI.parse("http://www.iana.org/domains/example")
    assert %Webcrawler.Result{links: [^iana_uri]} = Webcrawler.get("http://example.com/index.html")
  end

  test "transforms a list of URLs" do
    url = "http://www.example.com/index.html"

    urls = [
      url
    ]

    example_index = fixture("example.com/index.html")
    index_length = String.length(example_index)
    transformations =
      %{
        length: fn(r) ->
          r.body |> String.length
        end
      }

    assert [{^url, {_, %{length: ^index_length}}}] = Webcrawler.get_and_transform(urls, transformations)
  end

  def fixture(path) do
    File.read!("./test/fixtures/requests/#{path}")
  end
end
