defmodule WebcrawlerTest do
  use ExUnit.Case
  doctest Webcrawler

  test "downloads the robots file" do
    google_robots = File.read!("./test/fixtures/robots/google.com/robots.txt")
    tesla_robots = File.read!("./test/fixtures/robots/tesla.com/robots.txt")
    assert Webcrawler.get_robots_for("google.com") == google_robots
    assert Webcrawler.get_robots_for("http://google.com/foo") == google_robots
    assert Webcrawler.get_robots_for("tesla.com") == tesla_robots
  end
end
