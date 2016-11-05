require 'aws-sdk'

module S3
  class AgencyTemplateUploader
    SERVER_TMP_FILE_DIR = 'public'.freeze
    S3_FILE_AGENCY_TEMPLATE_IDENTIFIER = 'AT'.freeze
  
    def put(agency_template_upload)
      s3 = Aws::S3::Resource.new
      # Create the object to upload
        desired_s3_filename = build_s3_filename(agency_template_upload)
        obj = s3.bucket(bucket_name).object(desired_s3_filename)
       
        # Upload it      
        binding.pry
        obj.upload_file(server_file_path(agency_template_upload))
    end

    private

    def server_file_path(agency_template_upload)
      "#{AgencyTemplateUploader::SERVER_TMP_FILE_DIR}/#{agency_template_upload.filename}"
    end

    def build_s3_filename(agency_template_upload)
      "#{AgencyTemplateUploader::S3_FILE_AGENCY_TEMPLATE_IDENTIFIER}-#{agency_template_upload.year}-#{agency_template_upload.scheme_id}-#{agency_template_upload.filename}"
    end

    def bucket_name
      "#{Rails.env}-pwpr"
    end
  end
end
