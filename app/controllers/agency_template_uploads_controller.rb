class AgencyTemplateUploadsController < ApplicationController
  # load_and_authorize_resource

  # GET schemes/:scheme_id/agency_template_uploads
  def index
    scheme = Scheme.find_by_id(params[:scheme_id])
    @uploads = scheme.agency_template_uploads
  end

  # GET schemes/:scheme_id/agency_template_uploads/:id
  def show
    @upload = AgencyTemplateUpload.find_by_id(params[:id])
  end

  # GET schemes/:scheme_id/agency_template_uploads/new
  def new
    @scheme = Scheme.find_by_id(params[:scheme_id])
    @upload = AgencyTemplateUpload.new
  end

  # POST schemes/:scheme_id/agency_template_uploads
  def create
    @upload = AgencyTemplateUpload.new(upload_params)

    # tmp = upload_params[:filename].tempfile
    # file = File.join("public", upload_params[:filename].original_filename)
    # FileUtils.cp tmp.path, file
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def upload_params
    params.require(:upload).permit(:year, :filename)
  end
end
