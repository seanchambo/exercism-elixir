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
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    [SecretHandshake.wink, SecretHandshake.double_blink, SecretHandshake.close_your_eyes, SecretHandshake.jump]
      |> Enum.map(fn(func) -> func.(code) end)
      |> reverse(code)
      |> Enum.filter(fn(elem) -> elem != "" end)
  end

  def wink(),            do: fn(code) -> if (code &&& 1) == 1, do: "wink", else: "" end
  def double_blink(),    do: fn(code) -> if (code &&& 2) == 2, do: "double blink", else: "" end
  def close_your_eyes(), do: fn(code) -> if (code &&& 4) == 4, do: "close your eyes", else: "" end
  def jump(),            do: fn(code) -> if (code &&& 8) == 8, do: "jump", else: "" end

  def reverse(array, code) when (code &&& 16) == 16, do: array |> Enum.reverse
  def reverse(array, _),                             do: array
end
