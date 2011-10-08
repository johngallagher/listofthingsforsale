Things3::Application.routes.draw do
  get "pages/order_success"

  get "pages/order_failure"

  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :authentications

  get "pages/home"

  get "pages/pricing"

  get "pages/contact"

  get "pages/help"

  resources :email_orders

  devise_for :users, :controllers => { :registrations => "registrations", :confirmations => "confirmations", :sessions => "sessions" }

  resources :items
  
  match ':url' => 'shops#show', :constraints => { :url => /[a-z]{8,8}/ }
  match ':url/edit' => 'shops#edit', :constraints => { :url => /[a-z]{8,8}/ }
  
  match 'simple_cart/check_stock' => 'simple_cart#check_stock'
  match 'simple_cart/home' => 'simple_cart#home'
  match 'simple_cart/change' => 'simple_cart#change'
  resources :simple_cart
  
  
  match 'payment/ipn' => 'payment_notifications#ipn'
  
  
  resources :photos

  
  resources :shops do
    resources :items
  end
  
  # match 'shops/:id/take_live' => 'shops#take_live'
  
  resources :descriptions

  match 'edit' => 'shops#home_edit'

  match ':url' => 'shops#show', :constraints => { :url => /[a-z]{4,30}/ }
  match ':url/edit' => 'shops#edit', :constraints => { :url => /[a-z]{4,30}/ }

  # devise_for :users , :confirmations => "confirmations"
  # devise_for :users
  
  root :to => "shops#home"


  # The priority is based upon order of creation:
  # first created -> highest priority.

 
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
