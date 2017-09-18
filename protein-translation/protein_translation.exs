defmodule ProteinTranslation do

  @proteins [
    { "Cysteine", ["UGU", "UGC"] },
    { "Leucine", ["UUA", "UUG"] },
    { "Methionine", ["AUG"] },
    { "Phenylalanine", ["UUU", "UUC"] },
    { "Serine", ["UCU", "UCC", "UCA", "UCG"] },
    { "Tryptophan", ["UGG"] },
    { "Tyrosine", ["UAU", "UAC"] },
    { "STOP", ["UAA", "UAG", "UGA"] }
  ]
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
          { :ok, "STOP"}  -> { :halt, acc }
          { :ok, _ }      -> { :cont, acc ++ [result] }
          { :error, _ }   -> { :halt, acc ++ [result] }
        end
      end)
      |> Enum.unzip

    case :error in statuses do
      true  -> { :error, "invalid RNA" }
      false -> { :ok, proteins }
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
    case Enum.find(@proteins, fn({_, codons}) -> to_string(codon) in codons end) do
      { protein, _ }  -> { :ok, protein }
      nil             -> { :error, "invalid codon" }
    end
  end
end
