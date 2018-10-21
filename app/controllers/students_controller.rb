class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
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
    render json:  {status: _status}
  end

  def import
    # puts params[:file]
     
    # params[:file].each |student_p| do 
    # #   s = Student.new(student_p)
    # #   s.save
    # # end
    Student.import(params[:file]) unless params[:file].blank?
    #@students = Student.all
    render :index
    #redirect_to root_url, notice: 'Students imported.'
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
