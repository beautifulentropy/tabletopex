defmodule DiceParse.Modifiers do
  @roll DiceParse.PerformRoll
  def roll_with_modifier(num_dice, num_sides, options \\ {})
  def roll_with_modifier(num_dice, num_sides, options) do
    num_dice
    |> @roll.roll(num_sides)
    |> modifier(options)
  end

  defp modifier(results, kh: rolls_to_keep), do: results |> Enum.sort(&(&1 >= &2)) |> Enum.take(rolls_to_keep)
  defp modifier(results, kl: rolls_to_keep), do: results |> Enum.sort() |> Enum.take(rolls_to_keep)
  defp modifier(results, dl: rolls_to_drop), do: results |> Enum.sort() |> Enum.drop(rolls_to_drop)
  defp modifier(results, dh: rolls_to_drop), do: results |> Enum.sort() |> Enum.drop(rolls_to_drop * -1)
  defp modifier(results, _), do: results
end
