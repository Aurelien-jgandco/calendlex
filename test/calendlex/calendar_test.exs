defmodule Calendlex.CalendarTest do
  use Calendlex.DataCase

  alias Calendlex.Calendar

  describe "days" do
    alias Calendlex.Calendar.Day

    import Calendlex.CalendarFixtures

    @invalid_attrs %{date: nil, time: nil}

    test "list_days/0 returns all days" do
      day = day_fixture()
      assert Calendar.list_days() == [day]
    end

    test "get_day!/1 returns the day with given id" do
      day = day_fixture()
      assert Calendar.get_day!(day.id) == day
    end

    test "create_day/1 with valid data creates a day" do
      valid_attrs = %{date: "some date", time: "some time"}

      assert {:ok, %Day{} = day} = Calendar.create_day(valid_attrs)
      assert day.date == "some date"
      assert day.time == "some time"
    end

    test "create_day/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calendar.create_day(@invalid_attrs)
    end

    test "update_day/2 with valid data updates the day" do
      day = day_fixture()
      update_attrs = %{date: "some updated date", time: "some updated time"}

      assert {:ok, %Day{} = day} = Calendar.update_day(day, update_attrs)
      assert day.date == "some updated date"
      assert day.time == "some updated time"
    end

    test "update_day/2 with invalid data returns error changeset" do
      day = day_fixture()
      assert {:error, %Ecto.Changeset{}} = Calendar.update_day(day, @invalid_attrs)
      assert day == Calendar.get_day!(day.id)
    end

    test "delete_day/1 deletes the day" do
      day = day_fixture()
      assert {:ok, %Day{}} = Calendar.delete_day(day)
      assert_raise Ecto.NoResultsError, fn -> Calendar.get_day!(day.id) end
    end

    test "change_day/1 returns a day changeset" do
      day = day_fixture()
      assert %Ecto.Changeset{} = Calendar.change_day(day)
    end
  end
end
