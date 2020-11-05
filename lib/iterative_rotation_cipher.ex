defmodule IterativeRotationCipher do
  def encode(n, text) do
    "#{n} #{n_times(text, &shift_right/2, n)}"
  end

  def decode(text) do
    [n, cipher] = String.split(text, " ", parts: 2)
    n_times(cipher, &shift_left/2, String.to_integer(n))
  end

  defp n_times(text, fun, n) do
    Enum.reduce(1..n, text, fn _, text -> fun.(text, n) end)
  end

  defp shift_right(text, n) do
    text
    |> shift_right_preserving_spaces(n)
    |> shift_character_groups_right(n)
  end

  defp shift_left(text, n) do
    text
    |> shift_character_groups_left(n)
    |> shift_left_preserving_spaces(n)
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

  def shift_left_preserving_spaces(text, n) do
    chars = String.codepoints(text)

    chars
    |> remove_spaces()
    |> rotate_left(n)
    |> replace_spaces(chars)
    |> to_string()
  end

  defp rotate_left(chars, n) do
    chars
    |> Enum.split(Integer.mod(n, length(chars)))
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

  def shift_character_groups_left(text, n) do
    text
    |> String.split(~r/ +/, trim: true, include_captures: true)
    |> Enum.map(&rotate_group_left(&1, n))
    |> Enum.join()
  end

  defp rotate_group_left(text, n) do
    text
    |> String.split_at(Integer.mod(n, String.length(text)))
    |> (fn {left, right} -> right <> left end).()
  end
end
