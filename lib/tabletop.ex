defmodule Tabletop do
  require DiceParse

  def turn(formula) do
    DiceParse.parse_formula(formula)
  end
end
