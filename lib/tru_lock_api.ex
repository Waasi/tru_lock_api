defmodule TruLockApi do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      TruLockApi.Store.child_spec,
      Plug.Adapters.Cowboy.child_spec(:http, TruLockApi.Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: TruLockApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
