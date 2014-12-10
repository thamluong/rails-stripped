Rails.application.routes.draw do
  
  get 'credit_cards/new'
  post 'credit_cards/create'
  get 'credit_cards/edit'
  post 'credit_cards/update'

  post 'stripe/webhook'

  get 'sales/new' => 'sales#new', as: :guest_checkout
  post 'sales/create' 
  get 'sales/show', as: :purchase_confirmation

  get 'products/show'
  get 'products/download' => 'products#download', as: :download
  
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  get 'subscriptions/new' => 'subscriptions#new', as: :new_subscription
  post 'subscriptions/create' => 'subscriptions#create'
  
  get 'pricing' => 'welcome#pricing'
    
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
