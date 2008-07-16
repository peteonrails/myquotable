# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def version
    "0.0.1 alpha #{RAILS_ENV}"  
  end
  
  def toggle_div(div) 
    update_page do |page| 
      page[div].toggle 
      page[div].visual_effect :highlight 
    end 
  end 
  
end
