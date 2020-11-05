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
    |> shift_preserving_spaces(n, :right)
    |> shift_character_groups(n, :right)
  end

  defp shift_left(text, n) do
    text
    |> shift_character_groups(n, :left)
    |> shift_preserving_spaces(n, :left)
  end

  def shift_preserving_spaces(text, n, direction) do
    chars = String.codepoints(text)

    chars
    |> remove_spaces()
    |> rotate(n, direction)
    |> replace_spaces(chars)
    |> to_string()
  end

  defp remove_spaces(chars), do: Enum.reject(chars, &(&1 == " "))

  defp rotate(chars, n, :right), do: fold_at(chars, -Integer.mod(n, length(chars)))
  defp rotate(chars, n, :left), do: fold_at(chars, Integer.mod(n, length(chars)))

  defp fold_at(chars, n) do
    chars
    |> Enum.split(n)
    |> (fn {left, right} -> right ++ left end).()
  end

  defp replace_spaces(chars, [" " | original_tail]) do
    [" " | replace_spaces(chars, original_tail)]
  end

  defp replace_spaces([], _), do: []

  defp replace_spaces([head | tail], [_ | original_tail]) do
    [head | replace_spaces(tail, original_tail)]
  end

  def shift_character_groups(text, n, direction) do
    text
    |> String.split(~r/ +/, trim: true, include_captures: true)
    |> Enum.map(&rotate_group(&1, n, direction))
    |> Enum.join()
  end

  defp rotate_group(text, n, :right) do
    fold_group_at(text, -Integer.mod(n, String.length(text)))
  end

  defp rotate_group(text, n, :left) do
    fold_group_at(text, Integer.mod(n, String.length(text)))
  end

  defp fold_group_at(text, n) do
    text
    |> String.split_at(n)
    |> (fn {left, right} -> right <> left end).()
  end
end
