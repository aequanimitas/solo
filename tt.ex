defmodule Don do
  def init do
    self_pid = self() # assign this to a label, if self() is passed around, as it is, it will get trapped in io_get
    IO.puts inspect self_pid
    input = spawn(fn -> io_get(self_pid) end)
    wait_input(input)
  end

  def io_get(pid) do
    send pid, {:input, self(), IO.gets(:stdio, "testing: ")}
  end

  def wait_input(input) do
    receive do
      {:input, pid, code} ->
        IO.puts "wait_input receive first clause, message is #{code}"
        init()
    end
  end
end

Don.init()
