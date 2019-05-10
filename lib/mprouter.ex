defmodule MP.TaskRouter do
  def route(_mod, _fun, _args) do
    case MP.Queue.len do
        {:ok, 0} ->
           find_good_node table()

        _ -> 
            node()
    end
  end

  # returns the node with at least one element in its queue
  def find_good_node(table) do
    task = Task.Supervisor.async {MP.Tasks, hd table}, MP.Queue, :len, []
    case Task.await(task) do
        {:ok, 0} -> 
            find_good_node(tl table)
        _ -> 
            hd table
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
