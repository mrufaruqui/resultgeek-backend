Rails.application.routes.draw do
  resources :workforces
  resources :teachers
  resources :students
  resources :summations
  resources :tabulations
  resources :exams
  resources :courses
  #root_url 'students#index'
  resources :customers
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   post 'import_students'                   => 'students#import' 
   post 'insert_marks'                      => 'summations#import' 
   post  'summations_by_course_id'    => 'summations#get_by_course_id'
   get 'process_result'             =>'exams#process_result'
   get 'generate_tabulations_latex'  =>'exams#generate_tabulations_latex'
   get 'generate_gradesheets_latex'  =>'exams#generate_gradesheets_latex'
   get 'generate_summationsheets_latex'  =>'exams#generate_summationsheets_latex'
   get 'reset_exam_result'               =>'exams#reset_exam_result'
      
end
