defmodule TruLockApi.Router do
  use Plug.Router

  alias TruLockApi.{Store, Detective}

  plug :match
  plug :dispatch

  post "api/enroll" do
    {:ok, data, _conn} = read_body(conn)
    params = Poison.decode!(data, keys: :atoms)

    with validation = Detective.validate(params),
         {:ok, %{email: email, entity_id: entity_id, image: image}} <- validation,
         {:ok, factor_one_auth} <-  Store.hget(entity_id, email),
         %{collection: cid, enrollment: eid, image_count: img_count} <- factor_one_auth,
         {:ok, ^eid} <- TruFace.Workers.Detective.update([image], eid),
         {:ok, ^cid} <- TruFace.Workers.Detective.update_collection(eid, cid),
         {:ok, ^cid} <- TruFace.Workers.Detective.train(cid) do
      Store.hset(entity_id, email, %{factor_one_auth | image_count: img_count + 1})
      response =
        %{email: email, entity_id: entity_id, image_count: img_count + 1}
        |> Poison.encode!()
      send_resp(conn, 200, response)
    else
      {:error, %{reason: error}} ->
        error_response =
          %{error: error}
          |> Poison.encode!()
        send_resp(conn, 422, error_response)
      {:error, error} ->
        error_response =
          error
          |> Poison.encode!()
        send_resp(conn, 422, error_response)
      {:err, nil} ->
        with validation = Detective.validate(params),
             {:ok, %{email: email, entity_id: entity_id, image: image}} = validation,
             {:ok, enrollment_id} <- TruFace.Workers.Detective.enroll([image], email),
             {:ok, collection_id} <- TruFace.Workers.Detective.create_collection(email),
             {:ok, ^collection_id} <- TruFace.Workers.Detective.update_collection(enrollment_id, collection_id),
             {:ok, ^collection_id} <- TruFace.Workers.Detective.train(collection_id) do
          Store.hset(entity_id, email, %{collection: collection_id, enrollment: enrollment_id, image_count: 1})
          response =
            %{email: email, entity_id: entity_id, image_count: 1}
            |> Poison.encode!()
          send_resp(conn, 201, response)
        else
          {:error, %{reason: error}} ->
            error_response =
              %{error: error}
              |> Poison.encode!()
            send_resp(conn, 422, error_response)
        end
    end
  end

  post "api/authenticate" do
    {:ok, data, _conn} = read_body(conn)
    params = Poison.decode!(data, keys: :atoms)

    with validation = Detective.validate(params),
         {:ok, %{email: email, entity_id: entity_id, image: image}} <- validation,
         factor_one_auth = Store.hget(entity_id, email),
         %{collection: _cid, enrollment: eid, image_count: img_count} <- factor_one_auth,
         true <- img_count > 3,
         {:ok, avg_score} <- TruFace.Workers.Detective.match?(image, eid) do
      cond do
        avg_score >= 80 ->
          response =
            %{email: email, entity_id: entity_id, image_count: img_count}
            |> Poison.encode!()
          send_resp(conn, 200, response)
        avg_score < 80 ->
          response =
            %{error: "unable to authenticate"}
            |> Poison.encode!()
          send_resp(conn, 401, response)
      end
    else
      false ->
        error_response =
          %{error: "must be finish enrollment to authenticate"}
          |> Poison.encode!()
        send_resp(conn, 403, error_response)
      {:error, %{reason: error}} ->
        error_response =
          %{error: error}
          |> Poison.encode!()
        send_resp(conn, 422, error_response)
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
