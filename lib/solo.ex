defmodule Solo do
  @moduledoc false

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
        IO.write "(#{format_date_today(:calendar.local_time())}) Message received: #{input}"
        do_loop(pid)
    end
  end

  defp format_date_today(_dte={{year,month,day}, {hour,minute,second}}) do
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
