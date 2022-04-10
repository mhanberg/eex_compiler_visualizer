defmodule EexCompilerViewer.Repo do
  use Ecto.Repo,
    otp_app: :eex_compiler_viewer,
    adapter: Ecto.Adapters.Postgres
end
