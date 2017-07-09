# TruLockApi

Elixir REST API for TruLock Chrome Extension.
TruLock let's you lock important and personal
websites with face recognition authentication.

# Before running the Server

`> make deps`

`> make compile`

# Running the Server

`> make server`

Server will be available at http://localhost:4000

# Endpoints

##### api/enroll

- request example: `{email: email, entity_id: entity_id, image: image_binary}`

- response examples:

  Success: `{email: email, entity_id: entity_id, image_count: image_count}`

  Failure: `{error: msg}`

- response codes:

  - `201`
  - `422`

##### api/authenticate

- request example: `{email: email, entity_id: entity_id, image: image}`

- response examples:

  Success: `{email: email, entity_id: entity_id, image_count: image_count}`

  Failure: `{error: msg}`

- response codes:

  - `200`
  - `401`
  - `403`
  - `422`

## Contributing

1. Fork it (https://github.com/[my-github-username]/tru_lock_api/fork)
2. Create your feature branch (`git checkout -b feature/my_new_feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Special Thanks To:

- @nchafni for all the support.
