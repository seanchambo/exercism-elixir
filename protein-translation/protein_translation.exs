defmodule ProteinTranslation do

  @proteins %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }
  def of_rna(rna) do
    { statuses, proteins } = rna
      |> String.to_charlist
      |> Enum.chunk_every(3)
      |> Enum.reduce_while([], fn(codon, acc) ->
        case result = of_codon(codon) do
          { :ok, "STOP" }  -> { :halt, acc }
          { :ok, _ }      -> { :cont, [result | acc] }
          { :error, _ }   -> { :halt, [result | acc] }
        end
      end)
      |> Enum.unzip

    case :error in statuses do
      true  -> { :error, "invalid RNA" }
      false -> { :ok, proteins |> Enum.reverse }
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: { atom, String.t() }
  def of_codon(codon) do
    case @proteins[to_string(codon)] do
      nil     -> { :error, "invalid codon" }
      protein -> { :ok, protein }
    end
  end
end
