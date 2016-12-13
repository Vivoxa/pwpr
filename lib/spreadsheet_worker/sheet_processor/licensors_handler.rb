module SpreadsheetWorker
  module SheetProcessor
    class LicensorsHandler < BaseHandler
      def initialize(agency_template_id)
        super
        @licensor = Licensor.new
      end

      def process
        binding.pry
        @sheet_filename = './public/template_sheet.xls'

        licensors.each do |row_array|
          @business = get_business(row_array)

          process_contact(row_array)
          process_registered_address(row_array)
          process_contact_address(row_array)
          process_licensor
        end
      end

      private

      def process_registered_address(row)
        address = Address.new
        address.address_line_1 = column_value(row, map['registered']['address_1']['field'])
        address.address_line_2 = column_value(row, map['registered']['address_2']['field'])
        address.address_line_3 = column_value(row, map['registered']['address_3']['field'])
        address.address_line_4 = column_value(row, map['registered']['address_4']['field'])
        address.town = column_value(row, map['registered']['town']['field'])
        address.post_code = column_value(row, map['registered']['postal_code']['field'])
        address.address_type = AddressType.where(title: 'registered').first
        address.business = @business
        address.save!
      end

      def process_contact_address(row)
        address = Address.new
        address.address_line_1 = column_value(row, map['contact']['address_1']['field'])
        address.address_line_2 = column_value(row, map['contact']['address_2']['field'])
        address.address_line_3 = column_value(row, map['contact']['address_3']['field'])
        address.town = column_value(row, map['contact']['town']['field'])
        address.post_code = column_value(row, map['contact']['postal_code']['field'])
        address.address_type = AddressType.where(title: 'contact').first
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
        @contact.business = @business
        @contact.save!
      end

      def process_licensor
        @licensor.business = @business
        @licensor.agency_tempalte_upload = @agency_template
        @licensor.save!
      end

      def licensors
        spreadsheet.sheet(4)
      end

      def create_business(row, npwd)
        business = Business.new
        business.trading_name = column_value(row, map['company_name']['field'])
        business.company_number = column_value(row, map['company_house_no']['field'])
        business.NPWD = npwd
        business.scheme = @agency_template.scheme
        business.scheme_ref = column_value(row, map['scheme_ref']['field'])
        # business.business_type = BusinessType.where(name: column_value(row, map['company_type']['field'])).first
        # business.business_subtype = BusinessSubtype.where(name: column_value(row, map['company_subtype']['field'])).first
        business.year_first_reg = Date.today.year
        business.year_last_reg = Date.today.year
        business.save!
        business
      end
    end
  end
end
