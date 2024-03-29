class ExamsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  #before_action :get_tenant, except: [:index, :create, :show, :update, :destroy]

  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.all 
  end

  # GET /exams/1
  # GET /exams/1.json
  def show 
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)
    @exam.dept = Dept.find_by(code:"CSE", institute_code: "CU")
    # @exam.program = params[:program].underscore.to_sym if params.include? :program
    # @exam.sem = params[:sem].underscore.to_sym if params.include? :sem
    # @exam.program_type = params[:program_type].underscore.to_sym if params.include? :program_type
    # @exam.year = params[:year] if params.include? :year
    @exam.uuid = set_uuid
    # @exam.fullname = set_fullname

    if @exam.save
     # render :show, status: :created, location: @exam
      render json:  {status: true}, status: :ok, location: @student
    else
      render json: @exam.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    if @exam.update(exam_params)
      #render :show, status: :ok, location: @exam
      render json:  {status: true}, status: :ok, location: @student
    else
      render json: @exam.errors, status: :unprocessable_entity
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    @exam.destroy
  end

   def process_result
      ap "Processing Regular result ...."
      @exam = Exam.find_by(uuid:params[:uuid]);
      Tabulation.where(exam_uuid:@exam.uuid).destroy_all

      ProcessingService.perform({:exam=>@exam, :student_type=>:regular, :record_type=>:current}) 
      ProcessingService.perform({:exam=>@exam, :student_type=>:improvement, :record_type=>:current}) unless  Registration.where(exam_uuid: @exam.uuid, student_type: "improvement").count == 0
      ProcessingService.perform({:exam=>@exam, :student_type=>:irregular, :record_type=>:current}) unless  Registration.where(exam_uuid: @exam.uuid, student_type: "irregular").count == 0
      render json: {:message=>"Job Submitted", :status=> "200 OK"}
   end

   def generate_tabulations_latex
       @exam = Exam.find_by(uuid:params[:exam_uuid]);
       @status =   GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:regular,:record_type=>:current})
       @status =   GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:improvement,:record_type=>:temp})
       @status =   GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:irregular,:record_type=>:temp})
         
      render json: {:message=>"Job Submitted", :status=> @status}
   end
   
   def generate_tabulations_xls
       @status =    GenerateTabulationXlsService.perform({:exam=>@exam})
       render json: {:message=>"Job Submitted", :status=> @status}
   end

   def generate_gradesheets_latex
       @status = GenerateGsJob.perform_later({:exam=>@exam})
      #  @status =  GenerateGradeSheetService.create_gs_latex({:exam=>@exam,:student_type=>:improvement, :record_type=>:temp})
      #  @status =  GenerateGradeSheetService.create_gs_latex({:exam=>@exam,:student_type=>:irregular, :record_type=>:temp})
       render json: {:message=>"Job Submitted", :status=> @status}
   end
   def generate_summationsheets_latex
      @status = GenerateSummationLatexService.new.perform({:exam=>@exam})
      render json: {:message=>"Job Submitted", :status=> @status}
   end
   
   def latex_to_pdf
     # Doc.pluck(:latex_loc).each { |f| exec "pdflatex  -no-file-line-error #{f} -output-directory=./reports/"}
     # Doc.where.not('latex_name LIKE ?', '%tabulation%').each do |d|
      Doc.where(exam_uuid:@exam.uuid).where.not('latex_name LIKE ?', '%tabulation%').each do |d|
       # @status = Doc.new.perform({:doc=>d})
       @status = LatexToPdfJob.perform_later({:doc=>d})
       d.pdf_loc  = d.latex_loc.sub(".tex", ".pdf")
       d.pdf_name = d.latex_name.sub(".tex", ".pdf")
       d.save
     end
      render json: {:message=>"Job Submitted", :status=> @status}
   end

   def reset_exam_result
      ap "Destroying previous results"
      @exam = Exam.find_by(uuid:params[:uuid]);
      ap @exam

      Tabulation.where(exam_uuid:@exam.uuid).destroy_all
      Summation.where(exam_uuid:@exam.uuid).destroy_all
      Registration.where(exam_uuid:@exam.uuid).destroy_all
      render json: {:message=>"Job Submitted", :status=> true}
   end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:year, :program, :sem, :title, :held_in, :program_type, :id, :uuid, :fullname)
    end

    def set_fullname
      [@exam.sem.titlecase,"Sem", @exam.program.titlecase,"Engineering Exam",  @exam.year].join(" ")
    end

    def set_uuid
      [@exam.sem, @exam.program, @exam.title, @exam.year].join("")
    end

    def set_current_exam
      @current_exam  = (params.include? :exam_uuid) ? Exam.find_by(uuid:params[:exam_uuid]) : Exam.last
    end
end
