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

    unless accepted_format?(upload_params[:filename])
      flash.alert = "ERROR: Unsupported file type!'#{upload.filename}'' was not uploaded!"
      redirect_to action: :index
      return
    end

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

  private

  def publish_uploaded_notification(upload_id)
    publisher = QueueHelpers::RabbitMq::Publisher.new(ENV['SPREADSHEET_QUEUE_NAME'],
                                                      ENV['SPREADSHEET_QUEUE_HOST'],
                                                      ENV['SPREADSHEET_WORKER_LOG_PATH'])
    publisher.publish(upload_id.to_s)
  end

  def upload_to_s3(upload)
    agency_template_handler = S3::AgencyTemplateAwsHandler.new
    if agency_template_handler.put(upload)
      message =  "'#{upload.filename}' uploaded successfully! "
      message << "Processing of this template will be done in the background. "
      message << "The status of the Agency Template Upload will be updated when processing is complete."

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
    params.require(:agency_template_upload).permit(:year, :filename)
  end
end
