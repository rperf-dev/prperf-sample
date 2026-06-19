# Sends one request through the full Rails stack, many times, under rperf.
# Each iteration does identical work (fixed in-memory data, no rand/time/DB),
# so the allocation and GC counts are deterministic and a regression is exact.
require_relative "../config/environment"
require "rack/mock"

app  = Rails.application
PATH = ENV.fetch("BENCH_PATH", "/report")        # the endpoint to measure
make = -> { Rack::MockRequest.env_for(PATH, "HTTP_HOST" => "localhost") }
pump = ->(result) { body = result[2]; body.each { |_| }; body.close if body.respond_to?(:close) }

10.times    { pump.call(app.call(make.call)) }   # warm up: autoload, first-request caches
1_000.times { pump.call(app.call(make.call)) }   # the measured work
