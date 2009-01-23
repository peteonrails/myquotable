class InvitationsController < ApplicationController
  def new 
    @from_user_id = facebook_session.user.to_s  
  end
  
  def create 
    @sent_to_ids = params[:ids]  
  end
end
