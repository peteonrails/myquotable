class SiteController < ApplicationController
  # controller for site pages like "About", "How It Works", "Contact Us", etc.
  
  def index
    @quotes = Quote.public.recent(14.days.ago).descending

    respond_to do |format|
      format.html
      format.xml  { render :xml => @quotes }
    end
  end

  def popular 
    @quotes = Quote.public.popular
    
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml  { render :xml => @quotes }
    end
    
  end
  
end
