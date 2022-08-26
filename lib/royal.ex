defmodule Royal do
  use Agent

  def run(command) do
    command
    |> String.split()
    |> parse()
  end

  defp parse(["GET", var]) do
    get(var)
  end

  defp parse(["PUT", var, val]) do
    case Integer.parse(val) do
      {result, ""} ->
        put(var, result)

      _ ->
        {:error, "only integers are accepted"}
    end
  end

  defp parse(["DEL", var]) do
    del(var)
  end

  defp parse(["SUM"]) do
    Agent.get(:kv, fn state -> state end)
    |> Map.values()
    |> Enum.sum()

  end

  defp parse(["MIN"]) do
    Agent.get(:kv, fn state -> state end)
    |> Map.values()
    |> Enum.min()
  end

  defp parse(["MAX"]) do
    Agent.get(:kv, fn state -> state end)
    |> Map.values()
    |> Enum.max()
  end

  defp parse(_command) do
    {:error, "cannot parse command"}
  end

  @spec start_agent :: {:error, any} | {:ok, pid}
  def start_agent() do
    Agent.start_link(fn -> %{} end, name: :kv)
  end

  def get(val) do
    Agent.get(:kv, fn state -> Map.get(state, val) end)
  end

  def put(var, val) do
    Agent.get_and_update(:kv, fn state -> {Map.get(state, var), Map.put(state, var, val)} end)
  end

  def del(var) do
    Agent.get_and_update(:kv, fn state -> {Map.get(state, var), Map.delete(state, var)} end)
  end
end


# %{
# sum: 3,
# min: ,
# max: ,
# m: %{"a" => 3},
# l: [3,4,6,7]
# }
