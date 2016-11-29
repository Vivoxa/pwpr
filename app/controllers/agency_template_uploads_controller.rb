class AgencyTemplateUploadsController < ApplicationController
  authorize_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

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
    attributes = {uploaded_by_id:   current_user.id,
                  uploaded_by_type: current_user.class.name,
                  scheme_id:        params['scheme_id']}

    params_to_sym = Hash[upload_params.map { |k, v| [k.to_sym, v] }]
    attributes = attributes.merge(params_to_sym)
    upload = AgencyTemplateUpload.new(attributes)

    if accepted_format?(upload_params[:filename]) && upload.save
      transfer_file_to_server

      if File.exist?(path_to_save_file)
        assign_upload_filename!(upload)
        upload_to_s3(upload)
        upload.save!
        delete_file_from_server
      end

      redirect_to action: :index, notice: "#{upload.class} was successfully created."
    else
      @scheme = Scheme.find_by_id(params[:scheme_id])
      @upload = upload
      render 'agency_template_uploads/new'
    end
  end

  private

  def upload_to_s3(upload)
    agency_template_handler = S3::AgencyTemplateAwsHandler.new
    if agency_template_handler.put(upload)
      flash.notice = "#{upload.filename} uploaded successfully"
      binding.pry
    else
      flash.alert = "#{upload.filename} did not upload"
    end
  end

  def transfer_file_to_server
    tmp = upload_params[:filename].tempfile
    FileUtils.cp tmp.path, path_to_save_file
  end

  def delete_file_from_server
    FileUtils.rm [path_to_save_file], force: true
  end

  def path_to_save_file
    File.join('public', upload_params[:filename].original_filename)
  end

  def assign_upload_filename!(upload)
    upload.filename = upload_params[:filename].original_filename
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:agency_template_upload) do |user_params|
      user_params.permit(:year, :filename, :scheme_id)
    end
  end

  def accepted_format?(file)
    accepted_file_types.include? File.extname(file.original_filename)
  end

  def accepted_file_types
    ['.xls', '.xlsx']
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def upload_params
    params.require(:agency_template_upload).permit(:year, :filename)
  end
end
