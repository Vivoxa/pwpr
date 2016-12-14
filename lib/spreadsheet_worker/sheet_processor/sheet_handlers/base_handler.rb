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

        def load_sheet_path(agency_template)
          @sheet_filename ||= aws_handler.get_server_file_path(agency_template)
        end

        def aws_handler
          @aws_handler ||= S3::AgencyTemplateAwsHandler.new
        end

        def load_agency_template(id)
          @agency_template ||= AgencyTemplateUpload.find_by_id(id)
        end

        def get_business(row)
          npwd = column_value(row, map['npwd']['field'])
          business = Business.where(NPWD: npwd).first if npwd
        end

        def map_loader
          @map ||= SpreadsheetWorker::SheetMapLoader::Map.new
        end

        def spreadsheet
          @sheet ||= Roo::Spreadsheet.open(@sheet_filename)
        end

        def column_value(row, letter)
          index = transform_to_index(letter)
          value = row[index]

          return boolean_column_value(value) if %w(Y N).include? value || value.nil?
          value
        end

        def boolean_column_value(value)
          value == 'Y' ? true : false
        end

        def small_producer?(row)
          column_value(row, map['allocation']['method_used']['field'])
        end

        def transform_to_index(letter)
          set = ('A'..'EZ').to_a
          set.find_index(letter) if set.include? letter
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
          business.business_type = BusinessType.where(name: column_value(row, map['company_type']['field'])).first
          business.business_subtype = BusinessSubtype.where(name: column_value(row, map['company_subtype']['field'])).first
          business.year_first_reg = Date.today.year
          business.year_last_reg = Date.today.year
          business.save!
          business
        end
      end
    end
  end
end
