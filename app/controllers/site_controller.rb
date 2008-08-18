class SiteController < ApplicationController
  # controller for site pages like "About", "How It Works", "Contact Us", etc.
  
  def index
    @quotes = Quote.public.recent(14.days.ago).descending.paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @quotes }
      format.rss  
    end
  end

  def popular 
    @quotes = Quote.public.tally({:at_least => 1, :at_most => 10000 }).paginate(:page => params[:page])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @quotes }
      format.rss 
    end
    
  end
  
end
