#!/usr/bin/env puma

# start puma with:
#bundle exec puma -e production -C config/puma.rb
#bundle exec pumactl --state tmp/sockets/puma.state stop
#bundle exec pumactl --state tmp/sockets/puma.state restart

railsenv = 'production'
app_path = '/home/rb/work/pgate_admin/'
threads 2, 32 # minimum 2 threads, maximum 64 threads
workers 2

directory "#{app_path}/current"
environment railsenv
pidfile "#{app_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{app_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect "#{app_path}/log/puma-#{railsenv}.stdout.log", "#{app_path}/log/puma-#{railsenv}.stderr.log"

bind "unix://#{app_path}/tmp/sockets/#{railsenv}.socket"
worker_timeout 60
daemonize true
on_restart do
  puts '...On restart...'
end
preload_app!
