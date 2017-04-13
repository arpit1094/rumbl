defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  filterable do
    field :username
    @options param: :q
    filter search(query, value, _conn) do
      query |> where([u], ilike(u.username, ^"%#{value}%"))
    end
  end

  def index(conn, _params) do
    with {:ok, query, filter_values} <- apply_filters(User, conn),
         users                       <- Repo.all(query),
     do: render(conn, "index.html", users: users, meta: filter_values)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end