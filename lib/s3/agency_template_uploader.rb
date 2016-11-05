require 'aws-sdk'

module S3
  class AgencyTemplateUploader
  
    def put(agency_template_upload)
      bucket = 'my-bucket'
            
      # Get just the file name
        name = File.basename(file)
       
      # Create the object to upload
        obj = s3.bucket(bucket).object(build_filename(agency_template_upload))
       
        # Upload it      
        obj.upload_file(file)
         
    end

    def test_connection
      s3 = Aws::S3::Client.new
      resp = s3.list_buckets
      binding.pry
      resp.buckets.each do |bucket|
        puts "Bucket: #{bucket.name}"
      end
    end

    private

    def build_filename(agency_template_upload)
      "AT-#{agency_template_upload.year}-#{agency_template_upload.scheme_id}"
    end

    def bucket_name
      "{Rails.env}-pwpr"
    end
  end
end
