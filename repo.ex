defmodule CalciApi.Repo do
  use Ecto.Repo,
    otp_app: :calci_api,
    adapter: Ecto.Adapters.Postgres

  # Define custom functions for your repository, such as get_by/2

  #def get_by(queryable, conditions) do
    #from q in queryable, where: ^conditions, select: q
    #Repo.all(queryable, conditions)
  #end
end
