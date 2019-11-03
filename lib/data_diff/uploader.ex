defmodule DataDiff.Uploader do

  def upload(file) do
    full_file_path = filefullpath(file)
    case File.cp(file.path, full_file_path) do
      :ok -> {:ok, full_file_path}
      {:error, reason} -> {:error, reason}
    end

  end

  defp filefullpath(file) do
    "#{Application.app_dir(:data_diff)}/#{file.filename}"
  end
end
