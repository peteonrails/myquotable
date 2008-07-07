class SiteController < ApplicationController
  # controller for site pages like "About", "How It Works", "Contact Us", etc.
  
  def index
    @quotes = Quote.public.recent(7.days.ago).descending
  end
  
end
