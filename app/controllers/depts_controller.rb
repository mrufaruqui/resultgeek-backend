class DeptsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_dept, only: [:show, :update, :destroy]

  # GET /depts
  # GET /depts.json
  def index
    @depts = Dept.all
    render json: @depts
  end

  # GET /depts/1
  # GET /depts/1.json
  def show
    if @dept.nil?
      @status = true
    else  
      @errors = @dept.errors
    end
  end

  # POST /depts
  # POST /depts.json
  def create
    @dept = Dept.new(dept_params)

    if @dept.save 
      @status = true
    else  
      @errors = @dept.errors
    end
    render :show
  end

  # PATCH/PUT /depts/1
  # PATCH/PUT /depts/1.json
  def update
    if @dept.update(dept_params)
      @status = true
    else  
      @errors = @dept.errors
    end
    render :show
  end

  # DELETE /depts/1
  # DELETE /depts/1.json
  def destroy
    @dept.destroy
     render json:  {status: true}       
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dept
      @dept = Dept.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dept_params
      params.require(:dept).permit(:code, :name, :institute, :institute_code, :id)
    end
end
