defmodule MP.Router do
    use Plug.Router

    plug Plug.Parsers, parsers: [:urlencoded, :multipart]
    plug :match
    plug :dispatch

    get "/" do
        send_resp(conn, 200, "Yo")
    end

    match _ do
        send_resp(conn, 404, "not found")
    end

end