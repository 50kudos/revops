defmodule Revops.Repo do
  use Ecto.Repo,
    otp_app: :revops,
    adapter: Ecto.Adapters.Postgres
end
