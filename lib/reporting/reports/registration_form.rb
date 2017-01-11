require 'pdf-forms'

module Reporting
  module Reports
    class RegistrationForm < Reporting::Reports::BaseReport
      include Logging

      REPORT_TYPE = name.demodulize.underscore.freeze

      def process_report(business_id, year, current_user, template)
        raise 'Report template not supplied and is required!' if template.nil?

        logger.tagged("RegistrationForm for business with id #{business_id}, #{year}") do
          @errors = []
          begin
            logger.info 'process_report() = finding business'
            business = Business.find(business_id)
            logger.info 'process_report() = FOUND business'

            local_file_path = tmp_filename(year, business)

            logger.info 'process_report() = Filling in RegistrationForm PDF with data'
            pdftk.fill_form(template, local_file_path, form_values_hash(template, year, business))

            logger.info 'process_report() = Uploading RegistrationForm PDF to S3'
            upload_to_S3(year, business)

            logger.info 'process_report() = Emailing RegistrationForm PDF'
            email_business(business, build_filename(report_type, year, business), local_file_path, year, current_user)
            cleanup(year, business)
          rescue => e
            @errors << e.message
            logger.warn "process_report() ERROR: #{e.message}"
            raise e
          end
        end
      end

      private

      def email_business(business, filename, file_path, year, current_user)
        success = SchemeMailer.registration_email(business, filename, file_path, year, business.correspondence_contact.email).deliver_now

        status_id = success ? EmailedStatus.id_from_setting('SUCCESS') : EmailedStatus.id_from_setting('FAILED')

        logger.info "process_report() = Email sent?: #{success}"
        EmailedReport.where(business_id: business.id, report_name: report_type, year: year).first_or_create(date_last_sent:    DateTime.now,
                                                                                                            sent_by_id:        current_user.id,
                                                                                                            sent_by_type:      current_user.class.name,
                                                                                                            emailed_status_id: status_id,
                                                                                                            error_notices:     @errors)
        success
      end

      def form_values_hash(template, year, business)
        pdf_fields = pdftk.get_fields(template)

        maps = load_mappings
        value_pairs = {}

        pdf_fields.each do |pdf_field|
          next if excluded_fields.include?(pdf_field.name)
          report_field_config = maps['fields'][pdf_field.name]

          begin
            assign_value_pairs(business, pdf_field, report_field_config, value_pairs, year)
          rescue => e
            logger.error "process_report() pdf-field: #{pdf_field.name} ERROR: #{e.message}"
          end
        end
        value_pairs['tb_year_title'] = year
        value_pairs
      end

      def assign_value_pairs(business, pdf_field, report_field_config, value_pairs, year)
        case report_field_config['model_name']
        when 'business'
          value = process_business_attribute(report_field_config, business)
          value_pairs[pdf_field.name] = configure_field_format(pdf_field, value)

        when 'address'
          value_pairs[pdf_field.name] = process_address_attribute(report_field_config, business)

        when 'registration'
          value = process_registration_attribute(report_field_config, business, year)
          value_pairs[pdf_field.name] = configure_field_format(pdf_field, value)

        when 'contact'
          value = process_contact_attribute(report_field_config, business)
          value_pairs[pdf_field.name] = configure_field_format(pdf_field, value)
        end
      end

      def configure_field_format(pdf_field, value)
        case pdf_field.type
        when 'Text'
          value
        when 'Button'
          checkbox_compatible_value(value)
        end
      end

      def process_contact_attribute(report_field_config, business)
        address_type_id = AddressType.id_from_setting(report_field_config['address_type'])
        contacts = business.contacts.where(address_type_id: address_type_id)
        contacts.any? ? contacts.first.send(report_field_config['model_attribute']) : nil
      end

      def checkbox_compatible_value(boolean)
        boolean ? 'Yes' : 'Off'
      end

      def process_registration_attribute(report_field_config, business, year)
        template = agency_template(business.scheme, year)
        return if template.nil?

        registrations = template.first.registrations.where(business_id: business.id)
        registrations.any? ? registrations.first.send(report_field_config['model_attribute']) : nil
      end

      def agency_template(scheme, year)
        @template ||= AgencyTemplateUpload.where(scheme_id: scheme.id, year: year)
      end

      def process_address_attribute(report_field_config, business)
        address_type_id = AddressType.id_from_setting(report_field_config['address_type'])
        addresses = business.addresses.where(address_type_id: address_type_id)
        addresses.any? ? addresses.first.send(report_field_config['model_attribute']) : nil
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
        %w(tb_year_title tb_user_data tb_turnover
           tb_del_auth_director tb_del_auth_to tb_signed
           tb_name tb_date tb_position)
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
