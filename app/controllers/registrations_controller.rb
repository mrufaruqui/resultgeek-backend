class RegistrationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_registration, only: [:show, :update, :destroy]
  

  # GET /registrations
  # GET /registrations.json
  def index
      @registrations = Registration.where(exam_uuid:@exam.uuid)
   if @registrations
      a = []
      @registrations.each do |r|
       retHash = Hash.new
       retHash[:id] = r.id
       retHash[:sl_no] = r.sl_no
       retHash[:roll] = r.student.roll
       retHash[:hall_name] = r.student.hall_name unless r.student.hall_name.blank?
       retHash[:name] = r.student.name.titlecase unless r.student.name.blank?
       retHash[:student_type] = r.student_type.titlecase unless r.student_type.blank?
       retHash[:courses] = r.course_list.split(";").join(",") unless r.course_list.blank?
       a << retHash
    end
      render json: a, status: "200 ok"
     else
      render json: @registrations.errors, status: :unprocessable_entity
    end 
    
  end


  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)

    if @registration.save
      render :show, status: :created, location: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    if @registration.update(registration_params)
      render :show, status: :ok, location: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    render json:  {status: true}
  end

   def register
    # options = {}
    # options[:student_info] = params[:file]
    # options[:exam] = @exam
    # Registration.register(options) unless params[:file].blank? 
     if !params[:file].blank?
      header = params[:file][0]
      body =   params[:file] - [header]
      body.each do |i| 
        row = Hash[[header, i].transpose].symbolize_keys
        student = Student.find_by(roll: row[:roll]) || Student.new
        student.roll = row[:roll]
        student.name = row[:name]
        student.hall_name = row[:hall_name]
        student.hall = row[:hall] 
        student.save
        registration = Registration.find_by(student_id: student.id, exam_uuid:@exam.uuid ) || Registration.new
        registration.exam = @exam
        registration.sl_no = row[:sl]
        registration.exam_uuid = @exam.uuid
        registration.student = student
        registration.student_type = row[:type].downcase.to_sym
        registration.course_list=row[:courses]
        registration.save
      end
        render json:  {status: true}
      else
        render json:  {status: false}
      end
    
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:id, :exam, :student, :student_type, :course_list)
    end
end
