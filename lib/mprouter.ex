defmodule MP.TaskRouter do
  def find_and_pop() do
    case MP.Queue.len do
        {:ok, 0} ->
            case find_good_node table() do
                {:empty, e} ->
                    {:empty, e}
                {:ok, val} ->
                    task = Task.Supervisor.async {MP.Tasks, val}, MP.Queue, :pop, []
                    task
                    |> Task.await
            end
        _ -> 
            task = Task.Supervisor.async {MP.Tasks, node()}, MP.Queue, :pop, []
        task
        |> Task.await
    end
  end

  def rand_push(val) do
    tbl = rand_node(table(), -1)
    task = Task.Supervisor.async {MP.Tasks, tbl}, MP.Queue, :pushback, [val]
    task
    |> Task.await
  end

  def rand_node(table, i) do
    case i do
        -1 -> 
            rand_node(table, :rand.uniform(length(table)) - 1)
        0 -> 
            hd table
        _ ->
            rand_node(tl(table), (i - 1))
    
    end
  end

  # returns the node with at least one element in its queue
  def find_good_node(table) do
    if length(table) == 0 do
        {:empty, :empty}        
    else
        case Node.ping(hd table) do
          :pang ->
            find_good_node(tl table)
          _ ->
            task = Task.Supervisor.async {MP.Tasks, hd table}, MP.Queue, :len, []
            case Task.await(task) do
                {:ok, 0} -> 
                    find_good_node(tl table)
                _ -> 
                    {:ok, hd table}
            end
        end
    end
  end

  @doc """
  The routing table.
  """
  def table do
    # Application.fetch_env!(:message_pass, :routing_table)
    # Replace computer-name with your local machine name
    [:"foo@127.0.0.1", :"bar@127.0.0.1"]
  end
end
