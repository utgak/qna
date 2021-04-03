Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :file, only: :destroy

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end
end
