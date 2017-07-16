defmodule TruLockApi do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      TruLockApi.Store.child_spec,
      Plug.Adapters.Cowboy.child_spec(:http, TruLockApi.Router, [], [port: port()])
    ]

    opts = [strategy: :one_for_one, name: TruLockApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def port do
    case System.get_env("PORT") do
      nil ->
        4000
      port_number ->
        String.to_integer(port_number)
    end
  end
end
