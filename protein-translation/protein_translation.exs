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

  def split_rna(rna), do: split_rna(rna, [])
  def split_rna("", acc), do: acc
  def split_rna(rna, acc) do
    { codon, tail } = rna |> String.split_at(3)
    split_rna(tail, [of_codon(codon) | acc])
  end

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }
  def of_rna(rna), do: of_rna(rna, [])
  def of_rna("", acc), do: { :ok, acc }
  def of_rna(rna, acc) do
    { codon, tail } = rna |> String.split_at(3)

    case of_codon(codon) do
      { :ok, "STOP" }   -> of_rna("", acc)
      { :ok, protein }  -> of_rna(tail, acc ++ [protein] )
      { :error, _ }     -> { :error, "invalid RNA" }
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
    case @proteins |> Enum.find(fn({_, codons}) -> codon in codons end) do
      { protein, _ }  -> { :ok, protein }
      nil             -> { :error, "invalid codon" }
    end
  end
end
