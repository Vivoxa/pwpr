require 'roo-xls'
require_relative '../../sheet_map_loader/map'

module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class BaseHandler
        include SheetMapLoader

        def initialize(agency_template_id)
          load_agency_template(agency_template_id)
          load_sheet_path(@agency_template)
        end

        protected

        def correspondence_address_type_id
          AddressType.id_from_setting('Correspondence')
        end

        def registered_address_type_id
          AddressType.id_from_setting('Registered')
        end

        def audit_address_type_id
          AddressType.id_from_setting('Audit')
        end

        def contact_address_type_id
          AddressType.id_from_setting('Contact')
        end

        def load_sheet_path(agency_template)
          @sheet_filename ||= InputOutput::ServerFileHandler.server_file_path_for(agency_template.filename)
        end

        def load_agency_template(id)
          @agency_template ||= AgencyTemplateUpload.find_by_id(id)
        end

        def get_business(_row, npwd)
          Business.where(NPWD: npwd).first if npwd
        end

        def map_loader
          @map ||= SpreadsheetWorker::SheetMapLoader::Map.new
        end

        def spreadsheet
          @sheet ||= Roo::Spreadsheet.open(@sheet_filename)
        end

        def empty_row?(row)
          is_empty = true
          row.each do |field|
            is_empty = false if field.present?
          end
          is_empty
        end

        def column_value(row, letter)
          index = transform_to_index(letter)
          value = row[index]

          return boolean_column_value(value) if %w(Y N).include? value
          value
        end

        def existing_contact(email, address_type_id)
          contacts = Contact.where(email:           email,
                                   address_type_id: address_type_id)
          contacts.any? ? contacts.first : nil
        end

        def existing_address(address_title, business)
          address_type_id = AddressType.id_from_setting(address_title)
          addresses = business.addresses.where(address_type_id: address_type_id)
          addresses.any? ? addresses.first : nil
        end

        def boolean_column_value(value)
          value == 'Y' ? true : false
        end

        def transform_to_index(letter)
          set = ('A'..'EZ').to_a
          set.find_index(letter) if set.include? letter
        end

        def create_holding_business(row, npwd)
          business = create_business(row, npwd)
          business.business_type = BusinessType.where(name: column_value(row, map['company_type']['field'])).first
          business.business_subtype = BusinessSubtype.where(name: column_value(row, map['company_subtype']['field'])).first
          business.save!
          business
        end

        def create_sub_business(row, npwd)
          business = create_business(row, npwd)
          business.holding_business = get_business(row, column_value(row, map['registration_company_npwd']['field']))
          business.save!
          business
        end

        def create_leaving_business(row)
          leaving_business = LeavingBusiness.new
          leaving_business.scheme_ref = column_value(row, map['scheme_ref']['field'])
          leaving_business.npwd = column_value(row, map['npwd']['field'])
          leaving_business.company_name = column_value(row, map['company_name']['field'])
          leaving_business.company_number = column_value(row, map['company_house_no']['field'])
          leaving_business.subsidiaries_number = column_value(row, map['subsidiaries_no']['field']).to_i unless @subleaver
          leaving_business
        end

        def create_business(row, npwd)
          business = Business.new
          business.name = column_value(row, map['company_name']['field'])
          business.company_number = column_value(row, map['company_house_no']['field'])
          business.NPWD = npwd
          business.scheme = @agency_template.scheme
          business.country_of_business_registration = CountryOfBusinessRegistration.where(country: column_value(row, map['registered']['country']['field'])).first
          business.sic_code = SicCode.where(code: column_value(row, map['sic_code']['field'])).first
          business.scheme_ref = column_value(row, map['scheme_ref']['field'])
          business
        end
      end
    end
  end
end
