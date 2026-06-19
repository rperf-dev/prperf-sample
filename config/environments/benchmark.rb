# A production-like environment that is easy to run in CI: eager-loaded (so the
# measurement isn't dominated by lazy autoloading) and free of SSL / host /
# master-key friction. Mirrors the "Rails quickstart" chapter of the prperf manual.
require_relative "production"

Rails.application.configure do
  config.eager_load = true            # load all app code up front, like production
  config.force_ssl = false            # no SSL redirects (they'd make the measurement empty)
  config.hosts.clear                  # accept the benchmark's mock Host
  config.require_master_key = false   # no credentials needed for this demo
  config.consider_all_requests_local = false
  config.log_level = :warn
end
