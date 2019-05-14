defmodule MP.Queue do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def pop() do
    GenServer.call(__MODULE__, {:pop})
  end

  def len() do
    GenServer.call(__MODULE__, {:len})
  end

  def pushback(value) do
    GenServer.cast(__MODULE__, {:pushback, value})
  end

  def init(:ok) do
    queue = []
    {:ok, queue}
  end

  def handle_call({:pop}, _from, state) do
    case length(state) do
      0 ->
        {:reply, {:empty, :empty}, state}

      _ ->
        {:reply, {:ok, hd(state)}, tl(state)}
    end
  end

  def handle_call({:len}, _from, state) do

      {:reply, {:ok, length(state)}, state}
  end

  def handle_cast({:pushback, value}, state) do
    {:noreply, state ++ [value]}
  end
end
