module SpreadsheetWorker
  module SheetProcessor
    class RegistrationsHandler < BaseHandler
      def initialize
        @registration = Registration.new
      end

      def process
        @sheet_filename = './public/template_sheet.xls'
        @agency_template = get_agency_template

        registrations.each do |row_array|
          @business = get_business(row_array)

          process_contact(row_array)
          process_registered_address(row_array)
          process_correspondence_address(row_array)
          process_audit_address(row_array)
          process_registration(row_array)

          if small_producer?(row_array)
            process_small_producer(row_array)
          else
            process_regular_producer(row_array)
          end
        end
      end

      private

      def process_audit_address(row)
        address = Address.new
        address.address_line_1 = column_value(row, map['contact']['audit']['address_1']['field'])
        address.address_line_2 = column_value(row, map['contact']['audit']['address_2']['field'])
        address.address_line_3 = column_value(row, map['contact']['audit']['address_3']['field'])
        address.address_line_4 = column_value(row, map['contact']['audit']['address_4']['field'])
        address.town = column_value(row, map['contact']['audit']['town']['field'])
        address.post_code = column_value(row, map['contact']['audit']['postal_code']['field'])
        address.site_country = column_value(row, map['contact']['audit']['country']['field'])
        address.address_type = AddressType.where(title: 'audit').first
        address.business = @business
        address.save!
      end

      def process_correspondence_address(row)
        address = Address.new
        address.address_line_1 = column_value(row, map['correspondence']['address_1']['field'])
        address.address_line_2 = column_value(row, map['correspondence']['address_2']['field'])
        address.address_line_3 = column_value(row, map['correspondence']['address_3']['field'])
        address.address_line_4 = column_value(row, map['correspondence']['address_4']['field'])
        address.town = column_value(row, map['correspondence']['town']['field'])
        address.post_code = column_value(row, map['correspondence']['postal_code']['field'])
        address.address_type = AddressType.where(title: 'correspondence').first
        address.business = @business
        address.contacts << @contact
        address.save!
      end

      def process_registered_address(row)
        address = Address.new
        address.address_line_1 = column_value(row, map['registered']['address_1']['field'])
        address.address_line_2 = column_value(row, map['registered']['address_2']['field'])
        address.address_line_3 = column_value(row, map['registered']['address_3']['field'])
        address.address_line_4 = column_value(row, map['registered']['address_4']['field'])
        address.town = column_value(row, map['registered']['town']['field'])
        address.post_code = column_value(row, map['registered']['postal_code']['field'])
        address.site_country = column_value(row, map['registered']['country']['field'])
        address.telephone = column_value(row, map['registered']['phone']['field'])
        address.email = column_value(row, map['registered']['email']['field'])
        address.address_type = AddressType.where(title: 'registered').first
        address.business = @business
        address.save!
      end

      def process_contact(row)
        @contact = Contact.new
        @contact.title = column_value(row, map['contact']['title']['field'])
        @contact.first_name = column_value(row, map['contact']['first_name']['field'])
        @contact.last_name = column_value(row, map['contact']['last_name']['field'])
        @contact.email = column_value(row, map['contact']['email']['field'])
        @contact.telephone_1 = column_value(row, map['contact']['phone']['field'])
        @contact.fax = column_value(row, map['contact']['fax']['field'])
        @contact.business = @business
        @contact.save!
      end

      def process_small_producer(row)
        producer = SmallProducerDetail.new
        producer.allocation_method_obligation = column_value(row, map['allocation']['method_obligation']['field']).to_f
        producer.allocation_method_predominant_material = column_value(row, map['allocation']['predominant_material']['field'])
        producer.registration = @registration
        producer.save!
      end

      def process_regular_producer(row)
        producer = RegularProducerDetail.new
        producer.calculation_method_supplier_data = column_value(row, map['calculation_method']['suplier_data']['field'])
        producer.calculation_method_or_other_method_used = column_value(row, map['calculation_or_other_method']['field'])
        producer.calculation_method_sample_weighing = column_value(row, map['calculation_method']['sample_weighing']['field'])
        producer.calculation_method_sales_records = column_value(row, map['calculation_method']['sales_records']['field'])
        producer.calculation_method_trade_association_method_details = column_value(row, map['trade_assoc_method_details']['field'])
        producer.consultant_system_used = column_value(row, map['consultant_or_data_system_used']['field'])
        producer.data_system_used = column_value(row, map['name_of_consultant_or_data_system']['field'])
        producer.other_method_details = column_value(row, map['other_method_details']['field'])
        producer.registration = @registration
        producer.save!
      end

      def process_registration(row)
        @registration.licensor = column_value(row, map['licensor']['field'])
        @registration.turnover = column_value(row, map['turnover']['field']).to_f
        @registration.allocation_method_used = column_value(row, map['allocation']['method_used']['field'])

        @registration.change_detail = ChangeDetail.where(modification: column_value(row, map['change_to_member_application_or_obligation']['field'])).first
        @registration.resubmission_reason = ResubmissionReason.where(reason: column_value(row, map['resubmission_reason']['field'])).first
        @registration.packaging_sector_main_activity = PackagingSectorMainActivity.where(material: column_value(row, map['packaging_sector_main_activity']['field'])).first
        # @registration.submission_type = SubmissionType.where(code: )
        @registration.business = @business
        @registration.sic_code = @registration.business.sic_code
        @registration.agency_tempalte_upload = @agency_template
        @registration.save!
      end

      def registrations
        spreadsheet.sheet(2)
      end

      def create_business(row, npwd)
        business = Business.new
        business.trading_name = column_value(row, map['company_name']['field'])
        business.company_number = column_value(row, map['company_house_no']['field'])
        business.NPWD = npwd
        business.scheme = @agency_template.scheme
        business.country_of_business_registration = CountryOfBusinessRegistration.where(country: column_value(row, map['registered']['country']['field'])).first
        business.sic_code = SicCode.where(code: column_value(row, map['sic_code']['field'])).first
        business.scheme_ref = column_value(row, map['scheme_ref']['field'])
        business.business_type = BusinessType.where(name: column_value(row, map['company_type']['field'])).first
        business.business_subtype = BusinessSubtype.where(name: column_value(row, map['company_subtype']['field'])).first
        business.year_first_reg = Date.today.year
        business.year_last_reg = Date.today.year
        business.save!
        business
      end

      def small_producer?(row)
        column_value(row, map['allocation']['method_used'])
      end
    end
  end
end
