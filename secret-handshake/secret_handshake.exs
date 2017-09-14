defmodule SecretHandshake do
  use Bitwise
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """

  @actions [
    { 1, "wink" },
    { 2, "double blink" },
    { 4, "close your eyes" },
    { 8, "jump" }
  ]

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    @actions
      |> Enum.map(fn(action) -> check_action(action, code) end)
      |> Enum.filter(fn(elem) -> elem != "" end)
      |> reverse(code)
  end

  def check_action({bits, action}, code), do: if (code &&& bits) == bits, do: action, else: ""

  def reverse(array, code) when (code &&& 16) == 16, do: array |> Enum.reverse
  def reverse(array, _),                             do: array
end
