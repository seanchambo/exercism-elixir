defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @alphabet_size 26
  @low_start 97
  @low_end 122
  @up_start 65
  @up_end 90

  defmacro is_alphabet?(codepoint) do
    quote do
      (unquote(codepoint) >= @low_start and unquote(codepoint) <= @low_end) or
      (unquote(codepoint) >= @up_start and unquote(codepoint) <= @up_end)
    end
  end

  defmacro overflow?(codepoint, shift) do
    quote do
      (unquote(codepoint) >= @low_start and unquote(codepoint) <= @low_end and unquote(codepoint) + unquote(shift) > @low_end) or
      (unquote(codepoint) >= @up_start and unquote(codepoint) <= @up_end and unquote(codepoint) + unquote(shift) > @up_end)
    end
  end

  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    String.to_charlist(text)
      |> Enum.reduce("", fn(x, acc) -> acc <> rotate_codepoint(x, offset(x, shift)) end)
  end

  def rotate_codepoint(codepoint, offset), do: <<codepoint + offset::utf8>>

  def offset(codepoint, _) when not is_alphabet?(codepoint), do: 0
  def offset(codepoint, shift) when overflow?(codepoint, shift), do: -(@alphabet_size - shift)
  def offset(_, shift), do: shift
end
