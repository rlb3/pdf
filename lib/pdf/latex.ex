defmodule PDF.Latex do
  use GenServer

  def child_spec(_arg) do
    %{
      id: PDF.Latex,
      start: {PDF.Latex, :start_link, []},
      restart: :transient
    }
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def generate_pdf(pid, %PDF.Source{} = source, assigns) do
    GenServer.call(pid, {:generate_pdf, source, assigns, self()})
  end

  def init(_args) do
    Temp.track!()
    {:ok, %{proc: nil, from: nil, pdf_binary: nil}}
  end

  def handle_call({:write_pdf, name}, _from, state) do
    result =
      case File.write(name, state[:pdf_binary]) do
        :ok -> :ok
        error -> error
      end

    {:reply, result, state}
  end

  def handle_call({:generate_pdf, source, assigns, from}, _from, state) do
    updated_content =
      source
      |> PDF.Template.eval(assigns: assigns)

    file_path = Temp.open!(%{prefix: "pdf-latex", suffix: ".tex"}, &IO.write(&1, updated_content))
    dir_path = Temp.mkdir!("pdf-latex")

    proc =
      Porcelain.exec(
        "xelatex",
        ["-output-directory=#{dir_path}", file_path]
      )

    file_data =
      dir_path
      |> Path.join(Path.basename(file_path, ".tex") <> ".pdf")
      |> File.read!()

    send(from, {from, :pdf_done})
    send(self(), :cleanup)
    {:reply, %{state | proc: proc, from: from, pdf_binary: file_data}, %{}}
  end

  def handle_info(:cleanup, state) do
    {:stop, :normal, state}
  end

  def terminate(_reason, _state) do
    Temp.cleanup()
    :ok
  end
end
