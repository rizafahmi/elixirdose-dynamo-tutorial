Lists of frameworks:
1. Dynamo
2. weber (https://github.com/0xAX/weber/)
3. Phoenix (https://github.com/phoenixframework/phoenix)
4. Sugar (https://github.com/sugar-framework/sugar)
http://sugar-framework.github.io/getting-started/
5. Charlotte (https://github.com/LeakyBucket/charlotte)
6. Thunder (http://thunder-ex.github.io/) *dead?*
	https://www.youtube.com/watch?v=s0RxjHs0cwk
7. ChicagoBoss?
8. Build your own?

## Elixir Installation

## Dynamo
Intro
### Installation
1. Clone this repository and go to its directory: 
	$> git clone https://github.com/dynamo/dynamo.git
	$> cd dynamo
2. Get Dynamo dependencies and compile: 
	$> mix do deps.get, compile
3. Create a project:
	$> mix dynamo ../hello_dynamo
4. Go to your app
	$> cd ../hello_dynamo
5. Get dependencies and compile;
	$> mix do deps.get, compile
6. Run and test it
	$> mix server

### Day One: Building a Blog

Before we go any further, let's write "Hello World" type application first to try Dynamo environment. Using hello_dynamo project, lets look at the routers file since Dynamo is organized in routers.
Dynamo kept routers files in the `web/routes` directory and by default a dynamo project contains an `ApplicationRouter` defined at `web/routers/application_router.ex`. We need to edit `web/routers/applications_router.ex`. Insert this code below right before the last `end`:

	get "/hello" do
		conn.resp(200, "Hello Dynamo!")
	end
[web/routers/application_router.ex]

We have request method `get`, the URI `/hello`, and the result. That's pretty much it. When a GET request to `/hello` comes in as you typing `http://localhost:4000/hello` in the browser, the response will be "Hello Dynamo!".

This is the full code:
	defmodule ApplicationRouter do
  	use Dynamo.Router

  	prepare do
    	# Pick which parts of the request you want to fetch
    	# You can comment the line below if you don't need
    	# any of them or move them to a forwarded router
    	conn.fetch([:cookies, :params])
  	end

  	# It is common to break your Dynamo into many
  	# routers, forwarding the requests between them:
  	# forward "/posts", to: PostsRouter

  	get "/" do
    	conn = conn.assign(:title, "Welcome to Dynamo!")
    	render conn, "index.html"
  	end

  	get "/hello" do
    	conn.resp 200, "Hello Dynamo!"
  	end
	end
[web/routers/application_router.ex]
https://github.com/rizafahmi/elixirdose-dynamo-tutorial/commit/d88677ac7d6282f3dfe61a66974110442229b894 -> Tag this later.

#### RESTful API
No it's time to implementing our blog engine. User can create an article, update, delete and list the articles. We will create RESTful API for this project. This is what the routers will looks like:

	GET			/blogs		- get all list of articles
	GET			/blogs/ID - get the details of article identified by ID
	POST	 		/blogs 		- create new article
	PUT 		 	/blogs/ID	- update an article identified by ID
	DELETE	 	/blogs/ID - delete an article identified by ID

As you can see above, our application is simply CRUD for blog: create, read, update and delete. To achieve our goal, we'll start with some data persistence.

#### Database

To complete our stack of technology, we will need database to save our articles. In this case, we will use MongoDB for no specific reason. It's easy to install, and it's easy to operate, that's it. You can use your own preferred database here by using PostgreSQL with Ecto for example.

Let's assume you have already installed mongodb and run it. If not, go ahead to mongodb website and do me a favor to install it on your system.

Now we need driver to connect our Elixir application to mongodb database. Lucky enough, there is mongodb driver for Elixir (https://github.com/mururu/mongoex). In order to add this driver to our project we need to add the url into mix.exs under deps module.

	defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      **{ :mongoex, github: "mururu/mongoex", override: true }**
    ]
  end
	[mix.exs]

Then we need to get the dependencies and download the driver and compile it using mix:

	$> mix deps.get
	$> mix deps.compile

Now mongodb are ready to use. First, we need to setup the connection to mongodb and start the driver. Let's add a connection in `web/routes/application_router.ex` file.

	defmodule ApplicationRouter do
		use Dynamo.Router
		Mongoex.Server.setup(address: 'localhost', port: 27017, database: :elixirblog)
		Mongoex.Server.start

	…
	[lib/hello_dynamo.ex]

Mongoex use model layer to define our document or table. So first we need to add model module.

	defmodule Content do
		use Mongoex.Base
		fields title: nil, body: nil
	end

	…
	[lib/models/contents.ex]

#### Creating And Reading Article

Now we're ready to write Elixir methods for creating and reading blog articles. Let's start with a simple `GET` request to `/blogs` that returns all articles.

	defp get_all_articles do
    Contents.find_all({})
  end

  get "/blogs" do
    conn = conn.assign(:title, "Welcome to Dynamo Blog!")
    articles = get_all_articles
    render conn, "index.html", articles: articles
	end
	[web/router/application_router.ex]

First, we assign title to display "Welcome to Dynamo Blog" for browser's title. Then we get articles that call private function `get_all_articles` to get all articles. Lastly, we render it with the template `index.html` and articles data. Now let's open `index.html.eex` and make it display all articles.

If you notice, in router file we mention `index.html` but the actual filename in template is `index.html.eex`. Dynamo templates uses [EEx](http://elixir-lang.org/docs/stable/EEx.html) to let you embed Elixir logic into your HTML template.

And since we also render `index.html` with articles variable, `articles` will available in the templates. To display each articles we use iteration.

 
	
 
