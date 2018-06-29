defmodule PDFTest do
  use ExUnit.Case
  doctest PDF

  @sample "test/fixture/ocalog.tex.eex"
  @sample_content File.read!(@sample)
  @data ~S"""
  \hline
  \footnotesize\textbf{Vehicle Checked in By Officer} &
  \footnotesize\textbf{Printed Name of Driver} &
  \footnotesize\textbf{Firm or Employer} &
  \footnotesize\textbf{Vehicle License Plate Number} &
  \footnotesize\textbf{Arrival/POC Notification Time} &
  \footnotesize\textbf{Primary POC Name} &
  \footnotesize\textbf{Cargo Type} &
  \footnotesize\textbf{Employee Random} &
  \footnotesize\textbf{Search Completed by MSO} &
  \footnotesize\textbf{Entry Time} \\ \hline
  & Joe Smith & WingStop2 & & 01-03-18 14:10 & 352 Test2 & Wings2 & & 3 & 01-03-18 14:25  \\ \hline
  & Joe Smith & 352 WingstopWarehousePA2 & & 01-03-18 14:14 & 352 Warehouse\&PA2 & 352 WingsWarehousePA2 & & F & 01-03-18 15:42 \\ \hline
  & Joe Smith & 352 Wing1 & &  01-03-18 14:18 & Fabian 352Test1 & 352 Wings & & S & 01-03-18 14:25 \\ \hline
  & Joe Smith & 352 WingstopWarehouse1 & & 01-03-18 15:39 & 352 WarehouseTest1 & & 352 WingsWarehouse1 & F & 01-03-18 15:42   \\ \hline
  & Joe Smith & Area 51 & & Academy & Nuclear & & & & \\ \hline
  """

  test "Build source struct" do
    assert %PDF.Source{} = PDF.source(@sample)
  end

  test "Get content from source" do
    content =
      PDF.source(@sample)
      |> PDF.content()

    assert content == %PDF.Source{content: @sample_content}
  end

  test "Create pdf from templete with ports" do
    updated_content =
      @sample
      |> PDF.source()
      |> PDF.Template.eval(assigns: @data)

    port = Port.open({:spawn, "xelatex -output-directory=test/tmp"}, [:binary])
    myself = self()
    send(port, {myself, {:command, updated_content}})
    send(port, {myself, {:command, "\end"}})

    assert_receive {^port, {:data, data}}, 20_000
    assert data =~ ~r/This is XeTeX/
    send(port, {myself, {port, :close}})
  end

  test "Create pdf from templete with porcelain" do
    alias Porcelain.Process, as: Proc

    updated_content =
      @sample
      |> PDF.source()
      |> PDF.Template.eval(assigns: @data)

    proc =
      %Proc{pid: pid} =
      Porcelain.spawn_shell(
        "xelatex",
        in: :receive,
        out: {:send, self()}
      )

    Proc.send_input(proc, updated_content)
    Proc.send_input(proc, "\end")

    assert_receive {^pid, :data, :out, data}, 20_000
    assert data =~ ~r/This is XeTeX/
  end

  test "Template error" do
    "missing file"
    |> PDF.source()
    |> PDF.Template.eval(assigns: @data)
    |> case do
      %PDF.Template.Error{} -> assert true
      _ -> assert false
    end
  end

  test "PDF.Latex" do
    {:ok, latex} = DynamicSupervisor.start_child(PDF.Latex.Supervisor, PDF.Latex)

    source =
      @sample
      |> PDF.source()

    PDF.Latex.generate_pdf(latex, source, @data)
    pid = self()
    assert_receive {^pid, :pdf_done}, 20_000

    case PDF.Latex.write_pdf(latex, "asdf.pdf") do
      :ok ->
        assert File.exists?("asdf.pdf")

      _ ->
        assert false
    end
  end
end
