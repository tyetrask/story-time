StoryTime::Application.routes.draw do
  devise_for :users
  
  root to: "timing#index"
  
  resources :page, only: [:index]
  
  resources :reports, only: [:index]
  
  resources :story_interface, only: [] do
    collection do
      get ':resource_interface/me', to: 'story_interface#me'
      get ':resource_interface/my_notifications', to: 'story_interface#my_notifications'
      get ':resource_interface/projects', to: 'story_interface#projects'
      get ':resource_interface/projects/:project_id/epics', to: 'story_interface#epics'
      get ':resource_interface/projects/:project_id/iterations', to: 'story_interface#iterations'
      get ':resource_interface/projects/:project_id/my_work', to: 'story_interface#my_work'
      get ':resource_interface/projects/:project_id/stories', to: 'story_interface#stories'
      get ':resource_interface/projects/:project_id/stories/:story_id', to: 'story_interface#story'
    end
  end
  
  resources :timing, only: [:index]
  
  resources :users do
    collection do
      get :me
    end
  end
  
  resources :work_time_units
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
