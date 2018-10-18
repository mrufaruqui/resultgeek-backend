Rails.application.routes.draw do
  resources :summations
  resources :tabulations
  resources :exams
  resources :courses
  #root_url 'students#index'
  resources :customers
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   resources :students
   post 'import_students'                   => 'students#import' 
   post 'insert_marks'                      => 'summations#import' 
   post  'summations_by_course_id'    => 'summations#get_by_course_id'
end
