defmodule GuardianDb.ExpiredSweeper do
  @moduledoc """
  Periocially purges expired tokens from the DB.

  ## Example

      worker(GuardianDb.ExpiredSweeper, [interval: 60])
  """
  use GenServer
  @default_interval 60 * 60 * 60 # 1 hour

  def start_link(state, opts \\ []) do
    state = state
    |> Enum.into(%{})
    |> Map.put_new(:interval, @default_interval)

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Reset the purge timer.
  """
  def reset_timer! do
    GenServer.call(__MODULE__, :reset_timer)
  end

  @doc """
  Manually trigger a db purge of expired tokens.
  Also resets the current timer.
  """
  def purge! do
    GenServer.call(__MODULE__, :sweep)
  end

  def init(state) do
    {:ok, reset_state_timer!(state)}
  end

  def handle_call(:reset_timer, _from, state) do
    {:reply, :ok, reset_state_timer!(state)}
  end

  def handle_call(:sweep, _from, state) do
    {:reply, :ok, sweep!(state)}
  end

  def handle_info(:sweep, state) do
    {:noreply, sweep!(state)}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  defp sweep!(state) do
    GuardianDb.Token.purge_expired_tokens!
    reset_state_timer!(state)
  end

  defp reset_state_timer!(state) do
    if state[:timer] do
      :timer.cancel(state.timer)
    end

    timer = Process.send_after(self, :sweep, state.interval)
    %{state | timer: timer}
  end
end
