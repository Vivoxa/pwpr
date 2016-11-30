require 'aws-sdk'

module S3
  class AgencyTemplateAwsHandler
    SERVER_TMP_FILE_DIR = 'public'.freeze
    S3_FILE_AGENCY_TEMPLATE_IDENTIFIER = 'AT'.freeze

    def put(agency_template_upload)
      s3 = Aws::S3::Resource.new

      # Create the object to upload
      s3_desired_filename = s3_build_filename(agency_template_upload)
      obj = s3.bucket(bucket_name).object(s3_desired_filename)

      # Upload it
      success = obj.upload_file(server_file_path(agency_template_upload))

      # Publish event to spreadsheet_queue for later processing
      publish_uploaded_notification(s3_build_filename(agency_template_upload)) if success
    end

    private

    def publish_uploaded_notification(file_path)
        publisher = SpreadsheetWorker::Publisher.new
        publisher.publish(file_path)
    end

    def server_file_path(agency_template_upload)
      "#{AgencyTemplateAwsHandler::SERVER_TMP_FILE_DIR}/#{agency_template_upload.filename}"
    end

    def s3_build_filename(agency_template_upload)
      "#{AgencyTemplateAwsHandler::S3_FILE_AGENCY_TEMPLATE_IDENTIFIER}-#{agency_template_upload.year}-#{agency_template_upload.scheme_id}-#{agency_template_upload.filename}"
    end

    def bucket_name
      "#{Rails.env}-pwpr"
    end
  end
end
