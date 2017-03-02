defmodule Solo.Dump do
  use Ecto.Schema

  schema "dump" do
    field :dump, :string
    field :time_added, :naive_datetime
  end
end
