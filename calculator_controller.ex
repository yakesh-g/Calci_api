defmodule CalciApiWeb.CalculatorController do
  use CalciApiWeb, :controller

  import Guardian.Plug
  import Phoenix.Controller
  import Plug.Conn
  import Ecto.Query, only: [from: 2, where: 2, order_by: 3, desc: 1]
  alias CalciApi.{Calculator, Repo, User, Calculation}

  import Float, only: [parse: 1]

  def decode_bearer_token(token) do
    try do
      payload = Phoenix.JWT.verify(CalciApiWeb.Endpoint, @salt, token, max_age: @max_age)
      payload
    rescue
      _ -> nil
    end
  end

  def get_username(token) do
    payload = decode_bearer_token(token)
    payload["username"] || nil
  end

  def add(conn, %{"a" => a, "b" => b}) when is_number(a) and is_number(b) do
    IO.inspect({a, b}, label: "Received values for addition")
    #conn = Plug.Guardian.Plug.EnsureAuthenticated.call(conn)
    result = Calculator.add(a, b)
    save_calculation(conn, result, "addition", a, b)
  end

  def add(conn, _params) do
    send_resp(conn, 400, "Bad Request: 'a' and 'b' must be integers.")
  end

  def subtract(conn, %{"a" => a, "b" => b}) do
    result = Calculator.subtract(a, b)
    save_calculation(conn, result, "subtraction", a, b)
  end

  def subtract(conn, _params) do
    send_resp(conn, 400, "Bad Request: 'a' and 'b' must be integers.")
  end

  def multiply(conn, %{"a" => a, "b" => b}) do
    result = Calculator.multiply(a, b)
    save_calculation(conn, result, "multiplication", a, b)
  end

  def multiply(conn, _params) do
    send_resp(conn, 400, "Bad Request: 'a' and 'b' must be integers.")
  end

  def divide(conn, %{"a" => a, "b" => b}) when is_number(a) and is_number(b) and b != 0 do
    result = Calculator.divide(a, b)
    save_calculation(conn, result, "division", a, b)
  end

  def divide(conn, %{"a" => a, "b" => b}) when is_number(a) and is_number(b) and b == 0 do
    send_resp(conn, 400, "Bad Request: Division by zero is not allowed.")
  end

  def divide(conn, _params) do
    send_resp(conn, 400, "Bad Request: 'a' and 'b' must be integers.")
  end


 # defp get_user_id(assigns) do
    #Map.get(assigns, :user_id, nil)
 # end

 defp save_calculation(conn, result, operation, operand1, operand2) do
  claims = conn.private.guardian_default_claims
  IO.inspect(claims, label: "Guardian Claims")

  current_user_id = Map.get(claims, "user_id")
  IO.inspect(current_user_id, label: "current user id")

  #case converted_user_id do
   # %{"user_id" => user_id} ->
    if !is_nil(current_user_id) do
      user_id = String.to_integer(current_user_id)
      IO.inspect(user_id, label: "user id")

      IO.inspect(result, label: "Result before rounding")

      #rounded_result = Float.round(result, 2)
      #rounded_result = round(result, 2)
      rounded_result = result

      # Assuming Calculation is a schema or module
      Calculation.create(%{
        user_id: user_id,
        operation: operation,
        operand1: operand1,
        operand2: operand2,
        result: rounded_result
      })

      conn
      |> put_status(:ok)
      |> json(%{result: rounded_result})

      else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "User unauthenticated"})
  end
end

  def fetch_history(conn, _params) do
    IO.inspect(conn, label: "Conn in fetch_history")
    IO.inspect(conn.private.guardian_default_claims, label: "Guardian Claims")
    # Retrieve user_id from Guardian claims
    current_user_id = conn.private.guardian_default_claims["user_id"]

    # Handle the case where user_id is nil or invalid
    if current_user_id do
      calculations =
        Repo.all(
          from(c in Calculation, where: c.user_id == ^current_user_id)
          |> order_by([c], [desc: c.inserted_at])
        )

      conn
      |> put_status(:ok)
      |> json(%{calculations: calculations})
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "User not authenticated"})
    end
  end
end
