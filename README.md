# prperf-sample

A tiny Rails API app used as the live demo for
[**prperf**](https://prperf.atdot.net) — *Diff every Ruby PR's performance.*

It exposes one endpoint, `GET /report`, which builds a JSON summary of a fixed
in-memory catalog (no database, no randomness, no time — so every run does
identical work). `bench/request.rb` drives that endpoint through the full Rails
stack under [rperf](https://github.com/ko1/rperf), and
`.github/workflows/prperf.yml` runs it on every push to `main` (recording the
**base**) and every pull request (**compared** against the base).

The point of the demo: open a PR that makes
`app/services/report_builder.rb` allocate more, and prperf posts the base→PR
comparison on the GitHub Check Run — a higher `alloc`, a ⚠️ once it crosses the
`+5%` threshold, and a flamegraph diff showing exactly what got heavier. It
never blocks CI.

## Run it locally

```sh
bundle install
RAILS_ENV=benchmark SECRET_KEY_BASE=dummy bundle exec rperf stat -- ruby bench/request.rb
```

## Layout

| Path | What |
|---|---|
| `app/models/catalog.rb` | the fixed in-memory dataset |
| `app/services/report_builder.rb` | the code under test (a PR here moves the numbers) |
| `app/controllers/reports_controller.rb` | `GET /report` |
| `bench/request.rb` | the benchmark: one request through the stack, ×1000 |
| `config/environments/benchmark.rb` | production-like, CI-friendly env |
| `.github/workflows/prperf.yml` | runs the benchmark and uploads to prperf |
