#!/usr/bin/env puma

# start puma with:
#bundle exec puma -e production -C config/puma.rb
#bundle exec pumactl --state tmp/sockets/puma.state stop
#bundle exec pumactl --state tmp/sockets/puma.state restart

railsenv = 'production'
application_path = '/home/rb/work/pgate_admin/current'
threads 2, 32 # minimum 2 threads, maximum 64 threads
workers 2

directory application_path
environment railsenv
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect "#{application_path}/log/puma-#{railsenv}.stdout.log", "#{application_path}/log/puma-#{railsenv}.stderr.log"

bind "unix://#{application_path}/tmp/sockets/#{railsenv}.socket"
worker_timeout 60
daemonize true
preload_app!
