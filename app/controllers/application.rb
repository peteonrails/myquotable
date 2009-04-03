# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '512895f12c9252685624eeb0584c2a9e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  ensure_application_is_installed_by_facebook_user    

<<<<<<< HEAD:app/controllers/application.rb
<<<<<<< HEAD:app/controllers/application.rb
  ensure_application_is_installed_by_facebook_user if params[:format] == "facebook"
  
=======
>>>>>>> c0523ec... Invitations:app/controllers/application.rb
=======
>>>>>>> c0523ec... Invitations:app/controllers/application.rb
end
