defmodule Calendlex.Calendar do
  @moduledoc """
  The Calendar context.
  """

  import Ecto.Query, warn: false
  alias Calendlex.Repo

  alias Calendlex.Calendar.Day

  @doc """
  Returns the list of days.

  ## Examples

      iex> list_days()
      [%Day{}, ...]

  """
  def list_days do
    Repo.all(Day)
  end

  def delete_day_by_date(%{date: date, time: time}) do
    query = from d in Day,
          where: d.date == ^date and d.time == ^time,
          select: d

          day = Repo.all(query)
          Repo.delete(hd(day))
          |> broadcast([:day, :deleted])

  end

  @doc """
  Gets a single day.

  Raises `Ecto.NoResultsError` if the Day does not exist.

  ## Examples

      iex> get_day!(123)
      %Day{}

      iex> get_day!(456)
      ** (Ecto.NoResultsError)

  """
  def get_day!(id), do: Repo.get!(Day, id)

  @doc """
  Creates a day.

  ## Examples

      iex> create_day(%{field: value})
      {:ok, %Day{}}

      iex> create_day(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_day(attrs \\ %{}) do
    %Day{}
    |> Day.changeset(attrs)
    |> Repo.insert()
    |> broadcast([:day, :created])
  end

  @doc """
  Updates a day.

  ## Examples

      iex> update_day(day, %{field: new_value})
      {:ok, %Day{}}

      iex> update_day(day, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_day(%Day{} = day, attrs) do
    day
    |> Day.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a day.

  ## Examples

      iex> delete_day(day)
      {:ok, %Day{}}

      iex> delete_day(day)
      {:error, %Ecto.Changeset{}}

  """
  def delete_day(%Day{} = day) do
    Repo.delete(day)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking day changes.

  ## Examples

      iex> change_day(day)
      %Ecto.Changeset{data: %Day{}}

  """
  def change_day(%Day{} = day, attrs \\ %{}) do
    Day.changeset(day, attrs)
  end


  def subscribe do
    Phoenix.PubSub.subscribe(Calendlex.PubSub, "days")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, day}, event) do
    Phoenix.PubSub.broadcast(Calendlex.PubSub, "days", {event, day})
    {:ok, day}
  end
end
