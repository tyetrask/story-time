StoryTime::Application.routes.draw do
  devise_for :users

  root to: "timing#index"

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
      patch ':resource_interface/projects/:project_id/stories/:story_id', to: 'story_interface#patch_story'
    end
  end

  resources :timing, only: [:index]

  resources :users do
    collection do
      get :me
    end
  end

  resources :work_time_units

end
