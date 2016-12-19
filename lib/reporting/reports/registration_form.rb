require 'pdf-forms'

module Reporting
  module Reports
    class RegistrationForm < Reporting::Reports::BaseReport
      REPORT_TYPE = name.demodulize.underscore.freeze

      def process_report(business_id, year, template = nil)
        business = Business.find(business_id)
        template ||= ReportTemplateHelper.get_default_template(report_type)
        local_file_path = tmp_filename(year, business)

        pdftk.fill_form(template, local_file_path, form_values_hash(template, year, business))

        upload_to_S3(year, business)

        email_business(business, build_filename(report_type, year, business), local_file_path, year)

        cleanup(year, business)
      end

      private

      def email_business(business, filename, filepath, year)
        SchemeMailer.registration_email(business, filename, filepath, year).deliver_now
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
        address_type_id = AddressType.find_by_title(report_field_config['address_type']).id
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
