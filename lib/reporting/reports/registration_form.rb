require 'pdf-forms'

module Reporting
  module Reports
    class RegistrationForm < Reporting::Reports::BaseReport
      include Logging

      REPORT_TYPE = name.demodulize.underscore.freeze

      def process_report(business_id, year, current_user, template = nil)
        logger.tagged("RegistrationForm for business with id #{business_id}, #{year}") do
          @errors = []
          begin
            logger.info 'process_report() = finding business'
            business = Business.find(business_id)
            logger.info 'process_report() = FOUND business'

            template ||= ReportTemplateHelper.get_default_template(report_type)
            local_file_path = tmp_filename(year, business)

            logger.info 'process_report() = Filling in RegistrationForm PDF with data'
            pdftk.fill_form(template, local_file_path, form_values_hash(template, year, business))

            logger.info 'process_report() = Uploading RegistrationForm PDF to S3'
            upload_to_S3(year, business)
          rescue => e
            @errors << e.message
          ensure
            logger.info 'process_report() = Emailing RegistrationForm PDF'
            email_business(business, build_filename(report_type, year, business), local_file_path, year, current_user)

            logger.info 'process_report() = Cleaning up tmp files '
            cleanup(year, business)
          end
        end
      end

      private

      def email_business(business, filename, filepath, year, current_user)
        success = SchemeMailer.registration_email(business, filename, filepath, year).deliver_now
        status_id = success ? EmailedStatus.id_from_setting('SUCCESS') : EmailedStatus.id_from_setting('FAILED')
        logger.info "process_report() = Email sent?: #{success}"
        EmailedReport.where(business_id: business.id, report_name: report_type, year: year).first_or_create(date_last_sent: DateTime.now,
                                                                                                            sent_by_id: current_user.id,
                                                                                                            sent_by_type: current_user.class.name,
                                                                                                            emailed_status_id: status_id,
                                                                                                            error_notices: @errors)
      end

      def form_values_hash(template, year, business)
        pdf_fields = pdftk.get_field_names(template)

        maps = load_mappings
        value_pairs = {}

        pdf_fields.each do |pdf_field|
          next if excluded_fields.include?(pdf_field)
          report_field_config = maps['fields'][pdf_field]

          if report_field_config['model_name'] == 'business'
            value_pairs[pdf_field] = process_business_attribute(report_field_config, business)
          end

          if report_field_config['model_name'] == 'address'
            value_pairs[pdf_field] = process_address_attribute(report_field_config, business)
          end
        end
        value_pairs['tb_year_title'] = year
        value_pairs
      end

      def process_address_attribute(report_field_config, business)
        address_type_id = AddressType.id_from_setting(report_field_config['address_type'])
        address = business.addresses.where(address_type_id).first
        address.send(report_field_config['model_attribute'])
      end

      def process_business_attribute(report_field_config, business)
        if report_field_config['lookup']
          id = business.send(report_field_config['model_attribute'])

          klass = report_field_config['lookup']['model']
          obj = klass.singularize.classify.constantize.find(id)

          obj.send(report_field_config['lookup']['model_attribute'])
        else
          business.send(report_field_config['model_attribute'])
        end
      end

      def excluded_fields
        %w(tb_year_title tb_user_data)
      end

      def load_mappings
        report_mappings = Reporting::Mappings::Mappers::RegistrationReportMapper.new
        report_mappings.load_maps
      end

      def report_type
        REPORT_TYPE
      end
    end
  end
end
