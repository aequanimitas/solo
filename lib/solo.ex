defmodule Solo do
  @moduledoc """
  Documentation for Solo.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Solo.hello
      :world

  """

  import Plug.Conn

  def init(options) do
    options
  end
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello Solo")
  end
end
