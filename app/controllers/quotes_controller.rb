class QuotesController < ApplicationController

  before_filter :find_user
  before_filter :login_required, :only => [:new, :edit, :destroy, :create, :update]
  before_filter :must_own_quote, :only => [:edit, :destroy, :update]

  # GET /users/:id/quotes
  # GET /users/:id/quotes.xml
  def index
    @quotes = (current_user == @user) ? @user.quotes.descending : @user.quotes.public.descending

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
      format.rss
    end
  end

  # GET /users/:user_id/quotes/1
  # GET /users/:user_id/quotes/1.xml
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /users/:user_id/quotes/new
  # GET /users/:user_id/quotes/new.xml
  def new
    @quote = Quote.new
    @quote.quoted_by = "#{current_user.first_name} #{current_user.last_name}"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /users/:user_id/quotes/1/edit
  def edit 
    @quote ||= Quote.find(params[:id])
  end

  # POST /users/:user_id/quotes
  # POST /users/:user_id/quotes.xml
  def create
    @quote = Quote.new(params[:quote])
    @quote.user = current_user
    assign_tags_to_user
    
    respond_to do |format|
      if @quote.save
        flash[:notice] = 'Quote was successfully saved.'
        format.html { redirect_to([@user, @quote]) }
        format.xml  { render :xml => @quote, :status => :created, :location => @quote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/:user_id/quotes/1
  # PUT /users/:user_id/quotes/1.xml
  def update
    @quote = Quote.find(params[:id])
    assign_tags_to_user
    
    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        flash[:notice] = 'Quote was successfully updated.'
        format.html { redirect_to([@user, @quote]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:user_id/quotes/1
  # DELETE /users/:user_id/quotes/1.xml
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to(user_quotes_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_user 
    @user = User.find(params[:user_id])
  end
  
  # Hm. Controller is getting fat. Too many cookies.
  def assign_tags_to_user
    current_user.tag(@quote, :with => params[:quote][:tag_list], :on => :tags)
  end
  
  def must_own_quote
    @quote ||= Quote.find(params[:id])
    @quote.user == current_user || ownership_violation
  end
  
  def ownership_violation
    respond_to do |format|
      flash[:notice] = 'You cannot edit or delete quotes that you do not own!'
      format.html do
        redirect_to user_path(current_user)
      end
    end
  end
  
  
  
end
