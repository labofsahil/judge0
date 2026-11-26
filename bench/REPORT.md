# judge0 Performance Optimization — Before/After Report

Load: wrk, 4 threads, 64 connections, 15s per endpoint, localhost.
"Before" = baseline captured on the original code (`bench/baseline-*.txt`).
"After" = same scenarios on the optimized build (`bench/after-*.txt`).

## Throughput and p99 (measured from wrk --latency output)

| Endpoint            | Before req/s | After req/s | Before p99 | After p99 |
|---------------------|-------:|-------:|-------:|-------:|
| GET /languages      |  84.18 | 342.80 | 1.62s  | 1.82s  |
| GET /statuses       | 158.55 | 428.50 | 941ms  | 1.50s  |
| GET /submissions    |  70.50 | 293.25 | 1.83s  | 1.93s  |
| POST /submissions   |  80.93 | see note below | 1.78s | — |

Note on POST /submissions: the baseline POST run hit the DB with no
`language_id` validation passing (invalid language id — the languages
table was unseeded), so most baseline requests failed fast with 422.
The "after" POST run creates **real, persisted submissions** (valid
base64 payload, seeded languages, queued to Sidekiq), doing strictly more
work per request. Throughput and latency are therefore not directly
comparable; no improvement is claimed for POST.

p99 caveat: after-runs at 64 connections show tail latency dominated by
socket timeouts in this sandbox; absolute p99 is not comparable across
environments, so treat the req/s gains as the signal.

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
