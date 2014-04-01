defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # defp get_all_articles do
  #   Content.find_all({})
  # end

  get "/" do
    render "index.html"
  end

  get "/blogs" do
    conn = conn.assign(:title, "Welcome to Dynamo Blog!")
    # articles = get_all_articles
    render conn, "index.html", articles: articles
  end
end
