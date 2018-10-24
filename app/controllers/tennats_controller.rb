class TennatsController < ApplicationController
  before_action :set_tennat, only: [:show, :update, :destroy]

  # GET /tennats
  # GET /tennats.json
  def index
    @tennats = Tennat.all
  end

  # GET /tennats/1
  # GET /tennats/1.json
  def show
  end

  # POST /tennats
  # POST /tennats.json
  def create
    @tennat = Tennat.new(tennat_params)

    if @tennat.save
      render :show, status: :created, location: @tennat
    else
      render json: @tennat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tennats/1
  # PATCH/PUT /tennats/1.json
  def update
    if @tennat.update(tennat_params)
      render :show, status: :ok, location: @tennat
    else
      render json: @tennat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tennats/1
  # DELETE /tennats/1.json
  def destroy
    @tennat.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tennat
      @tennat = Tennat.find(params[:exam_uuid]) || Tennat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tennat_params
      params.require(:tennat).permit(:exam_id, :exam_uuid)
    end
end
