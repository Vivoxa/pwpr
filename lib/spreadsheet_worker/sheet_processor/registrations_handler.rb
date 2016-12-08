module SpreadsheetWorker
  module SheetProcessor
    class RegistrationsHandler
      def process
        process_address
        process_contact
        process_calculations
        process_allocation
        process_other
      end

      private

      def process_audit_address(row)
        # process address (registrations, correspondence, contact/audit) data
        address = Address.new
        address.address_1 = column_value(row, map['contact']['audit']['address_1']['field'])
        address.address_2 = column_value(row, map['contact']['audit']['address_2']['field'])
        address.address_3 = column_value(row, map['contact']['audit']['address_3']['field'])
        address.address_4 = column_value(row, map['contact']['audit']['address_4']['field'])
        address.town = column_value(row, map['contact']['audit']['town']['field'])
        address.post_code = column_value(row, map['contact']['audit']['postal_code']['field'])
        address.country = column_value(row, map['contact']['audit']['country']['field'])
        address
      end

      def process_correspondence_address(row)
        # process address (registrations, correspondence, contact/audit) data
        address = Address.new
        address.address_1 = column_value(row, map['correspondence']['address_1']['field'])
        address.address_2 = column_value(row, map['correspondence']['address_2']['field'])
        address.address_3 = column_value(row, map['correspondence']['address_3']['field'])
        address.address_4 = column_value(row, map['correspondence']['address_4']['field'])
        address.town = column_value(row, map['correspondence']['town']['field'])
        address.post_code = column_value(row, map['correspondence']['postal_code']['field'])
        address
      end

      def process_registration_address(row)
        # process address (registrations, correspondence, contact/audit) data
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
        address
      end

      def process_contact(row)
        #  process contact data
        contact = Contact.new
        contact.title = column_value(row, map['contact']['title']['field'])
        contact.fisrt_name = column_value(row, map['contact']['fisrt_name']['field'])
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

        @registration.allocation_method_obligation
        @registration.allocation_method_used
        @registration.allocation_method_used
        @registration.allocation_method_used
      end

      def process_other
        # process the rest of the data
        @registration.allocation_method_used
      end

      def create_business
        # create business if it doesn't exist
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
        registrations.row(row)[index]
      end

      def transform_to_index(letter)
        set = ('A'..'EZ').to_a
        set.find_index(letter) if set.include? letter
      end
    end
  end
end
