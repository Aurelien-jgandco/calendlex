defmodule Calendlex.Calendar.Day do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "days" do
    field :date, :string
    field :time, :string

    timestamps()
  end

  @doc false
  def changeset(day, attrs) do
    day
    |> cast(attrs, [:date, :time])
    |> validate_required([:date, :time])
  end
end
