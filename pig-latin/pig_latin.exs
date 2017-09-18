defmodule PigLatin do

  @vowels ~r/(?<start>^yt|^xr|^[aeiou])(?<end>.*)/

  @consonant ~r/(?<start>^squ|^thr|^sch|^ch|^qu|^th|^[^aeiou]*)(?<end>.*)/

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
      |> String.split
      |> Enum.map(&(translate_subphrase(&1)))
      |> Enum.join(" ")
  end

  def translate_subphrase(sub_phrase) do
    case for_vowel(sub_phrase) do
      { :ok, translation } -> translation
      { :no_match, _ }     ->
        case for_consonant(sub_phrase) do
          { :ok, translation }  -> translation
          { :no_match, _ }      -> sub_phrase
        end
    end
  end

  def for_vowel(phrase) do
    case Regex.named_captures(@vowels, phrase) do
      %{ "start" => start, "end" => tail } -> { :ok, "#{start}#{tail}ay" }
      nil                                  -> { :no_match, nil }
    end
  end

  def for_consonant(phrase) do
    case Regex.named_captures(@consonant, phrase) do
      %{ "start" => start, "end" => tail } -> { :ok, "#{tail}#{start}ay" }
      nil                                  -> { :no_match, nil }
    end
  end
end
