WebCal::Application.routes.draw do
  resources :timeperiods

  match '/calendars(/:year(/:month))' => 'calendars#index', 
  :as => :calendars, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  resources :calendars
  resources :alternatives
  
  match 'users/profile' => 'users#profile', :as=>:user_profile
  match 'users/find_friends' => 'users#find_friends', :as => :user_find_friends
  match 'users/find_events' => 'users#find_events', :as => :user_find_events
  match 'users/friends' => 'users#friends', :as => :user_friends
  
  resources :friendships do
	collection do
		get :friend_requests, :users_list
		post :approve, :ignore, :users_list
  	end
  end
  
  resources :events do
    collection do
      get :invite_friend, :show_calendar
      post :add_timeperiods
    end
  end

  resources :posts

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",
                                      :registrations => 'registrations',
                                      :sessions => 'sessions'}

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
  root :to => 'friendships#users_list' 
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
