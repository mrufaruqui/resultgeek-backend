class SummationsController < ApplicationController
  before_action :set_summation, only: [:show, :update, :destroy]

  # GET /summations
  # GET /summations.json
  def index
    @summations = Summation.all
  end

  # GET /summations/1
  # GET /summations/1.json
  def show
  end

  # POST /summations
  # POST /summations.json
  def create
    @summation = Summation.new(summation_params)

    if @summation.save
      render :show, status: :created, location: @summation
    else
      render json: @summation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /summations/1
  # PATCH/PUT /summations/1.json
  def update
    if @summation.update(summation_params)
      render :show, status: :ok, location: @summation
    else
      render json: @summation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /summations/1
  # DELETE /summations/1.json
  def destroy
    @summation.destroy
  end

   def import
      data = params[:file]
      @course = Course.find_by(id: params[:course_id])
    if !@course.blank?
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header, i].transpose].symbolize_keys
        student = Student.find_by(roll: row[:roll]) || Student.create(:roll=>row[:roll])
        summation = Summation.find_by(student_id: student.id, course_id: @course.id) || Summation.new
        summation.student = student
        summation.course   = @course 
        
        
        if @course.course_type === "theory"
          puts "theory course"
          summation.assesment = row[:ct]
          summation.attendance = row[:ca]
          if row[:cact].blank?
              summation.cact = summation.marks.to_f + summation.assesment.to_f
          else
              summation.cact = row[:cact]
          end
          summation.section_a_marks = row[:marks_a]
          summation.section_b_marks = row[:marks_b]
          summation.section_a_code = row[:code_a]
          summation.section_b_code = row[:code_b]
          summation.marks = summation.section_a_marks.to_f + summation.section_b_marks.to_f
          summation.total_marks = summation.marks.to_f + summation.cact.to_f
        else
          puts "lab"
          summation.total_marks = row[:marks]
        end

        summation.percetage = (summation.total_marks.to_f / (@course.credit.to_f * 25.to_f)) * 100.to_f
        ret = calculate_grade(summation.percetage.to_f)
        summation.gpa = ret[:lg]
        summation.grade = ret[:ps]
        summation.save
      end  
     render :index
    else  
      render json: @course.errors, status: :unprocessable_entity
    end
  end
  def get_by_course_id
    c = Course.find_by(id:params[:id]);
    @summations = Summation.where(:course_id=>c.id)
    render :index
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_summation
      @summation = Summation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the whitce list through.
    def summation_params
      params.require(:summation).permit(:assesment, :attendance, :section_a_marks, :section_b_marks, :total_marks, :gpa, :grade)
    end

    def calculate_grade(p)
      retHash = {}
      if p >= 80 
        retHash[:ps] = 4.00
        retHash[:lg] = 'A+'
      elsif p >= 75 && p <80
        retHash[:ps] = 3.75
        retHash[:lg] = 'A'
      elsif p >= 70 && p < 75
        retHash[:ps] = 3.50
        retHash[:lg] = 'A-'
      elsif p >= 65 && p <70
        retHash[:ps] = 3.25
        retHash[:lg] = 'B+'
      elsif p >= 60 && p <65
        retHash[:ps] = 3.00
        retHash[:lg] = 'B'
      elsif p >= 55 && p <60
        retHash[:ps] = 2.75
        retHash[:lg] = 'B-'
      elsif p >= 50 && p <55
        retHash[:ps] = 2.50
        retHash[:lg] = 'C+'
      elsif p >= 45 && p <50
        retHash[:ps] = 2.25
        retHash[:lg] = 'C'
      elsif p >= 40 && p <45
        retHash[:ps] = 2.00
        retHash[:lg] = 'D'
      elsif p < 40
        retHash[:ps] = 0.00
        retHash[:lg] = 'F'
      else
        retHash[:ps] = 0.00
        retHash[:lg] = 'X'
      end
      retHash
    end
end