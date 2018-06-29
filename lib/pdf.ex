defmodule PDF do
  def source(file) when is_binary(file) do
    %PDF.Source{path: file}
  end

  def content(%PDF.Source{path: path}) do
    content =
      path
      |> File.read!()

    %PDF.Source{content: content}
  end
end
