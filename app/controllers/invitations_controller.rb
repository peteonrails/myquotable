class InvitationsController < ApplicationController
  layout 'facebook'
  
  def new 
    update_profile if should_update_profile?
    @from_user_id = facebook_session.user.to_s  
  end
  
  def create 
    @sent_to_ids = params[:ids]  
  end
  
  def should_update_profile?
    params[:from]
  end
  
  def update_profile
    @user = facebook_session.user 
    @user.profile_fbml = render_to_string(:partial => "profile", :locals => {:from => params[:from], :user => @user})
  end
end
