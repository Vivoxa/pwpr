module Reporting
  class ReportTemplateHelper
    DEFAULT_FILE_EXT = 'pdf'.freeze
    TMP_FILEPATH = 'public/filetest.pdf'.freeze

    def self.get_default_template(report_type, ext = DEFAULT_FILE_EXT)
      s3 = Aws::S3::Client.new
      resp = s3.get_object({bucket: report_template_bucket_name, key: "default_#{report_type}.#{ext}"}, target: TMP_FILEPATH)
      resp.body
    end

    def self.cleanup
      FileUtils.rm [TMP_FILEPATH], force: true
    end

    private

    def self.report_template_bucket_name
      "#{Rails.env}-pwpr-templates"
    end
  end
end
