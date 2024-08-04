Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


  constraints format: :json do
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :authors
        resources :courses
        resources :expertises

        resources :votes, only: [] do
          post :like, on: :collection
          post :dislike, on: :collection
          post :unlike, on: :collection
        end
      end
    end
  end
end
