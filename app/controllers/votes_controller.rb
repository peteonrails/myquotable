class VotesController < ApplicationController
  
  # First, figure out our nested scope. User or Quote? Important for presenting lists
  before_filter :find_votes_for_my_scope, :only => [:index]
     
  before_filter :login_required, :only => [:new, :edit, :destroy, :create, :update]
  before_filter :must_own_vote,  :only => [:edit, :destroy, :update]
  before_filter :not_allowed,    :only => [:edit, :update, :new]

  # GET /users/:user_id/votes/
  # GET /users/:user_id/votes.xml
  # GET /users/:user_id/quotes/:quote_id/votes/
  # GET /users/:user_id/quotes/:quote_id/votes.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /users/:user_id/votes/1
  # GET /users/:user_id/votes/1.xml
  # GET /users/:user_id/quotes/:quote_id/votes/1
  # GET /users/:user_id/quotes/:quote_id/1.xml
  def show
    @quote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /users/:id/votes/new      # INVALID
  # GET /users/:id/votes/new.xml  # INVALID
  # GET /users/:id/votes/new      # INVALID
  # GET /users/:id/votes/new.xml  # INVALID
  def new
  end

  # GET /users/:id/quotes/1/edit
  def edit
  end

  # POST /users/:user_id/quotes/:quote_id/votes
  # POST /users/:user_id/quotes/:quote_id/votes.xml
  def create
    @quote = Quote.find(params[:quote_id])
    
    respond_to do |format|
      if current_user.vote(@quote, params[:vote])
        format.rjs  { render :action => "create", :vote => @vote }
        format.html { redirect_to([@quote.user, @quote]) }
        format.xml  { render :xml => @quote, :status => :created, :location => @quote }
      else
        format.rjs  { render :action => "error" }
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/:id/votes/1
  # PUT /users/:id/votes/1.xml
  def update
  end
  
  # DELETE /users/:id/votes/1
  # DELETE /users/:id/votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(user_votes_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_votes_for_my_scope
    if params[:quote_id]
      @votes = Vote.for_voteable(Quote.find(params[:quote_id])).descending
    elsif params[:user_id]
      @votes = Vote.for_voter(User.find(params[:user_id])).descending         
    else  
      @votes = []
    end
  end

  def must_own_vote
    @vote ||= Vote.find(params[:id])
    @vote.user == current_user || ownership_violation
  end

  def ownership_violation
    respond_to do |format|
      flash[:notice] = 'You cannot edit or delete vote that you do not own!'
      format.html do
        redirect_to user_path(current_user)
      end
    end
  end

end
