defmodule Webcrawler.Results do
  use GenServer
  @set_timeout 60_000

  defstruct keys_with_set_time: %{}, results: %{}

  ## PUBLIC API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  def set_within_timeout?(key) do
    GenServer.call(__MODULE__, {:set_within_timeout, key})
  end

  def clear() do
    GenServer.call(__MODULE__, :clear)
  end

  ## SERVER API
  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def handle_call({:set, key, value}, _from, state) do
    new_state =
      state
      |> update_key_with_set_time(key)
      |> update_results(key, value)

    {:reply, :ok, new_state}
  end
  def handle_call({:get, key}, _from, state) do
    {:reply, state.results[key], state}
  end
  def handle_call(:list, _from, state) do
    {:reply, state.results, state}
  end
  def handle_call({:set_within_timeout, key}, _from, state) do
    current_time = Time.utc_now()
    response =
      case state.keys_with_set_time[key] do
        nil -> false
        set_time ->
          Time.diff(current_time, set_time) < @set_timeout
      end
    {:reply, response, state}
  end

  def handle_call(:clear, _from, _state) do
    {:reply, :ok, %__MODULE__{}}
  end

  ## UTILITIES
  defp update_key_with_set_time(state, key) do
    %__MODULE__{state | keys_with_set_time: Map.put(state.keys_with_set_time, key, Time.utc_now())}
  end

  defp update_results(state, key, value) do
    %__MODULE__{state | results: Map.put(state.results, key, value)}
  end

end
