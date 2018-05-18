defmodule PDFTest do
  use ExUnit.Case
  doctest PDF

  test "greets the world" do
    assert PDF.hello() == :world
  end
end
