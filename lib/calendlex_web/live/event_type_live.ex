defmodule CalendlexWeb.EventTypeLive do
  use CalendlexWeb, :live_view

  alias Calendlex.Calendar
  alias CalendlexWeb.Components.EventType
  alias Timex.Duration

  @impl LiveView
  def mount(%{"event_type_slug" => slug}, _session, socket) do
    case Calendlex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)
          |> assign(bdd: Calendar.list_days())

        {:ok, socket, temporary_assigns: [time_slots: []]}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendlexWeb.LayoutView, "not_found.html"}}
    end
  end

  @impl LiveView
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_dates(params)
      |> assign_time_slots(params)

    {:noreply, socket}
  end

  defp assign_dates(socket, params) do
    current = current_from_params(params, socket)
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    previous_month =
      beginning_of_month
      |> Timex.add(Duration.from_days(-1))
      |> date_to_month()

    next_month =
      end_of_month
      |> Timex.add(Duration.from_days(1))
      |> date_to_month()

    socket
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(current: current)
    |> assign(end_of_month: end_of_month)
    |> assign(previous_month: previous_month)
    |> assign(next_month: next_month)

  end

  def handle_event("click", %{"date" => date, "time" => time}, socket) do
    Calendar.create_day(%{date: date, time: time})
    {:noreply, socket}

  end

  defp assign_time_slots(socket, %{"date" => _}) do
    date = socket.assigns.current
    owner_time_zone = socket.assigns.owner.time_zone
    event_duration = socket.assigns.event_type.duration

    time_slots = Calendlex.build_time_slots(date, owner_time_zone, event_duration)

    socket
    |> assign(time_slots: time_slots)
    |> assign(selected_date: date)
  end

  defp assign_time_slots(socket, _), do: socket

  defp current_from_params(%{"date" => date}, socket) do
    case Timex.parse(date, "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.time_zone)
    end
  end

  defp current_from_params(%{"month" => month}, socket) do
    case Timex.parse("#{month}-01", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.time_zone)
    end
  end

  defp current_from_params(_, socket) do
    Timex.today(socket.assigns.time_zone)
  end

  defp date_to_month(date_time) do
    Timex.format!(date_time, "{YYYY}-{0M}")
  end
end