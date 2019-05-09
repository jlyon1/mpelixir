defmodule MP.Router do
    use Plug.Router

    plug Plug.Parsers, parsers: [:urlencoded, :multipart]
    plug :match
    plug :dispatch

    get "/" do
        send_resp(conn, 200, "Yo")
    end

    get "/test" do
        test = %{
            "testval" => 1,
            "valuetwo" => "hey",
        } |> Jason.encode!
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, test)
    end

    match _ do
        send_resp(conn, 404, "not found")
    end

end