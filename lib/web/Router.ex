defmodule MP.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Yo")
  end

  get "/test" do
    test =
      %{
        "testval" => 1,
        "valuetwo" => "hey"
      }
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, test)
  end

  # {
  #   "key": "keyName",
  #   "value": {
  #     "value": "val"
  #   }
  # }
  post "/put" do
    case conn.body_params do
      %{"key" => _key, "value" => val} ->
        # Key is not used for now
        jsv = Jason.encode!(val)
        case MP.TaskRouter.rand_push(jsv) do
          :ok -> 
            conn |> send_resp(200, "inserted")
          _ -> 
            conn |> send_resp(500, "internal server error")
        end
      _ ->
        conn
        |> send_resp(400, "bad request")
        IO.puts "here"
    end
  end

  get "/pop" do
    case MP.TaskRouter.find_and_pop do
      {:empty, _} ->
        conn
        |> send_resp(200, "empty")
      {:ok, val} -> 
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, val) 
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
