set :user, 'pete'
set :server, 'myquotable.com'
set :application, "myquotable"
set :repository,  "pete@xuxa.local:/var/git/myquotable.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :use_sudo, false
set :group_writable, false
set :rails_env, "production"


ssh_options[:paranoid] = false


role :app, server
role :web, server
role :db,  server, :primary => true

task :restart, :roles => :app do
end

task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end

namespace :deploy do
  after "deploy:update", "deploy:railsplayground:fix_permissions", "deploy:railsplayground:kill_dispatch_fcgi"
    
  desc <<-DESC
    Site5 version of restart task.
  DESC
  task :restart do
    site5::kill_dispatch_fcgi
  end
  
  namespace :railsplayground do
    
    desc <<-DESC
      Kills Ruby instances on RailsPlayground
    DESC
    task :kill_dispatch_fcgi do
      run "pkill -9 -u #{user} -f dispatch.fcgi"
    end
    
    desc "Fix g-w issues with Site5"
    task :fix_permissions do
      run "cd #{current_path}; chmod -R g-w *"
    end
  end
end