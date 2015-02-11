set :rails_env, "staging"
set :unicorn_env, "staging"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :branch do
  raise "Use tags: TAG=v2" unless ENV['TAG']
  ENV['TAG']
end
set :user, 'nastachku_staging_2015'
set :keep_releases, 5
set :rvm_ruby_string, "2.0.0-p451"

role :web, '62.76.190.226'
role :app, '62.76.190.226'
role :db,  '62.76.190.226', :primary => true

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
