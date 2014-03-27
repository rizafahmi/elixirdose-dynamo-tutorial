defmodule ApplicationRouter do
  use Dynamo.Router
  Mongoex.Server.setup(address: 'localhost', port: 3001, database: :meteor)
  Mongoex.Server.start

  defmodule Contents do
    use Mongoex.Base
    fields title: nil
  end

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  defp get_all_articles do
    Contents.find_all({})
  end

  get "/blogs" do
    conn = conn.assign(:title, "Welcome to Dynamo Blog!")
    articles = get_all_articles |> Stream.map(fn(article) ->
      [title: article.title] end)
    is_list articles
    render conn, "index.html", articles: articles
  end
end
