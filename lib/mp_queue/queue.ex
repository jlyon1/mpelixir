defmodule MP.Queue do
    use GenServer

    def start_link(opts) do
        GenServer.start_link(__MODULE__, :ok, opts)
    end

    def pop() do
        GenServer.call(__MODULE__, {:pop})
    end

    def pushback(value) do
        GenServer.cast(__MODULE__, {:pushback, value})
    end

    def init(:ok) do
        queue = [:a]
        {:ok, queue}
    end

    def handle_call({:pop}, _from, state) do
        case length state do
            0 -> 
                {:reply, {:empty, :empty}, state}
            _ -> 
                {:reply, {:ok, hd(state)}, tl(state)}
        end
    end

    def handle_cast({:pushback, value}, state) do
        {:noreply, state ++ [value]}
    end
    
end