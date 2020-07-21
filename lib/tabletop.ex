defmodule Tabletop do
  require DiceParse

  def turn() do
    DiceParse.parse_formula("8d6 / 3")
  end
end
