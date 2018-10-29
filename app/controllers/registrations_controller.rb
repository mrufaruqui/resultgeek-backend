class RegistrationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_registration, only: [:show, :update, :destroy]
  

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.where(exam_uuid:@exam.uuid)
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:exam, :student, :student_type, :course_list)
    end
end
