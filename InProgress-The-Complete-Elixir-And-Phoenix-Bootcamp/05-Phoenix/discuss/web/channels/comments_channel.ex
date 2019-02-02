defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.{Topic, Comment}

  def join(name, _params, socket) do
    # Name arguments is given as "comments:topic_id"
    # Pattern matching
    "comments: " <> topic_id = name
    # 'topic id' must be an integer
    topic_id = String.to_integer(topic_id)
    # Fetching Topic with given id
    # Adding preloading comments for the topics
    topic = Topic
      |> Repo.get(topic_id)
    # Adding preloading with nested associations
    # Use following if you want to preload user that created the topic
    # and the user that create the comments
    # Discuss.Repo.preload([:user, comments: [:user]])
    # But below, only the users that created the comments are preloaded
      |> Repo.preload(comments: [:user])
    # Assigning value to the socket (similar like with the conn object)
    # {:ok, %{}, socket}
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, message, socket) do
    # Pattern matching to get the content message
    %{"messageContent" => content} = message
    # Obtaining the topic from the socket object
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id
    # Building the association
    changeset = topic
    # with the comments table
    |> build_assoc(:comments, user_id: user_id)
    # Content property comes from the Comment model
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        # Notifying everyone who subscribes to the channel
        # broadcast!(socket, event_name, data_to_be_sent)
        broadcast!(socket, "comments:#{topic.id}:new",
            %{comment: comment}
          )
        # Reply will come from the broadcast method.
        # {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, { :error, %{ errors: changeset }}, socket}
    end
  end
end
