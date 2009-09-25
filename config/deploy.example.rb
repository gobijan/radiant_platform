set :application, "application"
set :scm, :git
set :repository, "git://github.com/spanner/radiant_platform.git"
set :git_enable_submodules, 1
set :ssh_options, { :forward_agent => true }

set :user, 'user'
set :group, 'group'

role :web, "domain"
role :app, "domain"
role :db,  "domain", :primary => true

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
default_run_options[:pty] = true

after "deploy:setup" do
  sudo "mkdir -p #{deploy_to}/logs" 
  sudo "mkdir -p #{shared_path}/assets/icals" 
  sudo "mkdir -p #{shared_path}/assets/post_attachments" 
  sudo "mkdir -p #{shared_path}/assets/assets" 
  sudo "mkdir -p #{shared_path}/public" 
  sudo "mkdir -p #{shared_path}/config" 
  sudo "chown -R #{user}:#{group} #{shared_path}"
  sudo "chown #{user}:#{group} /var/www/#{application}/releases"
  sudo "ln -s #{shared_path}/config/nginx.conf /etc/nginx/sites-available/#{application}"   # for nginx on ubuntu
end

after "deploy:update" do
  run "ln -s #{shared_path}/config/database.yml #{current_release}/config/database.yml" 
  run "ln -s #{shared_path}/assets/assets #{current_release}/public/assets" 
  run "ln -s #{shared_path}/assets/post_attachments #{current_release}/public/post_attachments" 
  run "ln -s #{shared_path}/assets/icals #{current_release}/public/icals" 
  run "ln -s #{shared_path}/public/favicon.ico #{current_release}/public/favicon.ico"
  run "ln -s #{shared_path}/public/robots.txt #{current_release}/public/robots.txt"
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  task :stop, :roles => :app do
    # Do nothing.
  end
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  task :clear_cached_copy do
    run "rm -rf #{shared_path}/cached-copy"
  end
end
