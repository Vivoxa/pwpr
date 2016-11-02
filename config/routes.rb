
Rails.application.routes.draw do
  devise_for :company_operators, controllers: { registrations: 'company_operators/registrations', :invitations => 'company_operators/invitations' }
devise_scope :company_operator do
  get '/company_operators/invitation/update_businesses' => 'company_operators/invitations#update_businesses', as: 'update_businesses'
  get '/company_operators/pending' => 'company_operators#pending', as: 'pending_company_operators'
  get '/company_operators/update_businesses' => 'company_operators#update_businesses'
  get '/company_operators/invitations/', to: 'company_operators#invited_not_accepted', :as => 'company_operator_invitations'
end

devise_for :admins, controllers: { registrations: 'admins/registrations' }

devise_for :scheme_operators, controllers: { registrations: 'scheme_operators/registrations', :invitations => 'scheme_operators/invitations' }
devise_scope :scheme_operator do
  get '/scheme_operators/invitations/', to: 'scheme_operators#invited_not_accepted', :as => 'scheme_operator_invitations'
end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # resources :welcomes, only: :index

  # You can have the root of your site routed with "root"
  root 'visitors#index'

  resources :schemes, :businesses
  resources :scheme_operator_invitations, only: :index

  resources :admins, :scheme_operators, :company_operators do
    get 'permissions', action: :permissions
    put 'update_permissions', action: :update_permissions
  end

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
