Rails.application.routes.draw do
  resources :students do 
     collection do
        post :import
     end
  end
  resources :courses
  resources :exams
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :visitors
end
