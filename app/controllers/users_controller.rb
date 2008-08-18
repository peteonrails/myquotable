class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :show, :edit]

  before_filter :login_required, :only => [:index, :update, :edit, :suspend, :unsuspend, :destroy, :purge]
  before_filter :must_be_this_user, :only => [:edit, :update]

  # render new.html.erb
  def new
    
  end

  # GET /users/:id
  def show

  end
  
  def edit
    
  end
  
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your profile was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def create
    @tags = { }

    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      self.current_user.forget_me if logged_in?
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    unless params[:activation_code].blank?
      self.current_user = User.find_by_activation_code(params[:activation_code])
      if logged_in? && !current_user.active?
        current_user.activate!
        flash[:notice] = "Signup complete!"
        redirect_back_or_default('/')
      else
        flash[:error] = "Sorry, we couldn't find that activation code. Please cut and paste your activation code into the space at left."
      end
    end
    # render activate.html.erb    
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  def find_user
    @user ||= User.find(params[:id])
  end

  def must_be_this_user
    find_user
    current_user == @user || access_denied
  end
  
  def access_denied
    flash[:errors] = "You are not authorized to edit that user! Here is your own profile. You can edit this one instead."
    RAILS_DEFAULT_LOGGER.info("Security violation: #{current_user[:login]} tried to edit #{@user.login}")
    redirect_to(edit_user_path(current_user))
  end
  
end
