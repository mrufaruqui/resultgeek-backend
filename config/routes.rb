Rails.application.routes.draw do
  resources :course_workforces
  resources :tenants
  resources :registrations
  resources :workforces
  resources :teachers
  resources :students
  resources :summations
  resources :tabulations
  resources :exams
  resources :courses
  resources :docs
  resources :depts 

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  sessions:           'exam_sessions',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   post 'import_students'                   => 'students#import' 
   post 'download_file'                     => 'docs#download' 
   post 'register_students'                 => 'registrations#register' 
   post 'insert_marks'                      => 'summations#import' 
   post 'import_improvement_tabulations'    => 'tabulations#import_improvement' 
   post 'import_irregular_tabulations'      => 'tabulations#import_irregular' 
   post 'summations_by_course_id'           => 'summations#get_by_course_id'
   get 'process_result'                     => 'exams#process_result'
   get 'generate_tabulations_latex'         => 'exams#generate_tabulations_latex'
   get 'generate_tabulations_xls'           => 'exams#generate_tabulations_xls'
   get 'generate_gradesheets_latex'         => 'exams#generate_gradesheets_latex'
   get 'generate_summationsheets_latex'     => 'exams#generate_summationsheets_latex'
   get 'latex_to_pdf'                       => 'exams#latex_to_pdf'
   get 'reset_exam_result'                  => 'exams#reset_exam_result'
   post 'set_exam'                          => 'tenants#set_exam'
   post 'reset_exam'                        => 'tenants#reset_exam' 
   get '/'                                  => 'health_check#index'
end
