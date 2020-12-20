defmodule TfIdfClient do
  @moduledoc """
  Documentation for `TfIdfClient`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TfIdfClient.sendRequest("the", "Hobbit.txt")
      true
      0.0

  """
  def sendRequest(word, text) do
    if is_binary(word) and is_binary(text) do
      texts = ["Pollyanna.txt", "Hobbit.txt", "Silmarillion.txt", "One Hundred Years of Solitude.txt"]
      text = Enum.find_index(texts, fn(t) -> t == text end)
      if text != nil do
        texts = Enum.map(texts, fn(t) -> readText(t) end)
        IO.puts is_list(texts)
        data = Poison.encode!(%{"word" => word, "text" => text, "texts" => texts})
        response = HTTPotion.post "http://127.0.0.1:61017/tfIdf", [body: data, headers: [], timeout: 20_000]
        {result, _} = Float.parse(response.body)
        result
      else
        "this file does not exist"
      end
    else
      "invalid input"
    end
  end

  def readText(text) do
    {s, text} = File.read("texts/" <> text)
    if s == :ok do
      :erlang.term_to_binary(text) |> Base.encode64
    else
      :ioerror
    end
  end
end
