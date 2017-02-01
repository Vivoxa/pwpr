class AgencyTemplateUploadsController < ApplicationController
  load_and_authorize_resource :scheme
  authorize_resource :agency_template_upload, through: :scheme

  before_action :configure_permitted_parameters, if: :devise_controller?

  # GET schemes/:scheme_id/agency_template_uploads
  def index
    @scheme = Scheme.find_by_id(params[:scheme_id])
    @uploads = @scheme.agency_template_uploads
  end

  # GET schemes/:scheme_id/agency_template_uploads/:id
  def show
    @upload = AgencyTemplateUpload.find_by_id(params[:id])
  end

  # GET schemes/:scheme_id/agency_template_uploads/new
  def new
    @scheme = Scheme.find_by_id(params[:scheme_id])
    @upload = AgencyTemplateUpload.new
    @prev_uploads = @scheme.agency_template_uploads
  end

  # POST schemes/:scheme_id/agency_template_uploads
  def create
    if params[:upload_exists].present? && params[:confirm_replace].nil?
      flash[:error] = 'You are uploading a file for a year that already has an uploaded and processed template.'\
      ' Please resubmit the upload and confirm you want to replace the existing file in the checkbox highlighted red.'
      redirect_to :back
    else
      upload = build_upload

      unless accepted_format?(upload_params[:filename])
        flash.alert = "ERROR: Unsupported file type!'#{upload.filename}'' was not uploaded!"
        redirect_to action: :index
        return
      end

      destroy_existing_agency_template

      upload(upload)
    end
  end

  def upload(upload)
    if upload.save
      transfer_file_to_server

      if File.exist?(path_to_save_file)
        assign_upload_filename!(upload)
        upload_to_s3(upload)
        upload.save!
        publish_uploaded_notification(upload.id)
      end

      redirect_to action: :index, notice: "#{upload.class} was successfully uploaded."
    else
      @scheme = Scheme.find_by_id(params[:scheme_id])
      @upload = upload
      render 'agency_template_uploads/new'
    end
  end

  def previous_upload_for_year
    existing_upload = AgencyTemplateUpload.for_previous_year(params[:scheme_id], params[:year])
    @show_confirmation_field = false

    @show_confirmation_field = true if existing_upload.any?

    respond_to do |format|
      format.js
    end
  end

  private

  def destroy_existing_agency_template
    if params[:upload_exists].present? && params[:confirm_replace].to_i == 1
      existing_upload = AgencyTemplateUpload.for_previous_year(params[:scheme_id].to_i,
                                                               params[:agency_template_upload][:year])

      existing_upload.each(&:destroy) if existing_upload.any?
    end
  end

  def build_upload
    attributes = {uploaded_by_id:   current_user.id,
                  uploaded_by_type: current_user.class.name,
                  scheme_id:        params['scheme_id']}

    params_to_sym = Hash[upload_params.map { |k, v| [k.to_sym, v] }]
    attributes = attributes.merge(params_to_sym)

    AgencyTemplateUpload.new(attributes)
  end

  def publish_uploaded_notification(upload_id)
    publisher = QueueHelpers::RabbitMq::Publisher.new(ENV['SPREADSHEET_QUEUE_NAME'],
                                                      ENV['SPREADSHEET_QUEUE_HOST'],
                                                      ENV['SPREADSHEET_WORKER_LOG_PATH'])
    publisher.publish(upload_id.to_s)
  end

  def upload_to_s3(upload)
    agency_template_handler = S3::AgencyTemplateAwsHandler.new
    if agency_template_handler.put(upload)
      message = "'#{upload.filename}' uploaded successfully! "
      message << 'Processing of this template will be done in the background. '
      message << 'The status of the Agency Template Upload will be updated when processing is complete.'

      flash.notice = message
    else
      flash.alert = "'#{upload.filename}' was not uploaded!"
    end
  end

  def transfer_file_to_server
    tmp = upload_params[:filename].tempfile
    FileUtils.cp tmp.path, path_to_save_file
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
    ['.xls']
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def upload_params
    params.require(:agency_template_upload).permit(:year, :filename, :confirm_replace, :upload_exists)
  end
end
