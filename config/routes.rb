StoryTime::Application.routes.draw do
  devise_for :users

  root to: "timing#index"

  resources :integrations, only: [:index, :create, :update, :destroy] do
    member do
      resources :external_resources, only: [] do
        collection do
          get :current__user # Double underscore to avoid interference with Devise current_user alias
          get :notifications
          get :projects
          get 'projects/:project_id/epics', to: 'external_resources#epics'
          get 'projects/:project_id/iterations', to: 'external_resources#iterations'
          get 'projects/:project_id/stories', to: 'external_resources#stories'
          get 'projects/:project_id/stories/:story_id', to: 'external_resources#story'
          patch 'projects/:project_id/stories/:story_id', to: 'external_resources#patch_story'
        end
      end
    end
  end

  resources :reports, only: []

  resources :timing, only: [:index]

  resources :users, only: [:index, :create, :update, :destroy] do
    collection do
      get :current__user # Double underscore to avoid interference with Devise current_user alias
    end
  end

  resources :work_time_units, only: [:index, :create, :update, :destroy]

end
