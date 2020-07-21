defmodule DiceParse.PerformRoll do
  @behaviour DiceParse.Callbacks

  def roll(num_dice, num_sides, current_result \\ [])

  def roll(0, _num_sides, current_result), do: current_result

  def roll(num_dice, num_sides, current_result) do
    :rand.seed(:exsss, :erlang.timestamp())
    roll(num_dice - 1, num_sides, [Enum.random(1..num_sides) | current_result])
  end

end
