defmodule Bob do
  def hey(input) do
    cond do
        is_blank?(input)    -> "Fine. Be that way!"
        is_question?(input) -> "Sure."
        is_yelling?(input)  -> "Whoa, chill out!"
        true                -> "Whatever."
    end
  end

  def is_blank?(input),     do: input |> String.trim |> String.length == 0
  def is_question?(input),  do: input |> String.ends_with?("?")
  def is_yelling?(input),   do: input |> String.upcase == input and input |> String.downcase != input
end
