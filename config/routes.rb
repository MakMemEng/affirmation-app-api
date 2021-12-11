Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users

      # auth_token
      resources :auth_token, only:[:create] do
        post :refresh, on: :collection
        delete :destroy, on: :collection
      end

      # affirmation_post
      resources :post, only:[:index, :create]

    end
  end
end
