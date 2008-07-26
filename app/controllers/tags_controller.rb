class TagsController < ApplicationController
  
  before_filter :find_user
  layout "users"

  # Currently, we don't support editing, deleting, or updating tags. 
  # When we do, we must use this filter for access control. 
  #  before_filter :must_own_tag, :only => [:edit, :destroy, :update]
  
  # GET /users/:user_id/tags
  # GET /users/:user_id/tags.xml
  def index
    # render index.html    
  end
  
  # GET /users/:user_id/tags/:id
  # GET /users/:user_id/tags/:id.xml
  def show  
    @tag = Tag.find(params[:id])
    @quotes = Quote.find_tagged_with(@tag.name)
  end

  # PUT /users/:user_id/tags/:id
  # PUT /users/:user_id/tags/:id.xml
  def update
    @tag = Tag.find(params[:id])
    
    respond_to do |format|
      if @tag.update_attributes(params[:name])
        flash[:notice] = 'Quote was successfully updated.'
        format.html { redirect_to([@user, @tag]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /users/:user_id/tags
  # POST /users/:user_id/tags.xml
  def create
  end
  
  # GET /users/:user_id/tags/new
  # GET /users/:user_id/tags/new.xml
  def new
    # render new.html
  end
  
  # GET /users/:user_id/tags/:id/edit
  def edit
    @tag = Tag.find(params[:id])
  end
  
  # DELETE /users/:user_id/tags/:id
  # DELETE /users/:user_id/tags/:id.xml
  def delete
  end
  
  
  private
  def find_user
    @user = User.find(params[:user_id])
  end
  
end
