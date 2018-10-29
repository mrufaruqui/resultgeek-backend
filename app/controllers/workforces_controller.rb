class WorkforcesController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_workforce, only: [:show, :update, :destroy]
  # GET /workforces
  # GET /workforces.json
  def index
    @workforces = Workforce.where(exam_uuid:@exam.uuid)
  end

  # GET /workforces/1
  # GET /workforces/1.json
  def show
  end

  # POST /workforces
  # POST /workforces.json
  def create
    @workforce = Workforce.new(workforce_params)

    if @workforce.save
      render :show, status: :created, location: @workforce
    else
      render json: @workforce.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workforces/1
  # PATCH/PUT /workforces/1.json
  def update
    if @workforce.update(workforce_params)
      render :show, status: :ok, location: @workforce
    else
      render json: @workforce.errors, status: :unprocessable_entity
    end
  end

  # DELETE /workforces/1
  # DELETE /workforces/1.json
  def destroy
    @workforce.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workforce
      @workforce = Workforce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workforce_params
      params.require(:workforce).permit(:role, :status, :exam_uuid)
    end
end
