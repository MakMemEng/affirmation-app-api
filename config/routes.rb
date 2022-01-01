Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users

      # auth_token
      resources :auth_token, only:[:create] do
        post :refresh, on: :collection
        delete :destroy, on: :collection
      end

      # affirmation_posts
      resources :posts, only: [:index, :create, :destroy, :update] do
        delete :destroy, on: :collection
        # comment
        resources :comments, only: [:index, :create, :destroy] do
          delete :destroy, on: :collection
        end
      end


    end
  end
end
