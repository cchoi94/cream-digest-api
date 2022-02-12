require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users,
    defaults: {format: :json},
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resource :users, only: [] do
        member do
          get :show
          put :update
          delete :destroy
          post :update_user_password
          post :forgot_password
          post :check_reset_password_token
          post :reset_password
        end
      end
      resources :integrations
      get "/get_oauth_url", to: "integrations#get_oauth_url"
      get "/test_qt/:id", to: "integrations#test_qt"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
