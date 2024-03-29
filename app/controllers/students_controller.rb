class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
    render json: @students
  end

  # GET /students/1
  # GET /students/1.json
  def show
    render json: @student
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    if @student.save
      render :show, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    if @student.update(student_params)
      render json:  {status: true}, status: :ok, location: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    _status = @student.destroy
   render json:  {status: true}
  end

  def import
    Student.import(params[:file]) unless params[:file].blank? 
    render json:  {status: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      #params.fetch(:student, {})
      params.require(:student).permit(:roll, :hall, :hall_no, :name)
    end
end
