ActionController::Routing::Routes.draw do |map|
  
  map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete } do |user|
    user.resources :votes
    user.resources :quotes do |quote|
      quote.resources :votes
    end
  end
  
  map.resource  :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.login  '/login',      :controller => 'sessions', :action => 'new'
  map.logout '/logout',     :controller => 'sessions', :action => 'destroy'
  map.signup '/signup',     :controller => 'users',    :action => 'new'
  map.activate '/activate', :controller => 'users',    :action => 'activate'
  map.activate_code '/activate/:activation_code', :controller => 'users', :action => 'activate'
 
  # Map the actions that are website-only and not restful
  map.with_options :controller => "site" do |site|
    site.root 
    site.popular '/popular', :action => "popular"
    site.about   '/about',   :action => "about"
    site.contact '/contact', :action => "contact"
    site.terms   '/terms',   :action => "terms"
    site.privacy '/privacy', :action => "privacy"
    site.api     '/api',     :action => "api"
  end

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
