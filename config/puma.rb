#!/usr/bin/env puma

# start puma with:
# bundle exec puma -e production -C path/to/your/app/config/puma.rb

application_path = '/home/rb/work/pgate_admin'
railsenv = 'production'
directory application_path
environment railsenv
daemonize true
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect
"#{application_path}/log/puma-#{railsenv}.stdout.log"
"#{application_path}/log/puma-#{railsenv}.stderr.log"
threads 0, 16
bind "unix://#{application_path}/tmp/sockets/#{railsenv}.socket"
