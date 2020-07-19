defmodule LiveViewWorkshopWeb.ClockLive do
  use LiveViewWorkshopWeb, :live_view

  alias LiveViewWorkshopWeb.ClockView

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, update_time(socket)}
  end

  @impl true
  def render(assigns) do
    ClockView.render("clock_live.html", assigns)
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, update_time(socket)}
  end

  defp update_time(socket) do
    assign(socket, current_time: DateTime.utc_now())
  end
end
