class InvitationsController < ApplicationController
  def create 
    @sent_to_id = params[:ids]  
  end
end
