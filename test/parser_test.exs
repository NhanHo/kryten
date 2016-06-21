defmodule ParserTest do
  use ExUnit.Case

  test "parsing empty file returns no exclusions" do
    file = ""
    result = Kryten.Parser.parse file
    assert length(result) == 0
  end

  test "parsing with end of line at the end" do
    file = "User-agent: *\nDisallow: /\n"

    result = Kryten.Parser.parse file
    assert result == [{"*", ["/"]}]
  end

  test "parsing disallow all for all bots" do
    file = "User-agent: *\nDisallow: /"

    result = Kryten.Parser.parse file
    assert result == [{"*", ["/"]}]
  end

  test "parsing disallow none" do
    file = "User-agent: *\nDisallow:"

    result = Kryten.Parser.parse file
    assert result == [{"*", []}]
  end

  test "parsing multiple disallows" do
    file = "User-agent: *\nDisallow: /auth/\nDisallow: /hidden.html"

    result = Kryten.Parser.parse file
    assert result == [{"*", ["/hidden.html", "/auth/"]}]
  end

  test "parsing multiple agents" do
    file = "User-agent: BadBot
Disallow: /keys/
Disallow: /secret.json

User-agent: *
Disallow: /nope/"

    result = Kryten.Parser.parse file
    assert result == [
      {"*", ["/nope/"]},
      {"BadBot", ["/secret.json", "/keys/"]}
    ]
  end
end
