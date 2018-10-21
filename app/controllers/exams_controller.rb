class ExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exam, only: [:show, :update, :destroy]

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
    @exam.uuid = set_uuid
    # @exam.fullname = set_fullname

    if @exam.save
      render :show, status: :created, location: @exam
    else
      render json: @exam.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    if @exam.update(exam_params)
      render :show, status: :ok, location: @exam
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
      ProcessingService.perform
      render json: {:message=>"Job Submitted"}, status: "ok"
   end

   def generate_tabulations_latex
       GenerateGradeSheetService.create_gs_latex
       render json: {:message=>"Job Submitted"}, status: "ok"
   end

   def generate_gradesheets_latex
        GenerateTabulationLatexService.create_tabulation_latex
        render json: {:message=>"Job Submitted"}, status: "ok"
   end
   def generate_summationsheets_latex
      GenerateSummationLatexService.new.perform
      render json: {:message=>"Job Submitted"}, status: "ok"
   end
   
   def reset_exam_result
      Tabulation.delete_all
      Summation.delete_all
   end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:year, :program, :sem, :title, :held_in)
    end

    def set_fullname
      [@exam.sem.titlecase,"Sem", @exam.program.titlecase,"Engineering Exam",  @exam.year].join(" ")
    end

    def set_uuid
      [e.sem, e.program, e.title, e.year].join("")
    end
end
