module SpreadsheetWorker
  module SheetProcessor
    class RegistrationsHandler
      def process
        process_audit_address
        process_correspondence_address
        process_registered_address
        process_contact
        process_calculations
        process_allocation
        process_other
      end

      private

      def process_audit_address(row)
        address = Address.new
        address.address_1 = column_value(row, map['contact']['audit']['address_1']['field'])
        address.address_2 = column_value(row, map['contact']['audit']['address_2']['field'])
        address.address_3 = column_value(row, map['contact']['audit']['address_3']['field'])
        address.address_4 = column_value(row, map['contact']['audit']['address_4']['field'])
        address.town = column_value(row, map['contact']['audit']['town']['field'])
        address.post_code = column_value(row, map['contact']['audit']['postal_code']['field'])
        address.country = column_value(row, map['contact']['audit']['country']['field'])
        address.address_type = AddressType.where(title: 'audit').first
        address.business = @registration.business
      end

      def process_correspondence_address(row)
        address = Address.new
        address.address_1 = column_value(row, map['correspondence']['address_1']['field'])
        address.address_2 = column_value(row, map['correspondence']['address_2']['field'])
        address.address_3 = column_value(row, map['correspondence']['address_3']['field'])
        address.address_4 = column_value(row, map['correspondence']['address_4']['field'])
        address.town = column_value(row, map['correspondence']['town']['field'])
        address.post_code = column_value(row, map['correspondence']['postal_code']['field'])
        address.address_type = AddressType.where(title: 'correspondence').first
        address.contact = process_contact
        address.business = @registration.business
      end

      def process_registered_address(row)
        address = Address.new
        address.address_1 = column_value(row, map['registered']['address_1']['field'])
        address.address_2 = column_value(row, map['registered']['address_2']['field'])
        address.address_3 = column_value(row, map['registered']['address_3']['field'])
        address.address_4 = column_value(row, map['registered']['address_4']['field'])
        address.town = column_value(row, map['registered']['town']['field'])
        address.post_code = column_value(row, map['registered']['postal_code']['field'])
        address.country = column_value(row, map['registered']['country']['field'])
        address.telephone = column_value(row, map['registered']['phone']['field'])
        address.email = column_value(row, map['registered']['email']['field'])
        address.address_type = AddressType.where(title: 'registered').first
        address.business = @registration.business
      end

      def process_contact(row)
        #  process contact data
        contact = Contact.new
        contact.title = column_value(row, map['contact']['title']['field'])
        contact.first_name = column_value(row, map['contact']['first_name']['field'])
        contact.last_name = column_value(row, map['contact']['last_name']['field'])
        contact.email = column_value(row, map['contact']['email']['field'])
        contact.phone = column_value(row, map['contact']['telephone_1']['field'])
        contact.fax = column_value(row, map['contact']['fax']['field'])
        contact
      end

      def process_calculations
        # process calculation data
      end

      def process_allocation
        # process allocation data
        @registration.allocation_method_used = column_value(row, map['allocation']['method_used']['field'])
      end

      def process_other
        @registration.licensor = column_value(row, map['licensor']['field'])
        @registration.turnover = column_value(row, map['turnover']['field'])
        @registration.change_detail = ChangeDetail.where(modification: column_value(row, map['change_to_member_application_or_obligation']['field'])).first
        @registration.resubmission_reason = ResubmissionReason.where(reason: column_value(row, map['resubmission_reason']['field'])).first
        @registration.packaging_sector_main_activity = PackagingSectorMainActivity.where(type: column_value(row, map['change_to_member_application_or_obligation']['field'])).first
        @registration.country_of_business_registration = CountryOfBusinessRegistrations.where(country: column_value(row, map['registered']['country']['field'])).first
      end

      def get_or_create_business(npwd)
        business = Business.where(NPWD: npwd).first

        unless business
          business = Business.new
          business.trading_name = column_value(row, map['company_name']['field'])
          business.company_number = column_value(row, map['company_house_no']['field'])
          business.NPWD = npwd
          business.sic_code = SicCodes.where(code: column_value(row, map['sic_code']['field']))
          business.scheme_ref = column_value(row, map['scheme_ref']['field'])
          business.business_type = BusinessTypeCode.where(name: column_value(row, map['business_type']['field'])).first
          business.business_subtype = BusinessSubtypeCode.where(name: column_value(row, map['business_subtype']['field'])).first
        end

        @registration.business = business
      end

      def map
        map_loader(:registrations)
      end

      def map_loader
        @map ||= SheetMapLoader::Map.new
      end

      def registrations
        spreadsheet.sheets[2]
      end

      def spreadsheet
        @sheet ||= Roo::Spreadsheet.open('./public/template_sheet.xls')
      end

      def column_value(row, letter)
        index = transform_to_index(letter)
        value = registrations.row(row)[index]

        return boolean_column_value if ['Y', 'N'].include? value
        value
      end

      def boolean_column_value(value)
        value == 'Y' ? true : false
      end

      def transform_to_index(letter)
        set = ('A'..'EZ').to_a
        set.find_index(letter) if set.include? letter
      end
    end
  end
end
