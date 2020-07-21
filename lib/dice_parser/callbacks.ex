defmodule DiceParse.Callbacks do
  @callback roll(num_dice :: integer(), num_sides :: integer()) :: list(integer)
  @callback roll(num_dice :: integer(), num_sides :: integer(), current_result :: list(integer)) :: list(integer)
end
