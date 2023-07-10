defmodule Phoenix.LiveView.UploadWriter do

  @callback init(opts :: term) :: {:ok, state :: term} | {:error, term}
  @callback meta(state :: term) :: map
  @callback write_chunk(data :: binary, state :: term) :: {:ok, state :: term} | {:error, term}
  @callback close(state :: term) :: {:ok, state :: term} | {:error, term}

  def init(_opts) do
    with {:ok, path} <- Plug.Upload.random_file("live_view_upload"),
         {:ok, file} <- File.open(path, [:binary, :write]) do
      {:ok, %{path: path, file: file}}
    end
  end

  def meta(state) do
    %{path: state.path}
  end

  def write_chunk(data, state) do
    case IO.binwrite(state.file, data) do
      :ok -> {:ok, state}
      {:error, reason} -> {:error, reason}
    end
  end

  def close(state) do
    case File.close(state.file) do
      :ok -> {:ok, state}
      {:error, reason} -> {:error, reason}
    end
  end
end