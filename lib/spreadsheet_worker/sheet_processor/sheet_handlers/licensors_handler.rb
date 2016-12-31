module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class LicensorsHandler < BaseHandler
        def initialize(agency_template_id)
          super
        end

        def process
          # @sheet_filename = './public/template_sheet.xls'

          licensors.drop(1).each do |row_array|
            @licensor = Licensor.new
            @business = get_business(row_array, column_value(row_array, map['npwd']['field']))

            process_contact(row_array)
            process_registered_address(row_array)
            process_contact_address(row_array)
            process_licensor
          end
        end

        private

        def process_registered_address(row)
          return if empty_row?(row)
          return if existing_address( 'Registered', @business)

          address = Address.new
          address.address_line_1 = column_value(row, map['registered']['address_1']['field'])
          address.address_line_2 = column_value(row, map['registered']['address_2']['field'])
          address.address_line_3 = column_value(row, map['registered']['address_3']['field'])
          address.town = column_value(row, map['registered']['town']['field'])
          address.post_code = column_value(row, map['registered']['postal_code']['field'])
          address.address_type = AddressType.where(title: 'Registered').first
          address.business = @business
          address.save!
        end

        def process_contact_address(row)
          return if empty_row?(row)
          return if existing_address( 'Contact', @business)

          address = Address.new
          address.address_line_1 = column_value(row, map['contact']['address_1']['field'])
          address.address_line_2 = column_value(row, map['contact']['address_2']['field'])
          address.address_line_3 = column_value(row, map['contact']['address_3']['field'])
          address.town = column_value(row, map['contact']['town']['field'])
          address.post_code = column_value(row, map['contact']['postal_code']['field'])
          address.address_type = AddressType.where(title: 'Contact').first
          address.business = @business
          address.save!
        end

        def process_contact(row)
          return if empty_row?(row)
          @contact = existing_contact(column_value(row, map['contact']['email']['field']), correspondence_address_type_id)
          return if @contact

          @contact = Contact.new
          @contact.first_name = column_value(row, map['contact']['first_name']['field'])
          @contact.last_name = column_value(row, map['contact']['last_name']['field'])
          @contact.email = column_value(row, map['contact']['email']['field'])
          @contact.telephone_1 = column_value(row, map['contact']['phone']['field'])
          @contact.business = @business
          @contact.address_type_id = correspondence_address_type_id
          @contact.save!
        end

        def process_licensor
          @licensor.business = @business
          @licensor.agency_template_upload = @agency_template
          @licensor.save!
        end

        def licensors
          spreadsheet.sheet(4)
        end

        def map
          map_loader.load(:licencees)
        end
      end
    end
  end
end
