class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  protected
  def get_tenant
      @tenant = Tenant.find_by(id: params[:exam_uuid])
      puts @tenant.exam_uuid

      if @tenant
         @exam = Exam.find_by(exam_uuid: @tenant.exam_uuid) 
      else
        @exam = Exam.last;
    end

    puts @exam.fullname
  end

end
