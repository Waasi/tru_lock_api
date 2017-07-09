defmodule TruLockApi.Router do
  use Plug.Router

  alias TruLockApi.{Store, Detective}

  plug :match
  plug :dispatch

  post "api/enroll" do
    {:ok, data, _conn} = read_body(conn)
    params = Poison.decode!(data, keys: :atoms)

    with validation = Detective.validate(:enrollment, params),
         {:ok, %{email: email, entity_id: entity_id, image: _}} <- validation,
         factor_one_auth = Store.hget(entity_id, email),
         %{collection: _, enrollment: _, image_count: img_count} <- factor_one_auth do
      Store.hset(entity_id, email, %{factor_one_auth | image_count: img_count + 1})
      response =
        %{email: email, entity_id: entity_id, image_count: img_count + 1}
        |> Poison.encode!()
      send_resp(conn, 200, response)
    else
      {:error, error} ->
        error_response =
          error
          |> Poison.encode!()
        send_resp(conn, 422, error_response)
      {:err, nil} ->
        validation = Detective.validate(:enrollment, params)
        {:ok, %{email: email, entity_id: entity_id, image: _image}} = validation
        Store.hset(entity_id, email, %{collection: "", enrollment: "", image_count: 1})
        response =
          %{email: email, entity_id: entity_id, image_count: 1}
          |> Poison.encode!()
        send_resp(conn, 201, response)
    end
  end

  post "api/authenticate" do
    {:ok, data, _conn} = read_body(conn)
    params = Poison.decode!(data, keys: :atoms)

    with validation = Detective.validate(:authentication, params),
         {:ok, %{email: email, entity_id: entity_id, image: _}} <- validation,
         factor_one_auth = Store.hget(entity_id, email),
         %{collection: _, enrollment: _, image_count: img_count} <- factor_one_auth,
         true <- img_count > 3 do
      response =
        %{email: email, entity_id: entity_id, image_count: img_count}
        |> Poison.encode!()
      send_resp(conn, 200, response)
    else
      false ->
        error_response =
          %{error: "must be finish enrollment to authenticate"}
          |> Poison.encode!()
        send_resp(conn, 403, error_response)
      {:error, error} ->
        error_response =
          error
          |> Poison.encode!()
        send_resp(conn, 422, error_response)
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
