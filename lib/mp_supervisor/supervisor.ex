defmodule MP.Supervisor do
    use Supervisor
    
    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    def init(:ok) do
        children = [
            {MP.Queue, name: MP.Queue}
        ]
        Supervisor.init(children, strategy: :one_for_one)
    end

end