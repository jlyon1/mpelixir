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

  post "/add" do
    case conn.body_params do
      %{"test" => z} ->
        send_resp(conn, 200, "test provided: " <> z)

      _ ->
        send_resp(conn, 400, "bad request or whatever")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
