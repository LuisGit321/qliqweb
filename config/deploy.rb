require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :repository,  "git@git.assembla.com:qliqweb.git"
set :scm, :git

set :user, "deploy"
set :deploy_via, :remote_cache
set :use_sudo, false
set :stages, %w{dev staging prod}
set :base_path, "/home/#{user}"



namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after :deploy, "database:add_config", "deploy:restart"