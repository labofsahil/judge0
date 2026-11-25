# judge0 Performance Optimization — Before/After Report

Load: wrk, 4 threads, 64 connections, 15s per endpoint, localhost.
"Before" = baseline captured on the original code (`bench/baseline-*.txt`).
"After" = same scenarios on the optimized build (`bench/after-*.txt`).

## Throughput (req/s)

| Endpoint            | Before | After  | Change           |
|---------------------|-------:|-------:|------------------|
| GET /languages      |  84.18 | 175.05 | **+108% (2.1x)** |
| GET /statuses       | 158.55 | 184.84 | **+17%**         |
| GET /submissions    |  70.50 | 153.42 | **+118% (2.2x)** |
| POST /submissions   |  80.93 |  64.32 | -21% (see note)  |

## p99 latency

| Endpoint            | Before    | After     | Change     |
|---------------------|-----------|-----------|------------|
| GET /languages      | 1.62s     | ~0.55s    | ~3x better |
| GET /statuses       | 941ms     | ~0.50s    | ~2x better |
| GET /submissions    | 1.83s     | ~0.60s    | ~3x better |
| POST /submissions   | 1.78s     | ~0.70s    | ~2.5x better|

Note on POST /submissions: the baseline POST run hit the DB with no
`language_id` validation passing (invalid language id 46 — the languages
table was unseeded), so most baseline requests failed fast with 422.
The "after" POST run creates **real, persisted submissions** (valid
base64 payload, seeded languages, queued to Sidekiq), doing strictly more
work per request: full validation, insert, and queue enqueue at 64 req/s
with better p99. Throughput is not directly comparable; per-request work
is not equivalent.

## What changed to get here

1. **Queue**: Resque → Sidekiq 7.3 (multi-threaded workers; `scripts/workers`,
   `config/initializers/sidekiq.rb`, ActiveJob adapter `:sidekiq`).
2. **Caching**: Redis-backed cache with TTL for GET /languages,
   /languages/all, /statuses (cache warmed on first hit).
3. **JSON**: Oj with `Oj.optimize_rails`.
4. **Ruby**: `.ruby-version` 3.4.13, YJIT enabled in Dockerfile/entrypoint.
5. **Puma**: `preload_app!`, backlog=2048 on bind, 8 threads, DB pool
   disconnect in `before_fork` (CoW-friendly forking).
6. **Removed**: resque, pry dev gems.

## Verification

- `bundle exec rspec` → **20 examples, 0 failures** (after all changes).
- Live smoke: GET /submissions, /languages, /statuses → 200; POST
  /submissions creates a real submission row and queues IsolateJob.

Caveat: both runs are on the same small VM, single Puma process, and the
sandbox introduces socket timeouts under 64 connections; the relative
gains are the signal, not the absolute numbers.
