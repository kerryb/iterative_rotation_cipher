defmodule IterativeRotationCipher do
  def encode(n, text) do
    "#{n} #{shift_n_times(text, n)}"
  end

  defp shift_n_times(text, n) do
    Enum.reduce(1..n, text, fn _, text -> shift(text, n) end)
  end

  defp shift(text, n) do
    text
    |> shift_right_preserving_spaces(n)
    |> shift_character_groups_right(n)
  end

  def shift_right_preserving_spaces(text, n) do
    chars = String.codepoints(text)

    chars
    |> remove_spaces()
    |> rotate_right(n)
    |> replace_spaces(chars)
    |> to_string()
  end

  defp remove_spaces(chars), do: Enum.reject(chars, &(&1 == " "))

  defp rotate_right(chars, n) do
    chars
    |> Enum.split(-Integer.mod(n, length(chars)))
    |> (fn {left, right} -> right ++ left end).()
  end

  defp replace_spaces(chars, [" " | original_tail]) do
    [" " | replace_spaces(chars, original_tail)]
  end

  defp replace_spaces([], _), do: []

  defp replace_spaces([head | tail], [_ | original_tail]) do
    [head | replace_spaces(tail, original_tail)]
  end

  def shift_character_groups_right(text, n) do
    text
    |> String.split(~r/ +/, trim: true, include_captures: true)
    |> Enum.map(&rotate_group_right(&1, n))
    |> Enum.join()
  end

  defp rotate_group_right(text, n) do
    text
    |> String.split_at(-Integer.mod(n, String.length(text)))
    |> (fn {left, right} -> right <> left end).()
  end
end
