defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  #The changeset lets Ecto decouple update policy from the schema
  def changeset(user, params \\ :invalid) do
    user
    |> cast(params, ~w(name username))
    |> validate_length(:username, min: 1, max: 20)
  end
end
