
Rails.application.routes.draw do
  devise_for :company_operators
  devise_for :admins
  devise_for :scheme_operators, controllers: { registrations: 'devise_overrides/registrations', :invitations => 'devise_overrides/scheme_operator_invitations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # resources :welcomes, only: :index

  # You can have the root of your site routed with "root"
  root 'visitors#index'

  resources :schemes
  resources :scheme_operator_invitations, only: :index

  resources :admins do
    get 'permissions' => 'admins#permissions'
    put 'update_permissions' => 'admins#update_permissions'
  end

  resources :scheme_operators do
    get 'permissions' => 'scheme_operators#permissions'
    put 'update_permissions' => 'scheme_operators#update_permissions'
  end

  resources :company_operators do
    get 'permissions' => 'company_operators#permissions'
    put 'update_permissions' => 'company_operators#update_permissions'
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
