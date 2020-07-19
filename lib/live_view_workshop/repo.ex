defmodule LiveViewWorkshop.Repo do
  use Ecto.Repo,
    otp_app: :live_view_workshop,
    adapter: Ecto.Adapters.Postgres
end
