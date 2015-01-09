Rails.application.routes.draw do
  
  get 'welcome/index'
  get 'welcome/help'

  get 'ads/show'
  get 'ads/show_leader'

  devise_for :users
  get 'worlds/settings/:id' => "worlds#settings", as: "world_settings"
  resources :worlds, except: ["show", "destroy"] do
    post 'aliases/match', as: "aliases"
    resources :aliases, except: ["show", "edit", "new", "create"]
    get 'aliases/edit/:id/:what' => 'aliases#edit', as: "edit_aliases"
    resources :characters
    get 'tags/index'
    post "events/update_happened"
    resources :events, except: ["show", "index", "create"]
    get "events/years"
    get "events/relative"
    get "events/in_year/:year" => "events#months", as: "events_months"
    get "events/(:this_year)" => "events#index", as: "events"
    post "events" => "events#create"
  end

  post "events/valid_date"
  
  post 'tinymce_assets' => 'media#create'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
