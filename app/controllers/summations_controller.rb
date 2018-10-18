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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_summation
      @summation = Summation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def summation_params
      params.require(:summation).permit(:assesment, :attendance, :section_a_marks, :section_b_marks, :total_marks, :gpa, :grade)
    end
end
