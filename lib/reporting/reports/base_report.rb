require 'json'
require 'aws_gateway'

module Reporting
  module Reports
    class BaseReport
      DEFAULT_FILE_EXT = 'pdf'.freeze
      SERVER_TMP_FILE_DIR = 'tmp'.freeze

      def upload_filled_pdf_form_s3(values, year, business_npwd)
        binding.pry
        params = {}
        params['values'] = values.to_json
        params['year'] = year
        params['business_npwd'] = business_npwd
        params['report_type'] = report_type
        Clients::V1::PdfServiceClient.new.create_pdf(params)
      end

      protected

      def s3_report_helper
        @s3_report_helper ||= AwsGateway::S3ReportHelper.new(SERVER_TMP_FILE_DIR)
      end

      def cleanup(filepath)
        FileUtils.rm [filepath], force: true
      end

      def report_type
        raise NotImplementedError.new
      end

      def build_filename(report_type, year, business, ext = DEFAULT_FILE_EXT)
        "#{report_type}_#{year}_#{business.NPWD}.#{ext}"
      end
    end
  end
end
