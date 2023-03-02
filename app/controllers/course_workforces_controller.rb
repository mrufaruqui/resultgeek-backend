class CourseWorkforcesController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_course_workforce, only: [:show, :update, :destroy]

  # GET /course_workforces
  # GET /course_workforces.json
  def index
     @w =  CourseWorkforce.where(exam_uuid:@exam.uuid).includes(:teacher).includes(:course)

    if @w
      a = []
     @w.each do |w| 
      rethash = Hash.new
        rethash[:role] = w.role.titlecase unless w.role.nil?
        rethash[:status] = w.status
        rethash[:name] = w.teacher.display_name
        rethash[:designation]= w.teacher.designation.titlecase unless w.teacher.designation.nil?
        rethash[:email]= w.teacher.email
        rethash[:phone]= w.teacher.phone
        rethash[:dept_name]= w.teacher.dept.name
        rethash[:dept_code]= w.teacher.dept.code
        rethash[:inst_name]= w.teacher.dept.institute
        rethash[:inst_code]= w.teacher.dept.institute_code
        rethash[:course_code] = w.course.display_code
        rethash[:course_title] = w.course.title
      a << rethash
    end
      render json: a, status: "200 ok"
     else
      render json: @w.errors, status: :unprocessable_entity
    end 
  end

  # GET /course_workforces/1
  # GET /course_workforces/1.json
  def show
  end

  # POST /course_workforces
  # POST /course_workforces.json
  def create
    @course_workforce = CourseWorkforce.new(course_workforce_params)

    if @course_workforce.save
      render :show, status: :created, location: @course_workforce
    else
      render json: @course_workforce.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /course_workforces/1
  # PATCH/PUT /course_workforces/1.json
  def update
    if @course_workforce.update(course_workforce_params)
      render :show, status: :ok, location: @course_workforce
    else
      render json: @course_workforce.errors, status: :unprocessable_entity
    end
  end

  # DELETE /course_workforces/1
  # DELETE /course_workforces/1.json
  def destroy
    @course_workforce.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_workforce
      @course_workforce = CourseWorkforce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_workforce_params
      params.fetch(:course_workforce, {})
    end
end
