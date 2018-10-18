class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    if @course.save
      render :show, status: :created, location: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    if @course.update(course_params)
      render :show, status: :ok, location: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
  end


  def import
    Course.import(params[:file]) unless params[:file].blank?
    render :index
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :code, :credit)
    end
end
