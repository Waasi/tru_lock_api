defmodule TruLockApi.Detective do
  def validate(:enrollment, %{email: _, entity_id: _, image: _} = params), do: {:ok, params}
  def validate(:authentication, %{email: _, entity_id: _, image: _} = params), do: {:ok, params}
  def validate(_, _), do: {:error, %{error: "invalid parameters"}}
end
