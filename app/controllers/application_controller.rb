class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  protected
  def get_tenant
    @session = Session.find_by(uuid:current_user.session_uuid)
    @exam = Exam.find_by(uuid: @session.exam_uuid) 
    @exam 
  end

  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:exam_uuid, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:exam_uuid, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit( :exam_uuid, :email, :password, :password_confirmation, :current_password) }
  end

end
