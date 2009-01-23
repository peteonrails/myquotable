class SiteController < ApplicationController
  # controller for site pages like "About", "How It Works", "Contact Us", etc.
  layout 'facebook'
  
  def index
    @quotes = Quote.public.recent(14.days.ago).descending

    respond_to do |format|
      format.html { @quotes = @quotes.paginate(:page => params[:page]) }
      format.xml  { render :xml => @quotes }
      format.rss
    end
  end

  def popular 
    @quotes = Quote.public.tally({:at_least => 1, :at_most => 10000})
    
    respond_to do |format|
      format.html {
        # will paginate will not work here, so hack it in
        @quotes = @quotes.paginate(:page => params[:page])
      }
      format.xml  { render :xml => @quotes }
      format.rss 
    end
    
  end
  
end
