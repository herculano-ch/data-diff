defmodule DataDiff.Operation.Ingestor do
  @moduledoc false

  def ingest_file(file) do
    case DataDiff.ingest(file) do
      {:ok, result}   -> result
      {:error, error} -> error
    end
  end
end
