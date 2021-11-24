defmodule Calendlex.CalendarFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calendlex.Calendar` context.
  """

  @doc """
  Generate a day.
  """
  def day_fixture(attrs \\ %{}) do
    {:ok, day} =
      attrs
      |> Enum.into(%{
        date: "some date",
        time: "some time"
      })
      |> Calendlex.Calendar.create_day()

    day
  end
end
