Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :file, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  resources :questions, concerns: [:votable] do
    resources :comments, only: :create
    resources :answers, shallow: true, concerns: [:votable] do
      resources :comments, only: :create
      patch :best, on: :member
    end
  end
end
