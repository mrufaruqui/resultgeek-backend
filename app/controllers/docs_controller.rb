class DocsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_doc, only: [:show, :update, :destroy]

  # GET /docs
  # GET /docs.json
  def index
    @docs = Doc.all
  end

  # GET /docs/1
  # GET /docs/1.json
  def show
  end

  # POST /docs
  # POST /docs.json
  def create
    @doc = Doc.new(doc_params)

    if @doc.save
      render :show, status: :created, location: @doc
    else
      render json: @doc.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /docs/1
  # PATCH/PUT /docs/1.json
  def update
    if @doc.update(doc_params)
      render :show, status: :ok, location: @doc
    else
      render json: @doc.errors, status: :unprocessable_entity
    end
  end

  # DELETE /docs/1
  # DELETE /docs/1.json
  def destroy
    @doc.destroy
  end

  def download
    f = File.open( params[:file_loc], 'r')
    if f 
        render json: {:file=>f.readlines, :status=>true}
    else
        render json: {:errors=>f.errors, :status=>false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc
      @doc = Doc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_params
      params.require(:doc).permit(:uuid, :exam_uuid, :description, :latex_name, :latex_loc, :filename, :file_loc)
    end
end
