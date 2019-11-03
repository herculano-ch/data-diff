defmodule DataDiff do
  @moduledoc """
  Documentation for DataDiff.
  """

  #alias DataDiff.Service.Redis

  require Logger

  alias DataDiff.Validation

  def ingest(file) do
    Logger.info("começando processo")

    case Validation.valid_file(file) do
      false -> {:error, "Invalid file"}
      _ -> streamize_file(file)
    end
  end

  def streamize_file(file) do
    file
    |> File.stream!()
    |> check_prevalidations()
  end

  def check_prevalidations(stream) do
    stream
    |> Validation.has_header()
    |> case  do
      false -> {:error, "Without header"}
      _ -> empty_or_build(stream)
    end
  end

  def empty_or_build(stream) do
    stream
    |> Validation.is_empty()
    |> case  do
      true -> {:error, "Empty"}
      _ -> process_flow(stream)
    end
  end

  def process_flow(stream) do
    stream
    |> CsvParse.parse_stream
    |> Flow.from_enumerable()
    |> Flow.map(fn [name, employee_number, email, department] ->
      %{name: name, employee_number: employee_number, email: email, department: department}
    end)
    |> Flow.partition()
    |> check_validations()
    |> proc_evaluation()
  end

  def check_validations(flow) do
    flow
    |> Validation.valid_email()
  end

  def proc_evaluation(flow) do
    case flow do
      {:error, error} -> {:error, error}
      _ -> check_and_process_cache(flow)
    end
  end

  defp check_and_process_cache(flow) do
    case Cachex.exists?(:diff_cache, "v0") do
      {:ok, false} ->
        Logger.info("mandando")
        Task.async(fn -> Cachex.put(:diff_cache, "v0", putting_on_cache(flow)) end)

        Logger.info("contando")
        count = Flow.map(flow, & &1.email) |> Enum.count()
        Logger.info("contei")
        {:ok, mapping_result(0, 0, count)} # 3s

      {:ok, true}  -> proc_diff(flow)
      {:error, _} -> {:error, "No cache found"}
    end
  end

  defp putting_on_cache(flow) do
    flow
    |> Flow.map(& &1.email)
    |> MapSet.new()
  end

  defp proc_diff(flow) do
    Logger.info("pegando")
    old = Cachex.get!(:diff_cache, "v0")
    Logger.info("peguei")

    Logger.info("montando novo")
    new = putting_on_cache(flow) # 3s
    Logger.info("feito novo")

    keepers = MapSet.intersection(old, new)
    Logger.info("intersec keepers")

    leavers = MapSet.difference(old, keepers)
    Logger.info("diff leavers")

    newcomers = MapSet.difference(new, keepers)
    Logger.info("diff newcomers")

  Logger.info("contando")
  {:ok, mapping_result(MapSet.size(leavers), MapSet.size(keepers), MapSet.size(newcomers))}
  end

  defp mapping_result(l,k,n) do
    %{leavers: l, keepers: k, newcomers: n}
  end
end

# Benchee.run(%{"flow" => fn -> DataDiff.ingest("public/1KK_V0.csv") end })
# DataDiff.ingest("public/1KK_V0.csv")

