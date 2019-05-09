defmodule MP.Supervisor do
    use Supervisor
    require Logger
    
    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    def init(:ok) do
        children = [
            {MP.Queue, name: MP.Queue},
            {Plug.Cowboy, scheme: :http, plug: MP.Router, options: [port: cowboy_port()]},
            {Task.Supervisor, name: MP.Tasks},
        ]
        Logger.info("Starting supervisor")
        Supervisor.init(children, strategy: :one_for_one)
    end

    defp cowboy_port, do: Application.get_env(:message_pass, :cowboy_port, 8080)

end