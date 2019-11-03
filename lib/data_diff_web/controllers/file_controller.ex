defmodule DataDiffWeb.FileController do
  use DataDiffWeb, :controller

  alias DataDiff.Uploader
  alias DataDiff.Operation.Ingestor

  def upload(conn, %{"file" => file}) do
    Uploader.upload(file)
    |> case  do
      {:ok, file_path} ->
        response = Jason.encode!(Ingestor.ingest_file(file_path))

        resp(conn, 200, response)

      {:error, reason} -> resp(conn, 200, Jason.encode!(reason))

    end

  end
end
