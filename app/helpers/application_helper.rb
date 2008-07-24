# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def version
    "0.0.2 alpha #{RAILS_ENV}"  
  end
  
  def toggle_div(div) 
    update_page do |page| 
      page.visual_effect :toggle_slide, div
    end 
  end 
  
end
