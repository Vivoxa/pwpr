module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class RegistrationsHandler < BaseHandler
        def initialize(agency_template_id)
          super
        end

        def process
          # @sheet_filename = './public/template_sheet.xls'
          id = described_class.id_from_setting('Correspondence')
          @contact_title = described_class.find(id)

          registrations.drop(1).each do |row_array|
            @registration = Registration.new

            business = get_business(row_array, column_value(row_array, map['npwd']['field']))
            business ||= create_holding_business(row_array, column_value(row_array, map['npwd']['field']))

            @business = business
            @business.small_producer = column_value(row_array, map['allocation']['method_used']['field'])
            @business.save!

            process_contact(row_array)
            process_registered_address(row_array)
            process_correspondence_address(row_array)
            process_audit_address(row_array)
            process_registration(row_array)

            if @business.small_producer
              process_small_producer(row_array)
            else
              process_regular_producer(row_array)
            end
          end
        end

        private

        def process_audit_address(row)
          return if empty_row?(row)
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
          return if empty_row?(row)
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
          return if empty_row?(row)
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
          return if empty_row?(row)
          @contact = Contact.new
          @contact.title = column_value(row, map['contact']['title']['field'])
          @contact.first_name = column_value(row, map['contact']['first_name']['field'])
          @contact.last_name = column_value(row, map['contact']['last_name']['field'])
          @contact.email = column_value(row, map['contact']['email']['field'])
          @contact.telephone_1 = column_value(row, map['contact']['phone']['field'])
          @contact.fax = column_value(row, map['contact']['fax']['field'])
          @contact.business = @business
          @contact.type = @contact_title
          @contact.save!
        end

        def process_small_producer(row)
          return if empty_row?(row)
          producer = SmallProducerDetail.new
          producer.allocation_method_obligation = column_value(row, map['allocation']['method_obligation']['field']).to_f
          producer.allocation_method_predominant_material = column_value(row, map['allocation']['predominant_material']['field'])
          producer.registration = @registration
          producer.save!
        end

        def process_regular_producer(row)
          return if empty_row?(row)
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
          return if empty_row?(row)
          @registration.licensor = column_value(row, map['licensor']['field'])
          @registration.turnover = column_value(row, map['turnover']['field']).to_f
          @registration.allocation_method_used = column_value(row, map['allocation']['method_used']['field'])
          @registration.resubmission_reason = ResubmissionReason.where(reason: column_value(row, map['resubmission_reason']['field'])).first
          @registration.packaging_sector_main_activity = PackagingSectorMainActivity.where(material: column_value(row, map['packaging_sector_main_activity']['field'])).first
          @registration.submission_type = SubmissionType.where(code: column_value(row, map['change_to_member_application_or_obligation']['field'])).first
          @registration.business = @business
          @registration.sic_code = @registration.business.sic_code
          @registration.agency_template_upload = @agency_template
          @registration.save!
        end

        def registrations
          spreadsheet.sheet(2)
        end

        def map
          map_loader.load(:registrations)
        end
      end
    end
  end
end
