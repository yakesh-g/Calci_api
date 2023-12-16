defmodule CalciApiWeb.CalculatorHistoryController do
  use CalciApiWeb, :controller
  alias CalciApi.CalculatorHistory

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    case CalculatorHistory.list_history(current_user.id) do
      {:ok, history} ->
        conn
        |> put_status(:ok)
        |> json(history)

      {:error, _} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "History not found"})
    end
  end
end
