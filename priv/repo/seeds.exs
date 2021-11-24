alias Calendlex.{Event, EventType, Repo}
alias Calendlex.Calendar.Day
Repo.delete_all(Event)
Repo.delete_all(EventType)

event_types = [
  %{
    name: "15 minute meeting",
    description: "Short meeting call.",
    duration: 15,
    color: "blue"
  },
  %{
    name: "30 minute meeting",
    description: "Extended meeting call.",
    duration: 30,
    color: "pink"
  },
  %{
    name: "Pair programming session",
    description: "One hour of pure pair programming fun!",
    duration: 60,
    color: "purple"
  }
]

for event_type <- event_types do
  event_type
  |> EventType.changeset()
  |> Repo.insert!()
end


%Day{}
  |>Day.changeset(%{
  date: "25-11-2021",
  time: "11:00",
  })
  |> Repo.insert!

%Day{}
  |>Day.changeset(%{
  date: "27-11-2021",
  time: "13:00",
  })
  |> Repo.insert!

%Day{}
  |>Day.changeset(%{
  date: "30-11-2021",
  time: "09:00",
  })
  |> Repo.insert!
