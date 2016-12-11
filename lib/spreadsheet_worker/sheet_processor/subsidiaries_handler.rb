module SpreadsheetWorker
  module SheetProcessor
    class SubsidiariesHandler < BaseHandler
      def initialize
        @subsidiary = Subsidiary.new
      end

      def process
        @sheet_filename = './public/template_sheet.xls'
        @agency_template = get_agency_template

        subsidiaries.each do |row_array|
          @business = get_business(row_array)

          process_contact(row_array)
          process_registered_address(row_array)
          process_correspondence_address(row_array)
          process_subsidiary(row_array)
          process_small_producer(row_array)
        end
      end

      private

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
        @contact.business = @business
        @contact.save!
      end

      def process_small_producer(row)
        producer = SmallProducerDetail.new
        producer.allocation_method_obligation = column_value(row, map['allocation']['method_obligation']['field']).to_f
        producer.allocation_method_predominant_material = column_value(row, map['allocation']['predominant_material']['field'])
        producer.registration = @subsidiary
        producer.save!
      end

      def process_subsidiary(row)
        @subsidiary.licensor = column_value(row, map['licensor']['field'])
        @subsidiary.turnover = column_value(row, map['turnover']['field']).to_f
        @subsidiary.allocation_method_used = column_value(row, map['allocation']['method_used']['field'])
        @subsidiary.change_detail = ChangeDetail.where(modification: column_value(row, map['change_to_subsidiary_data']['field'])).first
        @subsidiary.packaging_sector_main_activity = PackagingSectorMainActivity.where(material: column_value(row, map['packaging_sector_main_activity']['field'])).first
        @subsidiary.business = @business
        @subsidiary.sic_code = @subsidiary.business.sic_code
        @subsidiary.agency_tempalte_upload = @agency_template
        @subsidiary.save!
      end

      def subsidiaries
        spreadsheet.sheet(2)
      end
    end
  end
end
