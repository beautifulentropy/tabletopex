# tabletopex
Hold tight, this is a work-in-progress. But here's some super basic instructions to mess around with the dice roller portion:

## Roll Formulas
A given turn formula is made up of chunks separated by arithmetic operators:

### Chunk
`"5d6"` = `5` rolls of a `d6` (6 sided die)

### Chunk with Option
`"5d6kh2"` = `5` rolls of a `d6` (6 sided die) `kh` (keep highest) `2` rolls

**supported options**: `kh` (keep highest), `kh` (keep lowest), `dh` (drop highest), `dl` (drop lowest)

## Operators
Between chunks, you can use operators (`+` `-` `*` `/`). Each chunk is rolled (with options if specified) and then the sum of each chunk can be added, subtracted, multiplied, or divided from one another (always performed from left to right)

## Example
```shell
~> git clone git@github.com:beautifulentropy/tabletopex.git
~> cd tabletopex
```
```elixir
iex -S mix
iex(1)> Tabletop.turn("11d6-4d6")
%{
  breakdown: [[5, 1, 1, 1, 5, 3, 5, 4, 2, 4, 4], "-", [4, 5, 1, 3]],
  counts: %{1 => 4, 2 => 1, 3 => 2, 4 => 4, 5 => 4, "-" => 1},
  sum: 22
}
iex(2)> Tabletop.turn("11d6+4d6")
%{
  breakdown: [[1, 1, 2, 5, 3, 6, 4, 4, 6, 6, 5], "+", [4, 1, 2, 1]],
  counts: %{1 => 4, 2 => 2, 3 => 1, 4 => 3, 5 => 2, 6 => 3, "+" => 1},
  sum: 51
}
```




