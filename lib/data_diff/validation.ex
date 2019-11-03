defmodule DataDiff.Validation do
  @moduledoc false

  require Logger

  def valid_email(flow) do
    Logger.info("comecando verificar email")
    flow
    |> Flow.map(&(if valid_email?(&1.email), do: 0, else: 1))
    |> Enum.sum() #2s
    |> case  do
      sum when sum > 0 ->
        Logger.info("verificado email")
        {:error, "Invalid Email or empty line"}
      _ ->
        Logger.info("verificado email")
        flow
    end

  end

  defp valid_email?(email) do
    String.match?(email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end

  def has_header(stream) do
    stream
    |> Stream.take(1)
    |> Stream.map(&String.match?(&1, ~r/email,/))
    |> Enum.any?()
  end

  def is_empty(stream) do
    stream
    |> Stream.take(2)
    |> Enum.empty?()
  end

  def valid_file(file) do
    File.exists?(file) && (Path.extname(file) == ".csv")
  end
end
