module Reporting
  module Reports
    class BaseReport
      SERVER_TMP_FILE_DIR = 'public'.freeze
      DEFAULT_FILE_EXT = 'pdf'.freeze
      PDFTK_LIB_LOCATION = '/usr/local/bin/pdftk'.freeze

      def report_bucket_name
        "#{Rails.env}-pwpr-reports"
      end

      def template_bucket_name
        "#{Rails.env}-pwpr-templates"
      end

      def upload_to_S3(year, business, ext=DEFAULT_FILE_EXT)
        s3 = Aws::S3::Resource.new

        # Create the object to upload
        s3_desired_filename = build_filename(report_type, year, business, ext)
        obj = s3.bucket(report_bucket_name).object(s3_desired_filename)

        # Upload it
        obj.upload_file(tmp_filename(year, business, ext))
      end

      protected

      def pdftk
        @pdftk ||= PdfForms.new(PDFTK_LIB_LOCATION)
      end

      def cleanup(year, business, ext=DEFAULT_FILE_EXT)
        path_to_save_file = "#{BaseReport::SERVER_TMP_FILE_DIR}/#{report_type}_#{year}_#{business.NPWD}.#{ext}"
        FileUtils.rm [path_to_save_file], force: true
        ReportTemplateHelper.cleanup
      end

      def report_type
        raise NotImplementedError.new
      end

      def build_filename(report_type, year, business, ext=DEFAULT_FILE_EXT)
        "#{report_type}_#{year}_#{business.NPWD}.#{ext}"
      end

      private

      def tmp_filename(year, business, ext=DEFAULT_FILE_EXT)
        "#{BaseReport::SERVER_TMP_FILE_DIR}/#{report_type}_#{year}_#{business.NPWD}.#{ext}"
      end
    end
  end
end
