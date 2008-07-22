class TagsController < ApplicationController
  
  before_filter :find_user

  def index
  end
  
  # GET /users/:user_id/tags/:id
  def show
    
  end
  
  
  private
  def find_user
    @user = User.find(params[:user_id])
  end
  
end
