set :user, 'pete'
set :server, 'myquotable.com'

set :application, "myquotable"
set :repository,  "git@github.com:peteonrails/myquotable.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/pete/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :copy

set :use_sudo, false
set :group_writable, false
set :rails_env, "production"

role :app, "myquotable.com"
role :web, "myquotable.com"
role :db,  "myquotable.com", :primary => true

task :restart, :roles => :app do

end

task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end

namespace :deploy do
  after "deploy:update", "deploy:railsplayground:fix_permissions", "deploy:railsplayground:set_production" ,"deploy:railsplayground:kill_dispatch_fcgi"
    
  desc "RailsPlayground version of restart task."
  task :restart do
    railsplayground::kill_dispatch_fcgi
  end
 
  namespace :railsplayground do
    
    desc "Uncomment the RAILS_ENV setting"
    task :set_production do
      run "sed -i.cap.orig -e 's/^# ENV/ENV/' #{release_path}/config/environment.rb"
    end
    
    desc "Kills Ruby instances on RailsPlayground"
    task :kill_dispatch_fcgi do
      run "pkill -9 -u #{user} -f dispatch.fcgi"
    end
    
    desc "Fix g-w issues with RailsPlayground"
    task :fix_permissions do
      run "cd #{current_path}; chmod -R g-w *"
    end
  end
end