defmodule Kryten.Parser do

  def parse(""), do: []
  def parse(file) do
    file
    |> String.split("\n")
    |> parse_lines
		|> (Enum.filter fn item -> (item !== nil) end)
  end

  defp parse_lines(lines), do: _parse_lines(lines, nil, [])

  defp _parse_lines([], current_agent, output), do: [current_agent|output]
  defp _parse_lines([""|t], current_agent, output), do: _parse_lines(t, nil, [current_agent|output])
  defp _parse_lines([h|t], current_agent, output) do
    new_agent = h
    |> String.split(":")
    |> update_agent(current_agent)

    _parse_lines(t, new_agent, output)
  end

  defp update_agent(["User-agent", agent], _current), do: { String.strip(agent), [] }
  defp update_agent(["Disallow", ""], { current, paths }), do: { current, paths }
  defp update_agent(["Disallow", path], { current, paths }), do: { current, [String.strip(path)|paths] }

end
