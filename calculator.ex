defmodule CalciApi.Calculator do
  def add(a, b) do
    a + b
  end

  def subtract(a, b) do
    a - b
  end

  def divide(a, b) when b != 0 do
    a / b
  end

  def multiply(a, b) do
    a * b
  end

  def modulo(a, b) when b != 0 do
    rem(a, b)
  end
end
