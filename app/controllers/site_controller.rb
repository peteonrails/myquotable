class SiteController < ApplicationController
  # controller for site pages like "About", "How It Works", "Contact Us", etc.
  
  def index
    @quotes = Quote.public.recent(1.day.ago)
  end
  
  
end
