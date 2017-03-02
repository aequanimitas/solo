defmodule Solo.Repo.Migrations.CreateDump do
  use Ecto.Migration

  def change do
    create table(:dump) do
      add :dump, :string
      add :time_added, :naive_datetime, default: fragment("now()")
    end
  end
end
