app_dir = "/app"
worker_processes 10
working_directory app_dir

# Load app into the master before forking workers for super-fast
# worker spawn times
preload_app true

# nuke workers after 60 seconds (the default)
timeout 60

# listen on a Unix domain socket and/or a TCP port,

listen "/unicorn/socket"
pid "/unicorn.pid"

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

after_fork do |server, worker|
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket
end
