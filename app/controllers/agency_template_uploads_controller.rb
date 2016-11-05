class AgencyTemplateUploadsController < ApplicationController
  # load_and_authorize_resource

  # GET schemes/:scheme_id/agency_template_uploads
  def index
    scheme = Schemes.find_by_id(params[:scheme_id])
    @uploads = scheme.agency_template_uploads
  end

  # GET schemes/:scheme_id/agency_template_uploads/:id
  def show
  end

  # GET schemes/:scheme_id/agency_template_uploads/new
  def new
    @upload = AgencyTemplateUpload.new
  end

  # POST schemes/:scheme_id/agency_template_uploads
  def create
    @upload = AgencyTemplateUpload.new(upload_params)
  end
end
