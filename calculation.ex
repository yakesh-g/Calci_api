defmodule CalciApi.Calculation do
  use Ecto.Schema
  import Ecto.Changeset
  alias CalciApi.Repo

  @derive {Jason.Encoder, only: [:id, :user_id, :operation, :operand1, :operand2, :result, :inserted_at]}

  schema "calculation" do
    field :user_id, :integer
    field :operation, :string
    field :operand1, :float
    field :operand2, :float
    field :result, :float
    field :timestamp, :utc_datetime_usec  # Use :utc_datetime_usec for Ecto 3.6+

    timestamps()
  end

  #def list_history(user_id) do
    #query = from(c in CalciApi.CalculatorHistory, where: c.user_id == ^user_id)

    #case Repo.all(query) do
      ##[] -> {:error, nil}
      #history -> {:ok, history}
    #end
  #end
  @required_fields ~w(user_id operation operand1 operand2 result)a
  @optional_fields ~w()a

  def create(attrs \\ %{}) do
    %CalciApi.Calculation{}
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> Repo.insert()
  end
end
