class TabulationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_tabulation, only: [:show, :update, :destroy]

  # GET /tabulations
  # GET /tabulations.json
  def index
     @tabulation = generate_tabulations_view
     render :aggregate
  end

  # GET /tabulations/1
  # GET /tabulations/1.json
  def show
  end

  # POST /tabulations
  # POST /tabulations.json
  def create
    @tabulation = Tabulation.new(tabulation_params)

    if @tabulation.save
      render :show, status: :created, location: @tabulation
    else
      render json: @tabulation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tabulations/1
  # PATCH/PUT /tabulations/1.json
  def update
    if @tabulation.update(tabulation_params)
      render :show, status: :ok, location: @tabulation
    else
      render json: @tabulation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tabulations/1
  # DELETE /tabulations/1.json
  def destroy
    @tabulation.destroy
  end


  def import_improvement
      @courses = Course.where(exam_uuid:@exam.uuid)
      @student_type = :improvement
      Tabulation.where(exam_uuid:@exam.uuid, :record_type=>:previous, :student_type=>:improvement).destroy_all
      data = params[:file]
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header.map(&:downcase), i].transpose].symbolize_keys
        create_tabulation_row row  
      end  
     @status = ProcessingService.process_result_improvement({:exam=>@exam, :student_type=>:improvement, :record_type=>:temp})
     render :index
  end

  def import_irregular
      @courses = Course.where(exam_uuid:@exam.uuid)
      @student_type = :irregular
      Tabulation.where(exam_uuid:@exam.uuid, :record_type=>:previous, :student_type=>:irregular).destroy_all
      data = params[:file]
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header.map(&:downcase), i].transpose].symbolize_keys
        create_tabulation_row row
      end  
    #  @status = ProcessingService.process_result_irregular({:exam=>@exam, :student_type=>:irregular, :record_type=>:temp})
     render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tabulation
      @tabulation = Tabulation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tabulation_params
      params.require(:tabulation).permit(:student_roll, :gpa, :tce, :result, :remarks, :exam_uuid)
    end

    def generate_tabulations_view
        a = []
        @tab =  Tabulation.where(exam_uuid: @exam.uuid).order(:sl_no)
        @tab.each do |t| 
        s = Student.find_by(roll:t.student_roll)
        @retHash = Hash.new
        @retHash[:sl_no] = t.sl_no
        @retHash[:gpa] = '%.2f' % t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = '%.2f' % t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = s.roll
        @retHash[:name] = s.name
        @retHash[:hall] = s.hall_name;
        @retHash[:courses] = []
        tps = 0.0;
        t.tabulation_details.each do |td|
            course = Hash.new
            ps = ( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2)
            if td.summation.course.course_type === "lab"
               @retHash[td.summation.course.code + '_mo'] = td.summation.total_marks
               @retHash[td.summation.course.code + '_pr'] = td.summation.percetage
               @retHash[td.summation.course.code + '_lg'] = td.summation.gpa
               @retHash[td.summation.course.code + '_gp'] = td.summation.grade
               @retHash[td.summation.course.code + '_ps'] = ps 
            else
               @retHash[td.summation.course.code + '_cact'] = td.summation.cact
               @retHash[td.summation.course.code + '_fem'] = td.summation.marks
               @retHash[td.summation.course.code + '_mo'] = td.summation.total_marks
               @retHash[td.summation.course.code + '_pr'] = td.summation.percetage
               @retHash[td.summation.course.code + '_lg']  = td.summation.gpa
               @retHash[td.summation.course.code + '_gp'] = td.summation.grade
               @retHash[td.summation.course.code + '_ps'] = ps 
            end  
            tps += ps;
          #  @retHash[:courses] << course
        end
        @retHash[:tps] = '%.2f' % tps; 
        @retHash
          puts @retHash
          a << @retHash
      end
      a
    end



    def create_tabulation_row row
      student =   Student.find_by(roll: row[:roll])
      r = Registration.find_by(student_id: student.id, exam_uuid:@exam.uuid )  
      if r
              # r.student_type = :improvement
              # r.student = student
              # r.save
              is_failed_in_a_course = false;
              s = r.student
              tabulation = Tabulation.find_by(student_roll:s.roll, exam_uuid:@exam.uuid, :record_type=>:previous) || Tabulation.new
              tabulation.student_roll = s.roll;
              tabulation.exam_uuid = @exam.uuid
              tabulation.sl_no = r.sl_no
              tabulation.student_type = @student_type
              tabulation.record_type = :previous
              tabulation.hall_name = s.hall_name
              tps = row[:tps]
              tce = row[:tce]
              #sm_a = []
             @courses.each do |c|
                  summation = Summation.find_by(exam_uuid:@exam.uuid, course:c, student: s, :record_type=>:previous) || Summation.new
                  summation.student = student
                  summation.course = c
                  summation.record_type = :previous
               if c.course_type === "theory" 
                  summation.cact = row[(c.code.downcase+'cact').to_sym] 
                  summation.marks = row[(c.code.downcase+'fem').to_sym] 
                  summation.total_marks = row[(c.code.downcase+'mo').to_sym]
                else 
                  summation.total_marks = row[(c.code.downcase+'mo').to_sym]
                end

                summation.percetage =  row[(c.code.downcase+'pr').to_sym]
                summation.gpa = row[(c.code.downcase+'lg').to_sym]
                summation.grade = row[(c.code.downcase+'gp').to_sym]
                summation.save
                td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>summation.id)  || TabulationDetail.new
                td.tabulation = tabulation
                td.summation  = summation
                td.save
             end
              tabulation.gpa = row[:gpa].to_f
              tabulation.tce = row[:tce].to_f
              tabulation.result = row[:result]
              tabulation.remarks = row[:remarks]
              #tabulation.remarks = 'F-' + remarks.join(", ") if is_failed_in_a_course  
              tabulation.save
      end
    end
end

