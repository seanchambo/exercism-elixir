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

  defmacro is_lower?(codepoint), do: quote do: unquote(codepoint) in @low_start..@low_end
  defmacro is_upper?(codepoint), do: quote do: unquote(codepoint) in @up_start..@up_end

  defmacro is_alphabet?(codepoint), do: quote do: is_lower?(unquote(codepoint)) or is_upper?(unquote(codepoint))

  defmacro overflow?(codepoint, shift) do
    quote do
      (is_lower?(unquote(codepoint)) and unquote(codepoint) + unquote(shift) > @low_end) or
      (is_upper?(unquote(codepoint)) and unquote(codepoint) + unquote(shift) > @up_end)
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
