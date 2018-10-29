class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  protected
  def get_tenant
    #   @tenant = Tenant.find_by(id: params[:exam_uuid])
    #   puts @tenant.exam_uuid

    #   if @tenant
    #      @exam = Exam.find_by(exam_uuid: @tenant.exam_uuid) 
    #   else
    #     @exam = Exam.last;
    # end
    puts "current_user"
    puts current_user.id
    puts current_user.exam_uuid
    @exam = Exam.find_by(uuid: current_user.exam_uuid)  
    puts @exam.fullname
    @exam 
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:exam_uuid, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:exam_uuid, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit( :exam_uuid, :email, :password, :password_confirmation, :current_password) }
  end

end
