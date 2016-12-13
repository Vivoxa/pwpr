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

          business ||= create_business(row, npwd)
          business
        end

        def map
          map_loader.load(:registrations)
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

          return boolean_column_value(value) if %w(Y N).include? value
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
end
