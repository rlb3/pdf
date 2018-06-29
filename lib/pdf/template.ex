defmodule PDF.Template do
  def eval(%PDF.Source{path: path, content: nil} = source, assigns) do
    case File.read(path) do
      {:ok, content} ->
        %{source | content: content} |> eval(assigns)

      {:error, :enoent} ->
        %PDF.Template.Error{message: "File does not exist."}

      {:error, reason} ->
        %PDF.Template.Error{message: reason}
    end
  end

  def eval(%PDF.Source{content: content}, assigns) when is_binary(content) do
    EEx.eval_string(content, assigns)
  end
end
