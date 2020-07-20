defmodule LiveViewWorkshopWeb.FlightSimulatorLive do
  alias LiveViewWorkshop.FlightSimulator
  alias LiveViewWorkshopWeb.{FlightSimulatorView, LayoutView}
  use Phoenix.LiveView, layout: {LayoutView, "flight_simulator_live.html"}

  @page_title "Ground Control - Beam UAV"
  @tick 30
  @tick_seconds @tick / 1000
  # Sydney Airport
  @default_simulator %FlightSimulator{
    location: %{lat: -33.964592291602244, lng: 151.18069727924058},
    bearing: 347.0
  }

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@tick, self(), :tick)

    socket =
      assign(socket,
        page_title: @page_title,
        simulator: @default_simulator
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    FlightSimulatorView.render("flight_simulator.html", assigns)
  end

  @impl true
  def handle_event("control_input", %{"key" => key}, socket)
      when key in ["ArrowLeft", "a"] do
    simulator = FlightSimulator.roll_left(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => key}, socket)
      when key in ["ArrowRight", "d"] do
    simulator = FlightSimulator.roll_right(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => key}, socket)
      when key in ["ArrowUp", "w"] do
    simulator = FlightSimulator.pitch_down(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => key}, socket)
      when key in ["ArrowDown", "s"] do
    simulator = FlightSimulator.pitch_up(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => "-"}, socket) do
    simulator = FlightSimulator.speed_down(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => "="}, socket) do
    simulator = FlightSimulator.speed_up(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => ","}, socket) do
    simulator = FlightSimulator.yaw_left(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => "."}, socket) do
    simulator = FlightSimulator.yaw_right(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => " "}, socket) do
    simulator = FlightSimulator.reset_attitude(socket.assigns.simulator)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", %{"key" => "Escape"}, socket) do
    socket = assign(socket, simulator: @default_simulator)
    {:noreply, socket}
  end

  @impl true
  def handle_event("control_input", _key, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    simulator = FlightSimulator.update(socket.assigns.simulator, @tick_seconds)
    socket = assign(socket, simulator: simulator)
    {:noreply, socket}
  end
end
