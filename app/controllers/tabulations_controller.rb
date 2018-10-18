class TabulationsController < ApplicationController
  before_action :set_tabulation, only: [:show, :update, :destroy]

  # GET /tabulations
  # GET /tabulations.json
  def index
    @tabulations = Tabulation.all
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
      params.require(:tabulation).permit(:student_id, :gpa, :tce, :result, :remarks)
    end
end
