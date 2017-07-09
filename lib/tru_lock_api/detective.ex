defmodule TruLockApi.Detective do
  def validate(%{email: ""}), do: {:error, %{error: "email can't be blank"}}
  def validate(%{entity_id: ""}), do: {:error, %{error: "entity_id can't be blank"}}
  def validate(%{image: ""}), do: {:error, %{error: "image can't be blank"}}
  def validate(%{email: _, entity_id: _, image: _} = params), do: {:ok, params}
  def validate(_), do: {:error, %{error: "invalid parameters"}}
end
