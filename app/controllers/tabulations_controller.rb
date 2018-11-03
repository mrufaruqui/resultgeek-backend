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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tabulation
      @tabulation = Tabulation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tabulation_params
      params.require(:tabulation).permit(:student_id, :gpa, :tce, :result, :remarks, :exam_uuid)
    end
    # def generate_tabulations_view
    #   a = []
    #     @tab =  Tabulation.where(exam_uuid: @exam.uuid)
    #     @tab.each do |t| 
    #       @retHash = Hash.new
    #       @retHash[:tabulation] = t;
    #       @retHash[:student] = t.student;
    #       @retHash[:summations] = []
    #       t.tabulation_details.each do |td|
    #         @retHash[:summations] << td.summation
    #       end
    #       puts @retHash
    #       a << @retHash
    #   end
    #   a
    # end

    def generate_tabulations_view
        a = []
        @tab =  Tabulation.where(exam_uuid: @exam.uuid).order(:sl_no)
        @tab.each do |t| 
        @retHash = Hash.new
        @retHash[:sl_no] = t.sl_no
        @retHash[:gpa] = '%.2f' % t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = '%.2f' % t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = t.student.roll
        @retHash[:name] = t.student.name
        @retHash[:hall] = t.student.hall_name;
        @retHash[:courses] = []
        tps = 0.0;
        t.tabulation_details.each do |td|
            course = Hash.new
            ps = ( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2)
            if td.summation.course.course_type === "lab"
               @retHash[td.summation.course.code + '_mo'] = td.summation.total_marks
               @retHash[td.summation.course.code + '_lg'] = td.summation.gpa
               @retHash[td.summation.course.code + '_gp'] = td.summation.grade
               @retHash[td.summation.course.code + '_ps'] = ps 
            else
               @retHash[td.summation.course.code + '_cact'] = td.summation.cact
               @retHash[td.summation.course.code + '_fem'] = td.summation.marks
               @retHash[td.summation.course.code + '_mo'] = td.summation.total_marks
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
end

