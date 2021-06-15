class WorkforcesController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_tenant
  before_action :set_workforce, only: [:show, :update, :destroy]
  # GET /workforces
  # GET /workforces.json
  def index
    @w = Workforce.where(exam_uuid:@exam.uuid).includes(:teacher)

    if @w
      a = []
     @w.each do |w| 
      rethash = Hash.new
      rethash[:role] = w.role.titlecase unless w.role.nil?
      rethash[:status] = w.status
      rethash[:name] = w.teacher.display_name
      rethash[:designation]= w.teacher.designation.titlecase unless w.teacher.designation.nil?
      rethash[:email]= w.teacher.email
      rethash[:phone]= w.teacher.phone
      rethash[:dept_name]= w.teacher.dept.name
      rethash[:dept_code]= w.teacher.dept.code
      rethash[:inst_name]= w.teacher.dept.institute
      rethash[:inst_code]= w.teacher.dept.institute_code
      a << rethash
    end
      render json: a, status: "200 ok"
     else
      render json: @w.errors, status: :unprocessable_entity
    end 
  end

  # GET /workforces/1
  # GET /workforces/1.json
  def show
    render json: @workforce
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
    render json:  {status: true}
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
