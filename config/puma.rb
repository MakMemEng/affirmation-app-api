workers Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })

max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS") { 5 })
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS") { max_threads_count })
threads min_threads_count, max_threads_count

preload_app!

rackup      DefaultRackup
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT") { 3000 }
# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RACK_ENV") { "development" }

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }


# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

app_root = File.expand_path('..', __dir__)
bind "unix://#{app_root}/tmp/sockets/puma.sock"