Rails.application.routes.draw do
  resources :exams
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :visitors
end
