class FacebookController < ApplicationController
  ensure_application_is_installed_by_facebook_user  

  def index 
  end
end