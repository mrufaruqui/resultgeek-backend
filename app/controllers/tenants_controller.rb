class TenantsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_tenant, only: [:show, :update, :destroy]

  # GET /tenants
  # GET /tenants.json
  def index
    @tenants = Tenant.all
  end

  # GET /tenants/1
  # GET /tenants/1.json
  def show
  end

  # POST /tenants
  # POST /tenants.json
  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      render :show, status: :created, location: @tenant
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tenants/1
  # PATCH/PUT /tenants/1.json
  def update
    if @tenant.update(tenant_params)
      render :show, status: :ok, location: @tenant
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tenants/1
  # DELETE /tenants/1.json
  def destroy
    @tenant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:exam, :exam_id, :exam_uuid, :login_time, :logout_time)
    end
end
