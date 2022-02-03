# Doc: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config

workers Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })

max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS") { 5 })
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS") { max_threads_count })
threads min_threads_count, max_threads_count

preload_app!

rackup      DefaultRackup

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
