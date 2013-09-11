set :application, "rails101"
set :domain, "ec2-54-248-145-123.ap-northeast-1.compute.amazonaws.com"
set :repository,  "git@github.com:ascendbruce/rails101_practice.git"
set :deploy_to, "/home/apps/rails101"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :deploy_via, :remote_cache
set :deploy_env, "production"
set :rails_env, "production"
set :scm, :git
set :branch, "master"
set :scm_verbose, true
set :use_sudo, false
set :user, "apps"
set :group, "apps"

default_environment["PATH"] = "/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

namespace :deploy do
  desc "restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "link database.yml from shared folder"
after("deploy:finalize_update") do
  db_config = "#{shared_path}/config/database.yml"
  run "ln -s #{db_config} #{release_path}/config/database.yml"
end


#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

