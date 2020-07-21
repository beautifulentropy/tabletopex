defmodule DiceParse do

  def parse_formula(formula_string) do
    try do
      formula_string
      |> String.replace(~r/\s/, "")
      |> parse_operators()
      |> parse_chunks()
      |> resolve_integers()
      |> resolve_group_operations()
      |> create_result_map()
    rescue
      ArithmeticError -> :error
    end
  end

  defp parse_operators(formula_string) do
    Regex.split(~r/\+|\-|\*|\//, formula_string, include_captures: true)
  end

  defp parse_chunks([]), do: []
  defp parse_chunks([formula_string | remaining]) do
    if String.match?(formula_string, ~r/[0-9]+d[0-9]+/) do
      [parse_chunk(formula_string) | parse_chunks(remaining)]
    else
      [formula_string | parse_chunks(remaining)]
    end
  end

  defp parse_chunk(formula_string) do
    [num_dice, back_half] = String.split(formula_string, "d", parts: 2)
    [num_sides, modifier] = parse_modifier(back_half)
    {num_dice, _} = Integer.parse(num_dice)
    {num_sides, _} = Integer.parse(num_sides)
    DiceParse.Modifiers.roll_with_modifier(num_dice, num_sides, modifier)
  end

  defp parse_modifier([num_sides_string]), do: [num_sides_string, {}]
  defp parse_modifier([num_sides_string, option_name, option_number]) do
    {modifier_number, _} = Integer.parse(option_number)
    [num_sides_string, [{String.to_atom(option_name), modifier_number}]]
  end
  defp parse_modifier(back_half) when is_bitstring(back_half) do
    String.split(back_half, ~r/kh|kl|dh|dl/, include_captures: true)
    |> parse_modifier()
  end

  defp resolve_integers([]), do: []
  defp resolve_integers([chunk | remaining]) when is_bitstring(chunk) do
    case Integer.parse(chunk) do
      {result, ""} -> [result | resolve_integers(remaining)]
      {_, _} -> [chunk | resolve_integers(remaining)]
      :error -> [chunk | resolve_integers(remaining)]
    end
  end
  defp resolve_integers([chunk | remaining]), do: [chunk | resolve_integers(remaining)]

  defp resolve_group_sums([]), do: []
  defp resolve_group_sums([chunk | remaining]) when is_list(chunk) do
    [Enum.sum(chunk) | resolve_group_sums(remaining)]
  end
  defp resolve_group_sums([chunk | remaining]), do: [chunk | resolve_group_sums(remaining)]

  defp resolve_group_operations(chunks) do
    sum = chunks
    |> resolve_group_sums()
    |> resolve_operator()
    |> Enum.sum()
    %{sum: sum, chunks: chunks}
  end

  defp resolve_operator([left_side, "+", right_side | remaining]), do: resolve_operator([left_side + right_side | remaining])
  defp resolve_operator([left_side, "-", right_side | remaining]), do: resolve_operator([left_side - right_side | remaining])
  defp resolve_operator([left_side, "*", right_side | remaining]), do: resolve_operator([left_side * right_side | remaining])
  defp resolve_operator([left_side, "/", right_side | remaining]), do: resolve_operator([left_side / right_side | remaining])
  defp resolve_operator(chunks), do: chunks

  defp create_result_map(result) do
    case is_integer(result.sum) do
      :true  -> %{result: result.sum, breakdown: result.chunks}
      :false -> %{
        result: round(result.sum),
        result_ceil: ceil(result.sum),
        result_floor: floor(result.sum),
        breakdown: result.chunks
      }
    end
  end

end
