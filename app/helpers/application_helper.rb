# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def version
    "0.0.4 alpha #{RAILS_ENV}"  
  end
  
  def toggle_div(div) 
    update_page do |page| 
      page.visual_effect :toggle_slide, div
    end 
  end 

  def get_statusbar
    html = link_to('Home', root_path)
    
    
    html += case params[:controller]
      when "users": " " + 
        case params[:action]
          when "new": " -> New User "
          else get_login_breadcrumb + "quotes -> all (" + @user.quotes.count.to_s + ")"
        end
      when "site": " -> " + 
        case params[:action]
          when "index":   "Most Recent Member Quotes "
          when "popular": "Most Popular Member Quotes"
          when "about":   "About MyQuotable"
          when "contact": "Contact Us"
          when "privacy": "Privacy Policy"
          when "terms": "Terms of Use"
          else " "
        end
      when "tags": 	get_login_breadcrumb + "quotes -> tagged: " + @tag.name + "(" + @quotes.length.to_s + ")"
      when "quotes": get_login_breadcrumb + 
        case params[:action]
          when "new": "Adding a new quote (" + (@user.quotes.count + 1).to_s + ")"
          when "show": "Viewing quote"
          when "edit": "Editing quote"
          else " "
        end
      else " "
    end
    
    html += " -- view "
  	html += link_to("popular", popular_path) + " " 
  	html += link_to("yours", user_path(current_user)) if logged_in?
  	html += " " + link_to("post a quote", new_user_quote_path(current_user)) if logged_in?
  	html
  end
  
  def get_login_breadcrumb
    " -> " + @user.login + " -> "
  end
    
end
