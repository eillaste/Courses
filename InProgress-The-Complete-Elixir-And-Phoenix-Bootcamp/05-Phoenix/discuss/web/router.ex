defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    # If somebody makes a request to "/topics/new"
    # -> send them to TopicController and run function "new"
    #get "/topics/new", TopicController, :new
    #post "/topics", TopicController, :create
    #get "/topics", TopicController, :index
    get "/", TopicController, :index
    # Adding a route using a wildcard.
    #get "/topics/:id/edit", TopicController, :edit
    #put "/topics/:id", TopicController, :update
    #del "/topics/:id", TopicController, :delete
    # Resources assume a certain REST convention
    # Details: https://hexdocs.pm/phoenix/routing.html#resources
    resources "/topics", TopicController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
