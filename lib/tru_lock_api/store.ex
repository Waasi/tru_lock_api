defmodule TruLockApi.Store do
  use Mem,

  worker_number:      2,
  default_ttl:        300,
  maxmemory_size:     "1000M",
  maxmemory_strategy: :lru,
  persistence:        false
end
