defmodule Solo do
  @moduledoc false

  @doc """
  Start the Ecto process, receives and executes queries
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Solo.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Solo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Initialize processes here, called only once to avoid spawning new processes
  """
  def main(_args \\ []) do
    self_pid = self()
    pid = spawn_link(fn -> input_loop(self_pid) end)
    do_loop(pid)
  end

  @doc """
  Imagine this as an intermediate step so that the two processes (input_loop and wait_input
  can start send messages to each other. The problem when you do a send in main is that 
  you're creating a new process everytime main is called. Just do this mediary function
  """
  def do_loop(pid) do
    send pid, {:do_input}
    wait_input(pid)
  end

  @doc """
  Handle messages coming from the input_loop 
  """
  def wait_input(pid) do
    receive do
      {:input, input} ->
        input_data = %Solo.Dump{dump: input, time_added: NaiveDateTime.from_erl!(today())}
        case Solo.Repo.insert(input_data) do
          {:ok, _} ->
          IO.write "(#{format_date_today()}) Message received: #{input}"
        end
        do_loop(pid)
    end
  end

  defp today do
    :calendar.local_time()
  end

  defp format_date_today do
  {{year,month,day}, {hour,minute,second}} = today()
  "#{year}/#{month}/#{day} #{hour}:#{minute}:#{second}"
  end

  @doc """
  Loop forever until eof
  """
  def input_loop(pid) do
    receive do
      {:do_input} ->
        input = case IO.gets(:stdio, "Waiting for braindump: ") do
          :eof -> :eof
          {:error, _ } -> ""
          data -> data
        end
        send pid, {:input, input}
    end
    input_loop(pid)
  end
end
