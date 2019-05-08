defmodule MessagePass do
  use Application

  def start(_type, _args) do
    MP.Supervisor.start_link([])
  end
end
