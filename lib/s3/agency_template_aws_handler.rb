require 'aws-sdk'

module S3
  class AgencyTemplateAwsHandler
    S3_FILE_AGENCY_TEMPLATE_IDENTIFIER = 'AT'.freeze

    def put(agency_template_upload)
      s3 = Aws::S3::Resource.new

      # Create the object to upload
      s3_desired_filename = s3_build_filename(agency_template_upload)
      obj = s3.bucket(bucket_name).object(s3_desired_filename)

      # Upload it
      obj.upload_file(InputOutput::ServerFileHandler.server_file_path_for(agency_template_upload.filename))
    end

    private

    def s3_build_filename(agency_template_upload)
      "#{AgencyTemplateAwsHandler::S3_FILE_AGENCY_TEMPLATE_IDENTIFIER}-#{agency_template_upload.year}-#{agency_template_upload.scheme_id}-#{agency_template_upload.filename}"
    end

    def bucket_name
      "#{Rails.env}-pwpr"
    end
  end
end
