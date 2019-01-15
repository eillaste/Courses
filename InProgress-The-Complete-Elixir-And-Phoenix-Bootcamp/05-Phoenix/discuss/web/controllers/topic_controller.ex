defmodule Discuss.TopicController do
  # Go and grab all behaviours from web.ex
  # It is similar to class inheritance in OOP
  use Discuss.Web, :controller

  # Discuss.Topic => Topic
  alias Discuss.Topic

  # Not using the layout
  #plug :put_layout, false

  def new(conn, _params) do
    struct = %Topic{}
    params = %{}
    # An empty changeset
    changeset = Topic.changeset(struct, params)
    # Rendering template new.html that must be in folder "topic"
    render conn, "new.html", changeset_variable: changeset
  end

  # Accessing the parameters with pattern matching
  def create(conn, %{"topic" => topic}) do
    # Creating changeset
    changes = Topic.changeset(%Topic{}, topic)
    # They changeset does not need to be check valid?
    # Repo module takes care of it and it will not try to insert it,
    # if the changeset is invalid
    case Repo.insert(changes) do
      {:ok, post} -> IO.inspect(post)
      {:error, changes} -> IO.inspect(changes)
    end
  end
end
