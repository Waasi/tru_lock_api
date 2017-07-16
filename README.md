# TruLockApi

Elixir REST API for TruLock Chrome Extension.
TruLock let's you lock important and personal
websites with face recognition authentication.

# Before running the Server

`> make deps`

`> make compile`

`> export TRUE_FACE_API_KEY=<your_api_key>`

# Running the Server

`> make server`

Server will be available at http://localhost:4000

# Deployment to Heroku

`> heroku create <your_app_name> --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"`

`> git push heroku master`

# Contributing

1. Fork it (https://github.com/[my-github-username]/tru_lock_api/fork)
2. Create your feature branch (`git checkout -b feature/my_new_feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# Special Thanks To:

- @nchafni for all the support.
